import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/storage/storageState.dart';
import 'package:habitmaker/model/habit.dart';
import 'package:habitmaker/services/hiveStorage.dart';


class Archivedstoragecubit extends Cubit<StorageState>{
  final Hivestorage storage;
  Archivedstoragecubit(this.storage) : super(StorageInitial());

  Future<void> archivedEntries()async{
    emit(StorageLoading());
    try {
      final entries = await storage.getArchivedEntries();
      emit(StorageLoaded(entries));
    } catch (e) {
      emit(StorageError(e.toString()));
    }
  }
  Future<void> archiveHabit(Habit habit)async{
    await storage.archiveHabit(habit);
    await archivedEntries();
  }
  Future<void> archiveDel(Habit habit)async{
    await storage.deleteArchive(habit);
    await archivedEntries();
  }
}