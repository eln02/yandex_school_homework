import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_school_homework/features/debug/debug_repository.dart';

/// Тестовый кубит чтобы проверить ретраи при ошибке 500
class DebugCubit extends Cubit<DebugState> {
  final DebugRepository _repository;

  DebugCubit(this._repository) : super(DebugInitial());

  Future<void> trigger500Error() async {
    emit(DebugLoading());
    try {
      await _repository.get500error();
      emit(DebugSuccess());
    } catch (e) {
      emit(DebugError(e.toString()));
    }
  }
}

sealed class DebugState {}

class DebugInitial extends DebugState {}

class DebugLoading extends DebugState {}

class DebugSuccess extends DebugState {}

class DebugError extends DebugState {
  final String message;

  DebugError(this.message);
}
