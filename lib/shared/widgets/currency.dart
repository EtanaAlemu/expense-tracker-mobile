import 'package:flutter/material.dart';

class CurrencyText extends StatelessWidget {
  final double? amount;
  final String? prefix;
  final TextStyle? style;

  const CurrencyText(
    this.amount, {
    super.key,
    this.prefix,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final displayAmount = amount ?? 0.0;
    return Text(
      '$prefix${displayAmount.toStringAsFixed(2)} Birr',
      style: style,
    );
  }
}
