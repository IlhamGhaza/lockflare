import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/github_service.dart';

class ProfileController extends GetxController {
  ProfileController({
    GitHubService? gitHubService,
    Future<bool> Function(Uri uri)? urlLauncher,
  })  : _gitHubService = gitHubService ?? GitHubService(),
        _launchUrl = urlLauncher ?? launchUrl;

  final GitHubService _gitHubService;
  final Future<bool> Function(Uri uri) _launchUrl;
  
  final githubStats = Rxn<GitHubStatsResult>();
  final isLoading = true.obs;
  final error = Rxn<String>();
  final errorCode = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadGitHubStats();
  }

  Future<void> loadGitHubStats() async {
    try {
      isLoading.value = true;
      error.value = null;
      errorCode.value = null;

      print('Starting to load GitHub stats...');
      final statsResult = await _gitHubService.getUserStats('ilhamghaza');
      print('Received stats: ${statsResult.data} (from cache: ${statsResult.fromCache})');

      githubStats.value = statsResult;
      error.value = null;
      errorCode.value = null;
      isLoading.value = false;
    } on GitHubServiceException catch (e) {
      print('GitHubServiceException: $e');
      error.value = e.message;
      errorCode.value = e.code;
      githubStats.value = null;
      isLoading.value = false;
    } catch (e, stackTrace) {
      print('Error loading GitHub stats: $e');
      print('Stack trace: $stackTrace');
      error.value = e.toString();
      errorCode.value = 'stats_error_unknown';
      githubStats.value = null;
      isLoading.value = false;
    }
  }

  Future<void> launchURL(String url) async {
    if (!await _launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Map<String, dynamic>? get statsData => githubStats.value?.data;
  String? get statusMessageKey => githubStats.value?.messageCode;
}
