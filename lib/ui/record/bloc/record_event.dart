part of 'record_bloc.dart';

abstract class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object> get props => [];
}

class RecordStarted extends RecordEvent{
  
}