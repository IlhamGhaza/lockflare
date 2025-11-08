import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lockflare/data/github_service.dart';
import 'package:lockflare/presentation/controllers/home_controller.dart';
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
  FakeGitHubService(this.result)
      : super(
          storage: GetStorage('integration_test_storage'),
        );

  final GitHubStatsResult result;

  @override
  Future<GitHubStatsResult> getUserStats(String username) async {
    return result;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    await GetStorage.init('integration_test_storage');
  });

  setUp(() async {
    Get.testMode = true;
    await GetStorage('integration_test_storage').erase();
  });

  tearDown(() {
    Get.reset();
  });

  group('Integration flow', () {
    test('home controller encryption then profile stats fetch', () async {
      final homeController = HomeController(messageHandler: (_) {});
      homeController.inputController.text = 'HI';
      homeController.keyController.text = '1234';
      homeController.selectedAlgorithm.value = 'Hill Cipher (2x2)';

      await homeController.process();

      expect(homeController.outputText.value, startsWith('Hasil Hill Cipher (2x2): '));
      expect(homeController.steps.value, contains('Ciphertext'));

      final profileController = ProfileController(
        gitHubService: FakeGitHubService(
          GitHubStatsResult(
            data: {
              'followers': 1,
              'public_repos': 2,
              'stars': 3,
              'avatar_url': '',
              'name': 'Tester',
            },
            fromCache: false,
            isStale: false,
          ),
        ),
        urlLauncher: (uri) async => true,
      );

      await profileController.loadGitHubStats();

      expect(profileController.githubStats.value?.data['name'], 'Tester');
      expect(profileController.isLoading.value, isFalse);
    });
  });
}
