import 'package:flutter/material.dart';

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
  int happinessLevel = 50;
  int hungerLevel = 50;
  //part 1 - Pet Name Customization: initaializing pet name variable
  final TextEditingController _nameController = TextEditingController();

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }

//part 1 - dynamic color change
  Color _moodColor(int happinessLevel) { //returns a color
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

//part 1 - pet mood indicator
  String _moodText() {
    if (happinessLevel > 70) {
      return "Happy";
    } else if (happinessLevel >= 30) {
      return "Neutral";
    } else {
      return "Sad";
    }
  }

  IconData _moodIcon() {
    if (happinessLevel > 70) {
      return Icons.sentiment_satisfied_alt;
    } else if (happinessLevel >= 30) {
      return Icons.sentiment_neutral;
    } else {
      return Icons.sentiment_dissatisfied;
    }
  }

  //part 1 - pet name cutomization: creation method to dispose
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
            //part 1 - dynamic color change
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
