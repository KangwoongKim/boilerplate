import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'palette.dart';

class AppLargeHeader extends StatelessWidget {
  const AppLargeHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showProfile = true,
    this.sceneForeground,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showProfile;
  final Color? sceneForeground;

  @override
  Widget build(BuildContext context) {
    final titleStyle = sceneForeground != null
        ? Theme.of(context).textTheme.displaySmall?.copyWith(
            color: sceneForeground,
          )
        : Theme.of(context).textTheme.displaySmall;
    final subtitleStyle = sceneForeground != null
        ? Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: sceneForeground!.withValues(alpha: 0.72),
          )
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: subtitleStyle),
                ],
              ],
            ),
          ),
          ...?actions,
          if (showProfile) ...[
            if (actions != null) const SizedBox(width: AppSpacing.xs),
            ProfileButton(sceneForeground: sceneForeground),
          ],
        ],
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key, this.sceneForeground});

  final Color? sceneForeground;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final onScene = sceneForeground != null;
    final lightHeaderText =
        onScene && sceneForeground!.computeLuminance() > 0.5;

    return Tooltip(
      message: '설정',
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => context.push('/settings'),
          child: Ink(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: onScene
                  ? lightHeaderText
                        ? Colors.black.withValues(alpha: 0.22)
                        : Colors.white.withValues(alpha: 0.72)
                  : dark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.72),
              border: Border.all(
                color: onScene
                    ? lightHeaderText
                          ? Colors.black.withValues(alpha: 0.12)
                          : Colors.white.withValues(alpha: 0.88)
                    : dark
                    ? Colors.white.withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.88),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: onScene ? 0.1 : (dark ? 0.28 : 0.08),
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline,
              size: 20,
              color: onScene
                  ? (lightHeaderText
                        ? Colors.white.withValues(alpha: 0.95)
                        : palette.textPrimary)
                  : palette.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class GlassTabDestination {
  const GlassTabDestination({
    required this.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final Key key;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class GlassTabBar extends StatefulWidget {
  const GlassTabBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.pulseIndex,
  });

  static const barHeight = 68.0;
  static const topGap = 8.0;
  static const sideInset = 16.0;
  /// 탭 영역 안쪽 여백 — 항목 간격만 줄이고 바 위치(sideInset)는 유지.
  static const barContentInset = 14.0;
  static const itemInset = 1.0;

  static double safeBottomInset(BuildContext context) {
    final view = View.of(context);
    return view.padding.bottom / view.devicePixelRatio;
  }

  static double occupiedHeight(BuildContext context) {
    final bottom = safeBottomInset(context);
    return topGap + barHeight + (bottom > 0 ? bottom : AppSpacing.sm);
  }

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<GlassTabDestination> destinations;
  final int? pulseIndex;

  @override
  State<GlassTabBar> createState() => _GlassTabBarState();
}

class _GlassTabBarState extends State<GlassTabBar>
    with TickerProviderStateMixin {
  late final AnimationController _liquid;
  late final AnimationController _pulse;
  late double _fromIndex;
  late double _toIndex;

  @override
  void initState() {
    super.initState();
    _fromIndex = widget.selectedIndex.toDouble();
    _toIndex = _fromIndex;
    _liquid = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
      value: 1,
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant GlassTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pulseIndex != widget.pulseIndex) {
      _syncPulse();
    }
    if (oldWidget.selectedIndex == widget.selectedIndex) return;
    _fromIndex = _currentPosition;
    _toIndex = widget.selectedIndex.toDouble();
    _liquid.forward(from: 0);
  }

  void _syncPulse() {
    if (widget.pulseIndex != null) {
      _pulse.repeat();
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  double get _currentPosition {
    final progress = Curves.easeOutCubic.transform(_liquid.value);
    return _fromIndex + (_toIndex - _fromIndex) * progress;
  }

  @override
  void dispose() {
    _pulse.dispose();
    _liquid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bottom = GlassTabBar.safeBottomInset(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        GlassTabBar.sideInset,
        GlassTabBar.topGap,
        GlassTabBar.sideInset,
        bottom > 0 ? bottom : AppSpacing.sm,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.38 : 0.13),
              blurRadius: 30,
              spreadRadius: -4,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: dark
                      ? [
                          Colors.white.withValues(alpha: 0.20),
                          const Color(0xFF161616).withValues(alpha: 0.48),
                          Colors.white.withValues(alpha: 0.08),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.62),
                          Colors.white.withValues(alpha: 0.30),
                          Colors.white.withValues(alpha: 0.48),
                        ],
                  stops: const [0, 0.5, 1],
                ),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: dark
                      ? Colors.white.withValues(alpha: 0.24)
                      : Colors.white.withValues(alpha: 0.82),
                  width: 0.8,
                ),
              ),
              child: SizedBox(
                height: GlassTabBar.barHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GlassTabBar.barContentInset,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth =
                          constraints.maxWidth / widget.destinations.length;
                    return Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _liquid,
                          builder: (context, child) {
                            final raw = _liquid.value;
                            final stretch = math.sin(math.pi * raw) * 0.16;
                            final movingRight = _toIndex >= _fromIndex;
                            return Positioned(
                              left:
                                  itemWidth * _currentPosition +
                                  GlassTabBar.itemInset,
                              top: 5,
                              width: itemWidth - GlassTabBar.itemInset * 2,
                              bottom: 5,
                              child: Transform(
                                alignment: movingRight
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                transform: Matrix4.diagonal3Values(
                                  1 + stretch,
                                  1 - stretch * 0.12,
                                  1,
                                ),
                                child: child,
                              ),
                            );
                          },
                          child: _LiquidGlassSelection(dark: dark),
                        ),
                        Row(
                          children: [
                            for (var i = 0; i < widget.destinations.length; i++)
                              Expanded(
                                child: _GlassTabItem(
                                  destination: widget.destinations[i],
                                  selected: widget.selectedIndex == i,
                                  pulse: widget.pulseIndex == i ? _pulse : null,
                                  onTap: () => widget.onDestinationSelected(i),
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassSelection extends StatelessWidget {
  const _LiquidGlassSelection({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? [
                      Colors.white.withValues(alpha: 0.28),
                      Colors.white.withValues(alpha: 0.08),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.86),
                      Colors.white.withValues(alpha: 0.30),
                    ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: dark ? 0.25 : 0.84),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.24 : 0.10),
                blurRadius: 12,
                spreadRadius: -3,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: dark ? 0.08 : 0.68),
                blurRadius: 5,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassTabItem extends StatelessWidget {
  const _GlassTabItem({
    required this.destination,
    required this.selected,
    required this.onTap,
    this.pulse,
  });

  final GlassTabDestination destination;
  final bool selected;
  final VoidCallback onTap;
  final Animation<double>? pulse;

  static const _potionPulse = Color(0xFF0652DD);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final baseColor = selected ? palette.accent : palette.textSecondary;
    final pulseAnim = pulse;
    const pulseColor = _potionPulse;

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          selected || pulseAnim != null
              ? destination.selectedIcon
              : destination.icon,
          size: 22,
          color: baseColor,
        ),
        const SizedBox(height: 2),
        Text(
          destination.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: baseColor,
          ),
        ),
      ],
    );

    if (pulseAnim != null) {
      content = AnimatedBuilder(
        animation: pulseAnim,
        builder: (context, _) {
          final t = pulseAnim.value;
          final strength = 0.55 + 0.45 * (1 - (2 * t - 1).abs());
          final activeColor = Color.lerp(baseColor, pulseColor, strength)!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SpreadingGlow(
                progress: t,
                color: pulseColor,
                child: Icon(
                  destination.selectedIcon,
                  size: 22,
                  color: activeColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: activeColor,
                ),
              ),
            ],
          );
        },
      );
    }

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GlassTabBar.itemInset,
          vertical: 5,
        ),
        child: Material(
          key: destination.key,
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(28),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _SpreadingGlow extends StatelessWidget {
  const _SpreadingGlow({
    required this.progress,
    required this.color,
    required this.child,
  });

  final double progress;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          _halo(progress),
          _halo((progress + 0.48) % 1),
          child,
        ],
      ),
    );
  }

  Widget _halo(double t) {
    final fade = (1 - t).clamp(0.0, 1.0);
    return IgnorePointer(
      child: Transform.scale(
        scale: 0.5 + 1.65 * t,
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.95 * fade),
                color.withValues(alpha: 0.52 * fade),
                color.withValues(alpha: 0),
              ],
              stops: const [0.0, 0.48, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

BoxDecoration _liquidGlassDecoration({
  required bool dark,
  required BorderRadius borderRadius,
}) {
  return BoxDecoration(
    borderRadius: borderRadius,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: dark
          ? [
              Colors.white.withValues(alpha: 0.28),
              Colors.white.withValues(alpha: 0.08),
            ]
          : [
              Colors.white.withValues(alpha: 0.86),
              Colors.white.withValues(alpha: 0.30),
            ],
    ),
    border: Border.all(
      color: Colors.white.withValues(alpha: dark ? 0.25 : 0.84),
      width: 0.8,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: dark ? 0.24 : 0.10),
        blurRadius: 12,
        spreadRadius: -3,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: dark ? 0.08 : 0.68),
        blurRadius: 5,
        offset: const Offset(-2, -2),
      ),
    ],
  );
}

class LiquidGlassIconButton extends StatelessWidget {
  const LiquidGlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.size = 44,
    this.iconSize = 20,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final radius = size / 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: CircleBorder(),
            child: Ink(
              width: size,
              height: size,
              decoration: _liquidGlassDecoration(
                dark: dark,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor ?? palette.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LiquidGlassTextButton extends StatelessWidget {
  const LiquidGlassTextButton({
    super.key,
    required this.label,
    required this.onTap,
    this.textColor,
    this.backgroundColor,
    this.height = 44,
  });

  final String label;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final radius = height / 2;
    final fill = backgroundColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Ink(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: fill != null
                  ? BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(radius),
                      boxShadow: [
                        BoxShadow(
                          color: fill.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    )
                  : _liquidGlassDecoration(
                      dark: dark,
                      borderRadius: BorderRadius.circular(radius),
                    ),
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: textColor ?? palette.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
