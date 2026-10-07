import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/storage/storageCubit.dart';
import 'package:habitmaker/BLoC/storage/storageState.dart';
import 'package:habitmaker/components/activeHabitCard.dart';

class CurrentActivitiesScreen extends StatefulWidget {
  const CurrentActivitiesScreen({super.key});

  @override
  State<CurrentActivitiesScreen> createState() => _CurrentActivitiesScreenState();
}

class _CurrentActivitiesScreenState extends State<CurrentActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    //final screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Theme.of(context).colorScheme.surface,Color.fromARGB(255, 52, 41, 83)],
        begin: AlignmentGeometry.topCenter,
        end: AlignmentGeometry.bottomCenter
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // body: Center(
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20)
      
        //     ),
            
        //     height: screenHeight-300,
        //     child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     physics: const PageScrollPhysics(),
        //     itemCount: habits.length,itemBuilder: (context,index){
        //     final habit = habits[index];
        //     return Padding(
        //       padding: const EdgeInsets.only(right: 8),
        //       child: Activehabitcard(habit: habit.habit,days: habit.days),
        //     );
        //   }),
        //   )
        // ),
        body: BlocBuilder<StorageCubit,StorageState>(builder:(context,state){
          if(state is StorageLoading){
            print("storage loading");
            return const CircularProgressIndicator();
          }
          if(state is StorageError){
            print("error baby: ${state.message}");
          return Text(state.message);
          }
          if(state is StorageLoaded){
            if(state.entries.isEmpty){
                    return const Center(child: Text("No Habits created..."),);
                  }
            print("no erroro");
            return Center(
              child: Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
              ),
                  height: screenHeight-300,
                  child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.entries.length,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context,index){
                  
                  final entry = state.entries[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Activehabitcard(habit: entry,),
                  );
                }),
              ),
            );
          }
          return const SizedBox(child: Text("screwed something"),);
      
        }),
      ),
      );
  }
}