import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/storage/storageCubit.dart';
import 'package:habitmaker/components/inputField.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';
import 'package:wheel_slider/wheel_slider.dart';

class CreatehabitScreen extends StatefulWidget {
  const CreatehabitScreen({super.key});

  @override
  State<CreatehabitScreen> createState() => _CreatehabitScreenState();
}

class _CreatehabitScreenState extends State<CreatehabitScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final int _nTotalCount = 99;
  final int _nInitValue = 1;
  int _nCurrentValue=0;

  void createHabit() async {
  if (nameController.text.isEmpty || descController.text.isEmpty|| _nCurrentValue==0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("A field is empty or invalid.")),
    );
    return;
  }
  final now = DateTime.now();
  await context.read<StorageCubit>().createHabit(
    nameController.text,
    now.day.toString(),
    descController.text,
    _nCurrentValue
  );

  if (mounted) {
    Navigator.pop(context);
  }
}
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: const Text("Create Habit",style: TextStyle(fontSize: 16),)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          child: Form(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children:[ Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Text("First we make our habits, then our habits make us.",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                ),
                Opacity(
                  opacity: 0.3,
                  child: Lottie.asset('assets/lottie files/ab.json'))
                ]),
                const SizedBox(height: 70,),
                Inputfield(hint: "Habit Name",controller: nameController,),
                Inputfield(hint: "Description",controller: descController,),
                const SizedBox(height: 30,),
                WheelSlider.number(
                  horizontalListWidth: 500,
                      perspective: 0.01,
                      totalCount: _nTotalCount,
                      initValue: _nInitValue,
                      selectedNumberStyle: TextStyle(
                        fontSize: 20,
                        overflow: TextOverflow.visible,
                        fontWeight: FontWeight.bold
                      ),
                      unSelectedNumberStyle: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
      
                      currentIndex: _nCurrentValue,
      
                      onValueChanged: (val) async {
                        setState(() {
                          _nCurrentValue = val;
                        });
                        if (await Vibration.hasVibrator()) {
                          Vibration.vibrate(duration: 20);
                        }
                      },
                    ),
                    const SizedBox(height: 20,),
                  const Text("Select Target (no. of days)",style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
                
                const SizedBox(height: 60,),
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16),
                  child: SizedBox(
                    height: 60,
                    width: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Lottie.asset(
                            'assets/lottie files/completebg.json',
                            fit: BoxFit.cover,
                          ),
                          Material(
                            color: Colors.black.withAlpha(15),
                            child: InkWell(
                              onTap: ()async{
                                await HapticFeedback.vibrate();
                                createHabit();
                              },
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.electric_bolt_rounded),
                                    Text(" C R E A T E",style: TextStyle(fontWeight: FontWeight.bold),)     
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}