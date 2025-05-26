import 'package:flutter/material.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  bool _isUpcoming(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(date.year, date.month, date.day);
    return transactionDate.isAfter(today);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: 'Br',
      decimalDigits: 2,
    );

    final isUpcoming = _isUpcoming(transaction.date);

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        Category? category;
        if (state is CategoryLoaded) {
          category = state.categories?.firstWhere(
            (c) => c.id == transaction.categoryId,
            orElse: () => Category(
              id: '',
              name: 'Unknown',
              type: transaction.type,
              icon: Icons.help_outline,
              color: Colors.grey,
              userId: transaction.userId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 1),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Category Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (category?.color ?? Colors.grey).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      category?.icon ?? Icons.help_outline,
                      color: category?.color ?? Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Transaction Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                transaction.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isUpcoming)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Upcoming',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                category?.name ?? 'Unknown',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM d, y').format(transaction.date),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Amount
                  Text(
                    '${transaction.type == 'Expense' ? '-' : '+'}${currencyFormat.format(transaction.amount)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: transaction.type == 'Expense'
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
