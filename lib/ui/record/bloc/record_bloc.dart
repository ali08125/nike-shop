import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/record.dart';
import 'package:nike/data/repo/order_repository.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final IOrderRepository orderRepository;
  RecordBloc({required this.orderRepository}) : super(RecordInitial()) {
    on<RecordEvent>((event, emit) async {
      if (event is RecordStarted) {
        emit(RecordLoading());
        try {
          final record = await orderRepository.getRecords();
          emit(RecordSuccess(record));
        } catch (e) {
          emit(RecordError(AppExceptions()));
        }
      }
    });
  }
}
