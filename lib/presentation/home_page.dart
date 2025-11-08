import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../config/theme/theme_controller.dart';
import '../config/theme/theme.dart';
import 'controllers/algorithm_registry.dart';
import 'controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final themeController = Get.find<ThemeController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            // Modern Minimalist App Bar
            SliverAppBar(
              expandedHeight: isWideScreen ? 200 : 160,
              floating: false,
              pinned: true,
              stretch: true,
              backgroundColor: theme.colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'app_title'.tr,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: isWideScreen ? 80 : 60,
                      color: Colors.white.withValues(alpha: 0.3),
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
                        // Input Section
                        _buildSection(
                          theme: theme,
                          title: 'input_text'.tr,
                          icon: Icons.edit_note_rounded,
                          child: Column(
                            children: [
                              TextField(
                                controller: controller.inputController,
                                maxLength: controller.getMaxLength(),
                                style: theme.textTheme.bodyLarge,
                                decoration: InputDecoration(
                                  hintText: controller.getInputHint(),
                                  counterStyle: theme.textTheme.bodySmall,
                                  prefixIcon: Icon(
                                    Icons.text_fields_rounded,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: controller.keyController,
                                maxLength: controller.getKeyMaxLength(),
                                style: theme.textTheme.bodyLarge,
                                decoration: InputDecoration(
                                  hintText: controller.getKeyHint(),
                                  counterStyle: theme.textTheme.bodySmall,
                                  prefixIcon: Icon(
                                    Icons.key_rounded,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  if (controller.getKeyMaxLength() != null)
                                    LengthLimitingTextInputFormatter(
                                      controller.getKeyMaxLength()!,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Algorithm Selection
                        _buildSection(
                          theme: theme,
                          title: 'select_algorithm'.tr,
                          icon: Icons.science_outlined,
                          child: DropdownButtonFormField<String>(
                            initialValue: controller.selectedAlgorithm.value,
                            style: theme.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              hintText: 'choose_algorithm'.tr,
                              prefixIcon: Icon(
                                Icons.calculate_outlined,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            items: AlgorithmRegistry.names.map((algorithm) {
                                  return DropdownMenuItem(
                                    value: algorithm,
                                    child: Text(
                                      algorithm,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              controller.selectedAlgorithm.value = value;
                            },
                            isExpanded: true,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Process Button
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: controller.isProcessing.value
                                ? null
                                : controller.process,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: theme.colorScheme.primary
                                  .withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: controller.isProcessing.value
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'process'.tr,
                                        style: theme.textTheme.labelLarge,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Output Section
                        _buildSection(
                          theme: theme,
                          title: 'result'.tr,
                          icon: Icons.output_rounded,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              controller.outputText.value.isEmpty
                                  ? 'results_appear'.tr
                                  : controller.outputText.value,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontFamily: 'monospace',
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Steps Section
                        _buildSection(
                          theme: theme,
                          title: 'steps'.tr,
                          icon: Icons.list_alt_rounded,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.secondary.withValues(
                                  alpha: 0.1,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              controller.steps.value.isEmpty
                                  ? 'steps_appear'.tr
                                  : controller.steps.value,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                                height: 1.6,
                              ),
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
}
