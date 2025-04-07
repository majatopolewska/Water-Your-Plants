import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'plants_constants.dart';
import '../entry pages/in_home_page.dart';
import 'package:plant_app/main.dart';
import 'icon_add_plant.dart';
import '../care details/api.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

final user = FirebaseAuth.instance.currentUser;
final TextEditingController selectedName = TextEditingController();
String seletedPlantType = 'Succulents';
WaterFreq selectedFreq = WaterFreq.onceAMonth;
final TextEditingController selectedSuggestions = TextEditingController();
DateTime? _selectedDate;
final TextEditingController _dateController = TextEditingController();


Future<void> savePlant(String icon, String name, String plantType, String frequency, DateTime lastWater, String sugg) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final apiId = ApiId();
    final perenualPlantId = await apiId.fetchPerenualPlantId(plantType);

    final docRef = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('plants')
      .add({
        'icon': icon,
        'name': name,
        'plantType': plantType,
        'frequency': frequency,
        'lastWatering': lastWater,
        'suggestions': sugg,
        'createdAt': Timestamp.now(),
        'plant_id': perenualPlantId,
      });

    await docRef.update({'id': docRef.id});

    const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Plant Saved!',
      'You just added $name to your garden 🌱',
      notificationDetails,
      payload: docRef.id,
    );
  }
}


class _AddPlantPageState extends State<AddPlantPage> {
  String iconPath = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 242, 203),
      body: SingleChildScrollView(
        child:Center(
          child: Column(
            children:[
              SizedBox(height: 100),
              Column(
                children: [

                  Text("Plant Icon"),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: TextButton(
                        onPressed: () async {
                          final selectedIcon = await showDialog<String>(
                            context: context,
                            builder: (context) => const IconPickerDialog(),
                          );
                          if (selectedIcon != null) {
                            setState(() {
                              iconPath = selectedIcon;
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Add Icon",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ),
                  const SizedBox(height: 10),

                  if (iconPath.isNotEmpty)
                    Image.asset(iconPath, width: 60),

                  const SizedBox(height: 15),
                  
                  Text("Plant name"),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: selectedName,
                      decoration: InputDecoration(
                        hintText: "Best Plant",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  Text("Plant Type"),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: seletedPlantType, 
                          isExpanded: true,
                          onChanged: (String? newValue){
                            setState(() {
                              seletedPlantType = newValue!;
                            });
                          },
                          items: plantTypes.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  Text("How often should it be watered?"),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<WaterFreq>(
                          value: selectedFreq, 
                          isExpanded: true,
                          onChanged: (WaterFreq? newValue){
                            setState(() {
                              selectedFreq = newValue!;
                            });
                          },
                          
                          items: WaterFreq.values.map<DropdownMenuItem<WaterFreq>>((WaterFreq value) {
                            return DropdownMenuItem<WaterFreq>(
                              value: value,
                              child: Text(value.label),
                            );
                          }).toList()

                        ),
                      ),
                    )
                  ),
                  const SizedBox(height: 15),

                  Text("When did you watered you plant?"),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Pick a date',
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                      ),

                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  Text("Suggestions"),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: selectedSuggestions,
                      decoration: InputDecoration(
                        hintText: "Something you want to add?",
                        border: OutlineInputBorder(),
                      ),
                    )
                  ),
                  SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: (){
                      final name = selectedName.text.trim();
                      final freqLabel = selectedFreq.label;
                      final sugg = selectedSuggestions.text.trim();

                      if (name.isNotEmpty && freqLabel.isNotEmpty && iconPath.isNotEmpty && _selectedDate != null)
                      {
                        savePlant(iconPath, name, seletedPlantType, freqLabel, _selectedDate!, sugg);

                        selectedName.clear();
                        selectedSuggestions.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Plant saved!')),
                        );

                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => InHomePage(),)
                        );
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in name and select an icon')),
                        );
                      } 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Add Plant',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  
                ],
              ),
            ]
          ) 
        )
      )
    );
  }
}