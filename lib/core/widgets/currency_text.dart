import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';

class CurrencyText extends StatelessWidget {
  final double amount;
  final TextStyle? style;
  final int decimalDigits;
  final bool showSign;

  const CurrencyText(
    this.amount, {
    super.key,
    this.style,
    this.decimalDigits = 2,
    this.showSign = false,
  });

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'BIRR':
        return 'Br';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'INR':
        return '₹';
      case 'CNY':
        return '¥';
      default:
        return 'Br';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final currencyCode = state.user?.currency ?? 'BIRR';
        final currencySymbol = _getCurrencySymbol(currencyCode);

        final formatter = NumberFormat.currency(
          symbol: currencySymbol,
          decimalDigits: decimalDigits,
        );

        final isPositive = amount >= 0;
        final prefix = showSign ? (isPositive ? '+' : '-') : '';
        final displayAmount = amount.abs();

        return Text(
          '$prefix${formatter.format(displayAmount)}',
          style: style,
        );
      },
    );
  }
}
