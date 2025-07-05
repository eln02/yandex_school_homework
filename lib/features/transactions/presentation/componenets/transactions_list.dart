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
    this.onRefresh,
    this.onTapTransaction,
  });

  final List<TransactionResponseEntity> transactions;
  final Future<void> Function()? onRefresh;
  final void Function(TransactionResponseEntity)? onTapTransaction;

  @override
  Widget build(BuildContext context) {
    final listView = ListView.separated(
      itemCount: transactions.length + 1,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: context.colors.transactionsDivider),
      itemBuilder: (context, index) {
        if (index == transactions.length) {
          return const SizedBox.shrink();
        }
        final transaction = transactions[index];
        return _TransactionTile(
          transaction: transaction,
          onTap: onTapTransaction,
        );
      },
    );

    if (onRefresh == null) return listView;

    return RefreshIndicator(onRefresh: onRefresh!, child: listView);
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction, this.onTap});

  final TransactionResponseEntity transaction;
  final void Function(TransactionResponseEntity)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(transaction),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: context.colors.mainBackground,
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
      ),
    );
  }
}
