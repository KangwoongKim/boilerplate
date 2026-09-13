import 'package:boilerplate/app/app.dart';
import 'package:boilerplate/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    Size logical = const Size(390, 844),
    double dpr = 3,
    ThemeMode themeMode = ThemeMode.light,
  }) async {
    tester.view.physicalSize = Size(logical.width * dpr, logical.height * dpr);
    tester.view.devicePixelRatio = dpr;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWith(() => _FixedSettings(themeMode)),
        ],
        child: const MobileApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('홈 화면과 하단 탭이 표시된다', (tester) async {
    await pumpApp(tester);

    expect(find.text('홈'), findsWidgets);
    expect(find.text('탐색'), findsWidgets);
    expect(find.text('메인 화면'), findsOneWidget);
    expect(find.byTooltip('설정'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('탭 전환과 설정 화면 이동이 동작한다', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('설정'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('테마'), findsWidgets);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));

    await tester.tap(find.byKey(const Key('tab-explore')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('탐색 화면'), findsOneWidget);

    await tester.tap(find.byKey(const Key('tab-home')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('메인 화면'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FixedSettings extends AppSettingsNotifier {
  _FixedSettings(this.mode);
  final ThemeMode mode;

  @override
  AppSettings build() => AppSettings(themeMode: mode);
}
