import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/storage/storageState.dart';
import 'package:habitmaker/model/habit.dart';
import 'package:habitmaker/services/hiveStorage.dart';


class StorageCubit extends Cubit<StorageState>{
  final Hivestorage storage;
  StorageCubit(this.storage) : super(StorageInitial());

  Future<void> loadEntries() async{
    emit(StorageLoading());
    try {
      final entries = await storage.getEntries();
      emit(StorageLoaded(entries));
    } catch (e) {
      emit(StorageError(e.toString()));
    }
  }
  Future<void> loadArchivedEntries()async{
    emit(StorageLoading());
    try {
      final entries = await storage.getArchivedEntries();
      emit(StorageLoaded(entries));
    } catch (e) {
      emit(StorageError(e.toString()));
    }
  }
  Future<void> createHabit(
    String name,
    String date,
    String desc,
    int target
  )async{
    await storage.createHabit(name, date, desc,target);
    await loadEntries();
  }
  Future<void> archiveHabit(Habit habit)async{
    await storage.archiveHabit(habit);
    await loadEntries();
  }
}