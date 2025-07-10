import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/accounts/domain/repository/i_accounts_repository.dart';
import 'package:yandex_school_homework/features/transactions/domain/repository/i_transactions_repository.dart';

class BackupCubit extends Cubit<bool> {
  final Connectivity _connectivity;
  final IAccountsRepository _accountsRepository;
  final ITransactionsRepository _transactionsRepository;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  BackupCubit({
    required Connectivity connectivity,
    required IAccountsRepository accountsRepository,
    required ITransactionsRepository transactionsRepository,
  })  : _connectivity = connectivity,
        _accountsRepository = accountsRepository,
        _transactionsRepository = transactionsRepository,
        super(true) {
    _init();
  }

  Future<void> _init() async {
    await _checkConnection();
    _subscription = _connectivity.onConnectivityChanged.listen(
          (results) => _checkConnection(results: results),
    );
  }

  Future<void> _checkConnection({List<ConnectivityResult>? results}) async {
    try {
      final connectionResults = results ?? await _connectivity.checkConnectivity();
      final isConnected = _determineConnectionStatus(connectionResults);
      emit(isConnected);

      if (isConnected) {
        await _syncData();
      }
    } catch (_) {
      emit(false);
    }
  }

  Future<void> _syncData() async {
    try {
      await _accountsRepository.syncPendingChanges();
      await _transactionsRepository.syncPendingChanges();
    } catch (e) {
      rethrow;
    }
  }

  bool _determineConnectionStatus(List<ConnectivityResult> results) {
    return results.any((result) =>
    result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}