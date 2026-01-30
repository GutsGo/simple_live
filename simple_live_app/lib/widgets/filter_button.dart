import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final bool selected;
  final String text;
  final Function()? onTap;

  const FilterButton({
    this.selected = false,
    required this.text,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      label: Text(text),
      onSelected: onTap != null ? (_) => onTap!() : null,
      showCheckmark: false,
    );
  }
}
