import 'package:flutter/material.dart';
//part 1 - auto-increasing hunger: import asych library
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  double happinessLevel = 50;
  double hungerLevel = 50;
  //part 1 - Pet Name Customization: initaializing pet name variable
  final TextEditingController _nameController = TextEditingController();
  //part 1- auto-increasing hunger: creating timer variable
  Timer? _hungerTimer; //'Timer?' - ? makes the variable able to be assigned null value

  void _playWithPet() {
    setState(() {
      happinessLevel += 10.0;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10.0;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30.0) {
      happinessLevel -= 20.0;
    } else {
      happinessLevel += 10.0;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5.0;
      if (hungerLevel > 100.0) {
        hungerLevel = 100.0;
        happinessLevel -= 20.0;
      }
    });
  }

//part 1 - dynamic color change
  Color _moodColor(double happinessLevel) { //returns a color
    if (happinessLevel > 70.0) {
      return Colors.green;
    } else if (happinessLevel >= 30.0) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

//part 1 - pet mood indicator
  String _moodText() {
    if (happinessLevel > 70.0) {
      return "Happy";
    } else if (happinessLevel >= 30.0) {
      return "Neutral";
    } else {
      return "Sad";
    }
  }

  IconData _moodIcon() {
    if (happinessLevel > 70.0) {
      return Icons.sentiment_satisfied_alt;
    } else if (happinessLevel >= 30.0) {
      return Icons.sentiment_neutral;
    } else {
      return Icons.sentiment_dissatisfied;
    }
  }

  //part 1 - pet name cutomization: creation method to dispose
  @override
  void dispose() {
    //part 1 - auto-inc hunger: we need to cancel the timer
    _hungerTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  //part 1 - auto-inc hunger: creating funtion to remove hunger every 30 second interval
  @override
  void initState() {
    super.initState();
    _hungerTimer = Timer.periodic(
      Duration(seconds: 30),
      (timer) {
        setState(() {
          hungerLevel += 5.0;
          if (hungerLevel > 100.0) {
            hungerLevel = 100.0;
          }
        });
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //part 1 - pet name customization adding user input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Enter pet name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final newName = _nameController.text.trim();
                  if (newName.isNotEmpty) {
                    petName = newName;
                    _nameController.clear();
                  }
                });
              },
              child: Text("Set Name"),
            ),
            SizedBox(height: 16.0),
            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            //part 1 - dynamic color change: adding pet image
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _moodColor(happinessLevel),
                BlendMode.modulate,
              ),
              child: Image.asset(
                'assets/pet_image.png',
                height: 150,
              ),
            ),
            SizedBox(height: 16.0),
            //part 1 - pet mood indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _moodText(),
                  style: TextStyle(fontSize: 20.0),
                ), 
                SizedBox(width:8.0),
                Icon(
                  _moodIcon(),
                  size: 24.0,
                  color: _moodColor(happinessLevel),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
