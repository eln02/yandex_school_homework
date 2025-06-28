import 'package:flutter/material.dart';
import 'package:yandex_school_homework/app/app_context_ext.dart';
import 'package:yandex_school_homework/app/theme/app_colors_scheme.dart';
import 'package:yandex_school_homework/features/common/ui/custom_app_bar.dart';
import 'package:yandex_school_homework/features/transactions/domain/entity/category_analysis_entity.dart';
import 'package:yandex_school_homework/features/transactions/presentation/componenets/transactions_list.dart';

/// Экран транзакций по категории
class TransactionsByCategoryScreen extends StatelessWidget {
  const TransactionsByCategoryScreen({super.key, required this.category});

  // TODO: переделать на передачу только id категории в экран
  final CategoryAnalysisEntity category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: category.name,
        showBackButton: true,
        color: context.colors.mainBackground,
      ),
      body: TransactionsList(transactions: category.transactions),
    );
  }
}
