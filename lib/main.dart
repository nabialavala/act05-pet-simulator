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
  //part 2 - energy level logic: adding boolean check
  bool get _tooTired => energyLevel <=10;


  void _playWithPet() {
    if (_gameOver) return;
    setState(() {
      happinessLevel += 10.0;
      //part 2 - energy level logic: bc playing costs energy
      energyLevel -= 15.0;
    });
    _updateHunger();
    //part 1 - win/loss conditions: check after each setState() method
    _checkLossCondition();
    _checkWinCondition(); 
  }

  void _feedPet() {
    if (_gameOver) return;
    setState(() {
      hungerLevel -= 10.0;
      //part 2 - energy level logic: bc food gives energy
      energyLevel +=5.0;
      _updateHappiness();
      //part 1 - win/loss conditions: check after each setState() method
      _clampStats();
      _checkLossCondition();
      _checkWinCondition(); 
    });
  }

  void _updateHappiness() {
    if (hungerLevel > 70.0) {
      //personal edit: if pet is super hungry decrease happiness
      happinessLevel -= 20.0; 
    } else if (hungerLevel > 30.0) {
      //personal edit: if pet moderately hungry
      happinessLevel += 5.0;
    } else {
      //personal edit: if pet is well fed
      happinessLevel += 10.0;
    }
    _clampStats();
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5.0;
      if (hungerLevel > 100.0) {
        hungerLevel = 100.0;
      }
      _clampStats();
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
      return "$petName is feeling happy!!";
    } else if (happinessLevel >= 30.0) {
      return "$petName is doing ok.";
    } else {
      return "$petName is really sad";
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
      (Timer timer) {
        setState(() {
          if (_gameOver) return;
          hungerLevel += 5.0;
          //personal edit: hunger will automatically affect happiness
          if (hungerLevel >= 90) {
            happinessLevel -= 10.0;
          }
          _clampStats();
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
      _winTimer ??= Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) {
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
    } else {
      _winTimer?.cancel();
      _winTimer = null;
      _happySeconds = 0;
    }
  } 
  

  //part 2 - energy level logic: helper method
  void _clampStats() {
    if (energyLevel < 0) energyLevel = 0;
    if (energyLevel > 100) energyLevel = 100;
    if (happinessLevel < 0) happinessLevel = 0;
    if (happinessLevel > 100) happinessLevel = 100;
    if (hungerLevel < 0) hungerLevel = 0;
    if (hungerLevel > 100) hungerLevel = 100;
  }

  //personal edit: helper to change energy bar color
  Color _energyColor() {
    if (energyLevel > 50) return Colors.green;
    if (energyLevel > 25) return Colors.orange;
    return Colors.red;
  }

  //personal improvement: adding 3 bars
  Widget _statBar({
    required String label,
    required double value, //range: 0-100
    required Color barColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ${value.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value/100.0,
              minHeight: 12.0,
              valueColor: AlwaysStoppedAnimation(barColor),
              backgroundColor: Colors.black12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Nabia\'s Digital Pet Simulator'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //personal edit: setting input box and set button side by side
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      //part 1 - pet name customization adding user input field
                      child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Enter pet name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
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
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Text('Name: $petName', style: const TextStyle(fontSize: 20.0)),
              const SizedBox(height: 16.0),
              //personal improvemeent - adding 3 bars
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  //part 1 - dynamic color change: adding pet image
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      _moodColor(happinessLevel),
                      BlendMode.modulate,
                    ),
                    child: Image.asset(
                      'assets/pet_image.png',
                      height: 150,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              //part 1 - pet mood indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _moodText(),
                    style: const TextStyle(fontSize: 20.0),
                  ), 
                  const SizedBox(width:8.0),
                  Icon(
                    _moodIcon(),
                    size: 24.0,
                    color: _moodColor(happinessLevel),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _tooTired ? null : _playWithPet,
                    child: Text(_tooTired ? 'Too tired to play' : 'Play'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _feedPet,
                    child: Text('Feed'),
                  ),
                ],
              ),
              const SizedBox(height: 18.0),
              //Status Box
              Padding( 
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$petName's Status: ",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        _statBar(label: 'Happiness', value: happinessLevel, barColor: _moodColor(happinessLevel)),
                        _statBar(label: 'Hunger', value: hungerLevel, barColor: hungerLevel >= 70 ? Colors.red : Colors.orange),
                        _statBar(label: 'Energy', value: energyLevel, barColor: _energyColor()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}