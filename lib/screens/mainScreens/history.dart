import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/storage/archivedStorageCubit.dart';
import 'package:habitmaker/BLoC/storage/storageState.dart';
import 'package:habitmaker/model/habit.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void delete(BuildContext context,Habit habit){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Delete archive ?"),
      content: Text("Do you want to delete the archive '${habit.habit}'?"),
      actions: [        
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child:const Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: ()async{
          await context.read<Archivedstoragecubit>().archiveDel(habit);
          Navigator.of(context).pop();
        }, child:const Text("Yes",style: TextStyle(color: Colors.white),)),
      ],
    );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Theme.of(context).colorScheme.surface,Color.fromARGB(255, 52, 41, 83)],
        begin: AlignmentGeometry.topCenter,
        end: AlignmentGeometry.bottomCenter
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        
        body: BlocBuilder<Archivedstoragecubit,StorageState>(builder:(context,state){
          if(state is StorageLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(state is StorageError){
            return Text(state.message);
          }
          if(state is StorageLoaded){
            if(state.entries.isEmpty){
              return const Center(child: Text("Nothing archived"),);
            }
            return ListView.builder(itemCount: state.entries.length, itemBuilder:(context, index){
              final entry = state.entries[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: const Color.fromARGB(255, 0, 0, 0),blurRadius: 16,
                      offset: const Offset(4, 8),
                    )],
                    gradient: LinearGradient(colors: [const Color.fromARGB(255, 20, 15, 38),
                      const Color.fromARGB(255, 12, 10, 25),]),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30,width: 1.2, style: BorderStyle.solid)
                  ),
                  child: ListTile(
                    leading: Text("Days\n ${entry.days}"),
                    title: Text(entry.habit),
                    subtitle: Text(entry.desc),
                    trailing: IconButton(onPressed: (){
                            delete(context, entry);
                          }, icon:const Icon(Icons.delete_rounded))
                  ),
                ),
              );
            });
          }
          return const SizedBox();
        })
      ),
    );
  }
}