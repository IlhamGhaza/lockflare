import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lockflare/data/github_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async => Directory.systemTemp.path;

  @override
  Future<String?> getApplicationDocumentsPath() async => Directory.systemTemp.path;

  @override
  Future<String?> getApplicationSupportPath() async => Directory.systemTemp.path;
}

class FakeHttpClient extends http.BaseClient {
  FakeHttpClient({required this.userBody, required this.reposBody});

  final Map<String, dynamic> userBody;
  final List<Map<String, dynamic>> reposBody;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final uri = request.url.toString();
    late String body;
    if (uri.contains('/repos')) {
      body = jsonEncode(reposBody);
    } else {
      body = jsonEncode(userBody);
    }

    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      200,
      request: request,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    await GetStorage.init('github_service_test');
  });

  setUp(() async {
    Get.testMode = true;
    await GetStorage('github_service_test').erase();
  });

  tearDown(() {
    Get.reset();
  });

  group('GitHubService', () {
    test('returns fresh data when online', () async {
      final storage = GetStorage('github_service_test');
      final service = GitHubService(
        httpClient: FakeHttpClient(
          userBody: {
            'followers': 5,
            'public_repos': 2,
            'avatar_url': 'url',
            'name': 'Tester',
          },
          reposBody: [
            {'stargazers_count': 3},
            {'stargazers_count': 2},
          ],
        ),
        storage: storage,
        connectivityChecker: () async => true,
      );

      final result = await service.getUserStats('tester');

      expect(result.fromCache, isFalse);
      expect(result.data['stars'], 5);
      expect(result.isStale, isFalse);
    });

    test('returns cached data when offline', () async {
      final storage = GetStorage('github_service_test');
      await storage.write('github_stats:tester', {
        'data': {
          'followers': 1,
          'public_repos': 1,
          'stars': 1,
          'avatar_url': 'cache',
          'name': 'Cached',
        },
        'fetchedAt': DateTime.now().toIso8601String(),
      });

      final service = GitHubService(
        httpClient: FakeHttpClient(userBody: {}, reposBody: const []),
        storage: storage,
        connectivityChecker: () async => false,
      );

      final result = await service.getUserStats('tester');

      expect(result.fromCache, isTrue);
      expect(result.data['name'], 'Cached');
      expect(result.messageCode, 'stats_cached_offline');
    });
  });
}
