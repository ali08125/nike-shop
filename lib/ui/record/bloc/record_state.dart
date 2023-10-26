part of 'record_bloc.dart';

abstract class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object> get props => [];
}

class RecordInitial extends RecordState {}

class RecordSuccess extends RecordState {
  final List<Record> record;

  const RecordSuccess(this.record);

  @override
  List<Object> get props => [record];
}

class RecordLoading extends RecordState {}

class RecordError extends RecordState {
  final AppExceptions exception;

  const RecordError(this.exception);

  @override
  List<Object> get props => [exception];
}
