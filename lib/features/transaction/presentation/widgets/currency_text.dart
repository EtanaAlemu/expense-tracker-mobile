import 'package:flutter/material.dart';

class CurrencyText extends StatelessWidget {
  final double amount;
  final TextStyle? style;
  final bool showSign;

  const CurrencyText(
    this.amount, {
    super.key,
    this.style,
    this.showSign = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final prefix = showSign ? (isPositive ? '+' : '-') : '';
    final displayAmount = amount.abs();

    return Text(
      '$prefix${displayAmount.toStringAsFixed(2)} Birr',
      style: style,
    );
  }
}
