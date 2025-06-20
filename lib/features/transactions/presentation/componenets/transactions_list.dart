import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/app/theme/texts_extension.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/transaction_response_entity.dart';

/// Список транзакций
class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
    required this.transactions,
    required this.onRefresh,
  });

  final List<TransactionResponseEntity> transactions;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        itemCount: transactions.length + 1,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: context.colors.transactionsDivider),
        itemBuilder: (context, index) {
          // добавление Divider под последним элементом
          if (index == transactions.length) {
            return const SizedBox.shrink();
          }
          return _TransactionTile(transaction: transactions[index]);
        },
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final TransactionResponseEntity transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(transaction.category.emoji, style: context.texts.emoji),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category.name,
                  style: context.texts.bodyLarge_,
                ),
                if (transaction.comment != null)
                  Text(
                    transaction.comment!,
                    style: context.texts.bodyMedium_.copyWith(
                      color: context.colors.onSurface_,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${transaction.formattedAmount} ${transaction.account.currency}',
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: context.colors.labelsTertiary,
          ),
        ],
      ),
    );
  }
}
