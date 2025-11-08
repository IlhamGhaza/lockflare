import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/theme/theme_controller.dart';
import '../config/theme/theme.dart';
import '../config/localization/language_controller.dart';
import 'controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());
    final themeController = Get.find<ThemeController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
      final statsData = controller.statsData;
      final statusMessageKey = controller.statusMessageKey;
      final statusMessage = statusMessageKey?.tr;

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            // Profile Header
            SliverAppBar(
              expandedHeight: isWideScreen ? 280 : 240,
              floating: false,
              pinned: true,
              stretch: true,
              backgroundColor: theme.colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: controller.isLoading.value
                              ? const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: CircularProgressIndicator(),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      statsData?['avatar_url'] != null &&
                                          (statsData?['avatar_url'] as String)
                                              .isNotEmpty
                                      ? NetworkImage(statsData!['avatar_url'])
                                      : null,
                                  child:
                                      statsData?['avatar_url'] == null ||
                                          (statsData?['avatar_url'] as String)
                                              .isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 50,
                                          color: theme.colorScheme.primary,
                                        )
                                      : null,
                                ),
                        ),
                        const SizedBox(height: 16),
                        // Name
                        Text(
                          statsData?['name'] ?? 'Loading...',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Username
                        Text(
                          '@IlhamGhaza',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 24 : 20,
                vertical: 24,
              ),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // About Me Section
                        _buildSection(
                          theme: theme,
                          title: 'about_me'.tr,
                          icon: Icons.person_outline_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'job_title'.tr,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Text('bio'.tr, style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // GitHub Stats Section
                        _buildSection(
                          theme: theme,
                          title: 'github_stats'.tr,
                          icon: Icons.code_rounded,
                          child: Builder(
                            builder: (context) {
                              if (controller.isLoading.value) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (controller.error.value != null) {
                                return Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.error_outline_rounded,
                                        size: 48,
                                        color: theme.colorScheme.error,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'error_loading_stats'.tr,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.error,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        controller.errorCode.value != null
                                            ? controller.errorCode.value!.tr
                                            : controller.error.value!,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 16),
                                      TextButton.icon(
                                        onPressed: controller.loadGitHubStats,
                                        icon: const Icon(Icons.refresh_rounded),
                                        label: Text('retry'.tr),
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Column(
                                children: [
                                  if (statusMessage != null)
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline_rounded,
                                            size: 20,
                                            color: theme.colorScheme.primary,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              statusMessage,
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStatItem(
                                        theme: theme,
                                        icon: Icons.star_rounded,
                                        label: 'stars'.tr,
                                        value:
                                            statsData?['stars'].toString() ??
                                            '0',
                                        color: theme.colorScheme.primary,
                                      ),
                                      _buildStatItem(
                                        theme: theme,
                                        icon: Icons.folder_rounded,
                                        label: 'repositories'.tr,
                                        value:
                                            statsData?['public_repos']
                                                .toString() ??
                                            '0',
                                        color: theme.colorScheme.secondary,
                                      ),
                                      _buildStatItem(
                                        theme: theme,
                                        icon: Icons.people_rounded,
                                        label: 'followers'.tr,
                                        value:
                                            statsData?['followers']
                                                .toString() ??
                                            '0',
                                        color: theme.colorScheme.primary,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Theme Toggle
                        _buildSettingTile(
                          theme: theme,
                          icon: isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          title: 'dark_mode'.tr,
                          trailing: Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              themeController.setThemeMode(
                                value ? ThemeMode.dark : ThemeMode.light,
                              );
                            },
                            activeColor: theme.colorScheme.primary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Language Selector
                        _buildSettingTile(
                          theme: theme,
                          icon: Icons.language_rounded,
                          title: 'Language',
                          trailing: DropdownButton<String>(
                            value: Get.locale?.languageCode ?? 'en',
                            underline: const SizedBox(),
                            borderRadius: BorderRadius.circular(12),
                            style: theme.textTheme.bodyMedium,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                final langController =
                                    Get.find<LanguageController>();
                                langController.changeLanguage(newValue);
                              }
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                              DropdownMenuItem(
                                value: 'id',
                                child: Text('Indonesia'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Buy Me a Coffee Button
                        InkWell(
                          onTap: () {
                            controller.launchURL(
                              'https://www.buymeacoffee.com/IlhamGhaza',
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFDB58), Color(0xFFFFAA00)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFFAA00,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.coffee_rounded,
                                  color: Color(0xFF5D4037),
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'buy_coffee'.tr,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFF5D4037),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title, style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
          trailing,
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
