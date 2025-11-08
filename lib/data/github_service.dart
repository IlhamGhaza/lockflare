import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class GitHubStatsResult {
  final Map<String, dynamic> data;
  final bool fromCache;
  final bool isStale;
  final String? messageCode;

  const GitHubStatsResult({
    required this.data,
    required this.fromCache,
    required this.isStale,
    this.messageCode,
  });
}

class GitHubServiceException implements Exception {
  final String code;
  final String message;

  const GitHubServiceException({
    required this.code,
    required this.message,
  });

  @override
  String toString() => message;
}

class GitHubService {
  static const String baseUrl = 'https://api.github.com/users/';
  static const String _cacheKeyPrefix = 'github_stats';
  static const Duration _cacheTtl = Duration(minutes: 30);
  static const Duration _requestTimeout = Duration(seconds: 10);

  final http.Client _httpClient;
  final Connectivity _connectivity;
  final Future<bool> Function()? _connectivityChecker;
  final GetStorage _storage;

  GitHubService({
    http.Client? httpClient,
    Connectivity? connectivity,
    GetStorage? storage,
    Future<bool> Function()? connectivityChecker,
  })  : _httpClient = httpClient ?? http.Client(),
        _connectivity = connectivity ?? Connectivity(),
        _storage = storage ?? GetStorage(),
        _connectivityChecker = connectivityChecker;

  Future<GitHubStatsResult> getUserStats(String username) async {
    final cacheKey = _cacheKey(username);
    final cachedPayload = _readCache(cacheKey);
    final Map<String, dynamic>? cachedData = cachedPayload['data'] as Map<String, dynamic>?;
    final DateTime? fetchedAt = cachedPayload['fetchedAt'] as DateTime?;
    final cacheAge = fetchedAt != null ? DateTime.now().difference(fetchedAt) : null;
    final cacheIsFresh = cacheAge != null && cacheAge <= _cacheTtl;

    final hasConnectivity = await _hasConnectivity();
    if (!hasConnectivity) {
      if (cachedData != null) {
        return GitHubStatsResult(
          data: cachedData,
          fromCache: true,
          isStale: !cacheIsFresh,
          messageCode: cacheIsFresh
              ? 'stats_cached_offline'
              : 'stats_cached_stale_offline',
        );
      }

      throw const GitHubServiceException(
        code: 'stats_error_offline_no_cache',
        message: 'Offline and no cached GitHub data available.',
      );
    }

    if (cachedData != null && cacheIsFresh) {
      return GitHubStatsResult(
        data: cachedData,
        fromCache: true,
        isStale: false,
      );
    }

    try {
      final headers = {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'LockFlareApp',
      };

      final userResponse = await _httpClient
          .get(Uri.parse('$baseUrl$username'), headers: headers)
          .timeout(_requestTimeout);
      final reposResponse = await _httpClient
          .get(Uri.parse('$baseUrl$username/repos'), headers: headers)
          .timeout(_requestTimeout);

      if (userResponse.statusCode != 200 || reposResponse.statusCode != 200) {
        final errorCode = _mapStatusToErrorCode(
          userResponse.statusCode,
          reposResponse.statusCode,
        );
        throw GitHubServiceException(
          code: errorCode,
          message:
              'Failed to load GitHub data (${userResponse.statusCode}/${reposResponse.statusCode}).',
        );
      }

      final userData = json.decode(userResponse.body) as Map<String, dynamic>;
      final reposList = json.decode(reposResponse.body) as List;

      final totalStars = reposList.fold<int>(
        0,
        (sum, repo) => sum + (repo['stargazers_count'] as int? ?? 0),
      );

      final stats = <String, dynamic>{
        'followers': userData['followers'] ?? 0,
        'public_repos': userData['public_repos'] ?? 0,
        'stars': totalStars,
        'avatar_url': userData['avatar_url'] ?? '',
        'name': userData['name'] ?? username,
      };

      await _writeCache(cacheKey, stats);

      return GitHubStatsResult(
        data: stats,
        fromCache: false,
        isStale: false,
      );
    } on GitHubServiceException catch (e) {
      if (cachedData != null) {
        return GitHubStatsResult(
          data: cachedData,
          fromCache: true,
          isStale: true,
          messageCode: _mapErrorCodeToFallback(e.code),
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Error fetching GitHub stats: $e\n$stackTrace');
      if (cachedData != null) {
        return GitHubStatsResult(
          data: cachedData,
          fromCache: true,
          isStale: true,
          messageCode: 'stats_cached_rate_limited',
        );
      }
      throw const GitHubServiceException(
        code: 'stats_error_unknown',
        message: 'Unexpected error while loading GitHub stats.',
      );
    }
  }

  String _cacheKey(String username) => '$_cacheKeyPrefix:$username';

  Map<String, Object?> _readCache(String cacheKey) {
    final payload = _storage.read(cacheKey);
    if (payload is Map) {
      final data = payload['data'];
      final fetchedAtRaw = payload['fetchedAt'] as String?;
      DateTime? fetchedAt;
      if (fetchedAtRaw != null) {
        fetchedAt = DateTime.tryParse(fetchedAtRaw);
      }
      return {
        'data': data is Map
            ? Map<String, dynamic>.from(data.cast<String, dynamic>())
            : null,
        'fetchedAt': fetchedAt,
      };
    }
    return const {'data': null, 'fetchedAt': null};
  }

  Future<void> _writeCache(String cacheKey, Map<String, dynamic> data) async {
    await _storage.write(cacheKey, {
      'data': data,
      'fetchedAt': DateTime.now().toIso8601String(),
    });
  }

  String _mapStatusToErrorCode(int userStatus, int repoStatus) {
    if (userStatus == 403 || repoStatus == 403) {
      return 'stats_error_rate_limited';
    }
    if (userStatus == 404) {
      return 'stats_error_not_found';
    }
    return 'stats_error_unknown';
  }

  String _mapErrorCodeToFallback(String code) {
    switch (code) {
      case 'stats_error_rate_limited':
        return 'stats_cached_rate_limited';
      case 'stats_error_not_found':
        return 'stats_cached';
      default:
        return 'stats_cached_rate_limited';
    }
  }

  Future<bool> _hasConnectivity() async {
    final checker = _connectivityChecker;
    if (checker != null) {
      return checker();
    }

    final dynamic result = await _connectivity.checkConnectivity();

    if (result is List<ConnectivityResult>) {
      return result.any((entry) => entry != ConnectivityResult.none);
    }

    if (result is ConnectivityResult) {
      return result != ConnectivityResult.none;
    }

    return false;
  }
}
