import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lockflare/data/github_service.dart';
import 'package:lockflare/presentation/controllers/profile_controller.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async => Directory.systemTemp.path;

  @override
  Future<String?> getApplicationDocumentsPath() async => Directory.systemTemp.path;

  @override
  Future<String?> getApplicationSupportPath() async => Directory.systemTemp.path;
}

class FakeGitHubService extends GitHubService {
  FakeGitHubService(this.result, {this.shouldThrow = false, Future<bool> Function()? connectivity})
      : super(
          storage: GetStorage('profile_controller_test'),
          connectivityChecker: connectivity ?? () async => true,
        );

  final GitHubStatsResult result;
  final bool shouldThrow;

  @override
  Future<GitHubStatsResult> getUserStats(String username) async {
    if (shouldThrow) {
      throw const GitHubServiceException(
        code: 'stats_error_offline_no_cache',
        message: 'Offline and no cached GitHub data available.',
      );
    }
    return result;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    await GetStorage.init('profile_controller_test');
  });

  setUp(() async {
    Get.testMode = true;
    await GetStorage('profile_controller_test').erase();
  });

  tearDown(() {
    Get.reset();
  });

  group('ProfileController', () {
    test('loads stats successfully', () async {
      final fakeResult = GitHubStatsResult(
        data: {
          'followers': 10,
          'public_repos': 5,
          'stars': 3,
          'avatar_url': 'avatar',
          'name': 'Tester',
        },
        fromCache: false,
        isStale: false,
        messageCode: 'stats_cached',
      );

      final controller = ProfileController(
        gitHubService: FakeGitHubService(fakeResult),
        urlLauncher: (uri) async => true,
      );
      await controller.loadGitHubStats();

      expect(controller.isLoading.value, isFalse);
      expect(controller.error.value, isNull);
      expect(controller.githubStats.value, equals(fakeResult));
      expect(controller.statusMessageKey, equals('stats_cached'));
    });

    test('handles service exception', () async {
      final controller = ProfileController(
        gitHubService: FakeGitHubService(
          GitHubStatsResult(
            data: {},
            fromCache: false,
            isStale: false,
          ),
          shouldThrow: true,
          connectivity: () async => false,
        ),
        urlLauncher: (uri) async => true,
      );

      await controller.loadGitHubStats();

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorCode.value, equals('stats_error_offline_no_cache'));
      expect(controller.githubStats.value, isNull);
    });

    test('launchURL throws when unable to launch', () async {
      final controller = ProfileController(urlLauncher: (uri) async => false);
      expect(
        controller.launchURL('invalid://url'),
        throwsException,
      );
    });
  });
}
