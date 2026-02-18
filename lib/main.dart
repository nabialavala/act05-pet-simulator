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
  //part 1 - win/loss conditions: add variables to track
  int _happySeconds = 0;
  Timer? _winTimer;
  bool _gameOver = false;
  //part 2 - energy bar widget: adding new state variable
  double energyLevel = 100.0;

  void _playWithPet() {
    setState(() {
      happinessLevel += 10.0;
      _updateHunger();
      //part 1 - win/loss conditions: check after each setState() method
      _checkLossCondition();
      _checkWinCondition(); 
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10.0;
      _updateHappiness();
      //part 1 - win/loss conditions: check after each setState() method
      _checkLossCondition();
      _checkWinCondition(); 
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
    hungerLevel += 5.0;
    if (hungerLevel > 100.0) {
      hungerLevel = 100.0;
      happinessLevel -= 20.0;
    } 
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
    _winTimer?.cancel();
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
        //part 1 - win/loss conditions: check after each setState() method
        _checkLossCondition();
        _checkWinCondition(); 
        });
      },
    );
  }

  //part 1 - win/loss conditions: method to check loss conditions
  void _checkLossCondition() {
    if (_gameOver) return;
    if (hungerLevel >= 100.0 && happinessLevel <= 10.0) {
      _gameOver = true;
      _hungerTimer?.cancel();
      _winTimer?.cancel();
      _winTimer = null;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Game Over"),
          content: Text("$petName died from starvation and depression."),
          actions:[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
  
  //part 1 - win/loss conditions: method to check win conditions
  void _checkWinCondition() {
    if (_gameOver) return;
    if (happinessLevel> 80.0) {
      if (_winTimer == null) {
        _winTimer = Timer.periodic(
          Duration(seconds: 1),
          (timer) {
            _happySeconds++;
            if (_happySeconds >= 180) {
              _gameOver = true;
              timer.cancel();
              _winTimer?.cancel();
              _winTimer = null;
              _hungerTimer?.cancel();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("You Win!!"),
                  content: Text("$petName is extremely happy!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Yay!"),
                    ),
                  ],
                ),
              );
            }
          },
        );
      }
    } else {
      _winTimer?.cancel();
      _winTimer = null;
      _happySeconds = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                    //part 1 - win/loss conditions: check after each setState() method
                    _checkLossCondition();
                    _checkWinCondition();
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
              SizedBox(height: 16.0),
              //part 2 - energy level bar: adding to page
              Text(
                "Energy Level: ${energyLevel.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: LinearProgressIndicator(
                  value: energyLevel/100, //value has to be between 0-1
                  minHeight: 10,
                ),
              ),
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
      ),
    );
  }
}
