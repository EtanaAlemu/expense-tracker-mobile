import 'package:flutter/material.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/core/widgets/currency_text.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction.type.toLowerCase() == 'income';

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: (isIncome ? Colors.green : Colors.red).withOpacity(0.1),
        ),
        child: Icon(
          isIncome ? Icons.arrow_upward : Icons.arrow_downward,
          size: 22,
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
      title: Text(
        transaction.description.isEmpty
            ? 'No description'
            : transaction.description,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: DateFormat("dd MMM yyyy, HH:mm").format(transaction.date),
            ),
          ],
        ),
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.grey,
        ),
      ),
      trailing: CurrencyText(
        isIncome ? transaction.amount : -transaction.amount,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
