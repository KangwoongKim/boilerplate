import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../design/palette.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('설정'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('테마', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('시스템')),
              ButtonSegment(value: ThemeMode.light, label: Text('라이트')),
              ButtonSegment(value: ThemeMode.dark, label: Text('다크')),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (selection) {
              ref.read(appSettingsProvider.notifier).setThemeMode(selection.first);
            },
          ),
        ],
      ),
    );
  }
}
