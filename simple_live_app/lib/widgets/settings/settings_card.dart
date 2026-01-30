import 'package:flutter/material.dart';
import 'package:simple_live_app/app/app_style.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;
  const SettingsCard({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppStyle.radiusM,
      ),
      color: colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
