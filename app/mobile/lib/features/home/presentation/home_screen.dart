import 'package:flutter/material.dart';

import '../../../design/app_chrome.dart';
import '../../../design/palette.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            const AppLargeHeader(title: '홈'),
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
                    '메인 화면',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '여기에 앱의 핵심 콘텐츠를 구성하세요.',
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
