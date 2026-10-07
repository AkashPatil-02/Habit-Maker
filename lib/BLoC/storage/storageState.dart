

import 'package:habitmaker/model/habit.dart';

sealed class StorageState {}

class StorageInitial extends StorageState {}

class StorageLoading extends StorageState {}

class StorageLoaded extends StorageState {
  final List<Habit> entries;

  StorageLoaded(this.entries);
}

class StorageError extends StorageState {
  final String message;

  StorageError(this.message);
}