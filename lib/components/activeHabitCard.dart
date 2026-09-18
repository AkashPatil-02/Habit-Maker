import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/storage/archivedStorageCubit.dart';
import 'package:habitmaker/BLoC/storage/storageCubit.dart';
import 'package:habitmaker/model/habit.dart';
import 'package:habitmaker/screens/activityDetail.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/services.dart';

class Activehabitcard extends StatelessWidget {
  final Habit habit;
   const Activehabitcard({super.key, required this.habit});

  void archive(BuildContext context){
     showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
      title: const Text("Archive habit ?"),
      actions: [
        ElevatedButton(onPressed: ()async{
          await context.read<StorageCubit>().archiveHabit(habit);
          await context.read<Archivedstoragecubit>().archivedEntries();
          Navigator.of(context).pop();
        }, child:const Text("Yes")),
        
        ElevatedButton(onPressed: (){
          Navigator.of(context).pop();
        }, child:const Text("No")),
      ],
    );
    });
  }
  int checkCompletion(){
    if(habit.days>=habit.target){
      return habit.target;
    }
    return habit.days;
  }
  Color progressbarColor(int days, int target){
    if((days/target)*100<=25){
      return Colors.red;
    }
    if((days/target)*100<=50){
      return Colors.orange;
    }
    if((days/target)*100<=75){
      return Colors.yellow;
    }
    if((days/target)*100<=99){
      return Colors.green;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ActivitydetailScreen(habit: habit.habit,days: habit.days,)));
      },
      child: Container(
        decoration: BoxDecoration(
          color:Theme.of(context).colorScheme.onPrimary,
        ),
        width: screenWidth,
        height: 250,
        child: Stack(
          children:[
            Opacity(
              opacity: 0.3,
              child: Lottie.asset('assets/lottie files/fire.json',width: screenWidth)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [const Color.fromARGB(124, 0, 0, 0),Colors.black],
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter
                )
              ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(onPressed: (){
                        archive(context);
                        
                      }, icon: Icon(Icons.archive_outlined,size: 35,color: Colors.orange,)),
                    ),
                  ],
                ),
                CircularPercentIndicator(
                  radius: screenWidth-240,
                  lineWidth: 28,
                  animation: true,
                  percent: checkCompletion()/habit.target,
                  backgroundColor: Colors.grey,
                  progressColor: progressbarColor(habit.days, habit.target),
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${((checkCompletion()/habit.target)*100).toStringAsFixed(2)} %\n Target: ${habit.target}",textAlign: TextAlign.center,),                  
                    ],
                  ),
                ),
                SizedBox(height: 40,),
              Text(habit.habit,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              Text("Streak : ${habit.days.toString()} days"),
              SizedBox(height: 30,),
              Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Lottie.asset(
                            'assets/lottie files/completebg.json',
                            fit: BoxFit.cover,
                          ),
                          Material(
                            color: const Color.fromARGB(255, 175, 128, 233).withAlpha(15),
                            child: InkWell(
                              onTap: () async {
                                await HapticFeedback.vibrate();
                                // pending hive thing
                              },
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.done_outline_rounded, color: Colors.white),
                                    SizedBox(width: 6),
                                    Text(
                                      "C O M P L E T E",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                 ],),
            ),]
        ),
      ),
    );
  }
}