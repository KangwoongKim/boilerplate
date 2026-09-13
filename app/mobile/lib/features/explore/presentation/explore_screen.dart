import 'package:flutter/material.dart';

import '../../../design/app_chrome.dart';
import '../../../design/palette.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppLargeHeader(title: '탐색', showProfile: false),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  GlassTabBar.occupiedHeight(context) + AppSpacing.lg,
                ),
                children: [
                  Text(
                    '탐색 화면',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '두 번째 탭 화면 예시입니다.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
