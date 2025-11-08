// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lockflare/main.dart';
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


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    await GetStorage.init('widget_test_storage');
  });

  setUp(() async {
    Get.testMode = true;
    await GetStorage('widget_test_storage').erase();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final fakeService = _FakeGitHubService(
      GitHubStatsResult(
        data: {
          'followers': 0,
          'public_repos': 0,
          'stars': 0,
          'avatar_url': '',
          'name': 'Tester',
        },
        fromCache: true,
        isStale: false,
      ),
    );

    Get.put(ProfileController(gitHubService: fakeService, urlLauncher: (uri) async => true));

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Input Text'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('About Me'), findsOneWidget);
  });
}

class _FakeGitHubService extends GitHubService {
  _FakeGitHubService(this.result)
      : super(
          storage: GetStorage('widget_test_storage'),
          connectivityChecker: () async => true,
        );

  final GitHubStatsResult result;

  @override
  Future<GitHubStatsResult> getUserStats(String username) async => result;
}
