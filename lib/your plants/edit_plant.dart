import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'plants_constants.dart';
import '../entry pages/in_home_page.dart';
import '../care details/api.dart';
import 'plant_page.dart';

class EditPlantPage extends StatefulWidget {
  final Map<String, dynamic> plantData;
  const EditPlantPage({super.key, required this.plantData});

  @override
  State<EditPlantPage> createState() => _EditPlantPageState();
}

final TextEditingController selectedName = TextEditingController();
final TextEditingController selectedSuggestions = TextEditingController();
String seletedPlantType = 'Succulents';
WaterFreq selectedFreq = WaterFreq.onceAMonth;
String iconPath = '';
DateTime? _selectedDate;
final TextEditingController _dateController = TextEditingController();

Future<void> savePlant(BuildContext context,String icon, String name, String plantType, String frequency, DateTime lastWater, String sugg) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final apiId = ApiId();
    final perenualPlantId = await apiId.fetchPerenualPlantId(plantType);

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plants')
        .doc(selectedPlantId);

    await docRef.update({
      'icon': icon,
      'name': name,
      'plantType': plantType,
      'frequency': frequency,
      'lastWatering': lastWater,
      'suggestions': sugg,
      'plant_id': perenualPlantId,
    });

    final updatedDoc = await docRef.get();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantPage(plantData: updatedDoc.data()!..['id'] = updatedDoc.id),
      ),
    );
  }
}


String selectedPlantId = ''; // Temporary holder

class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choose an icon", style: TextStyle(fontFamily: 'Modak', fontSize: 20)),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: icons.map((path) {
            return GestureDetector(
              onTap: () {
                iconPath = path;
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(path, width: 60),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _EditPlantPageState extends State<EditPlantPage> {
  @override
  void initState() {
    super.initState();
    final data = widget.plantData;

    selectedPlantId = data['id'];
    selectedName.text = data['name'] ?? '';
    seletedPlantType = data['plantType'] ?? 'Succulents';
    selectedFreq = WaterFreq.values.firstWhere(
      (e) => e.label == data['frequency'],
      orElse: () => WaterFreq.onceAMonth,
    );
    selectedSuggestions.text = data['suggestions'] ?? '';
    iconPath = data['icon'] ?? '';

    if (data['lastWatering'] != null) {
      _selectedDate = (data['lastWatering'] as Timestamp).toDate();
      _dateController.text = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 242, 203),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),

            const Text("Plant Icon"),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const IconPickerDialog(),
                    );
                  },
                  style: TextButton.styleFrom(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text("Change Icon", style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (iconPath.isNotEmpty) Image.asset(iconPath, width: 60),

            const SizedBox(height: 15),

            const Text("Plant name"),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: selectedName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 15),

            const Text("Plant Type"),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: seletedPlantType,
                    isExpanded: true,
                    onChanged: (String? newValue) {
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

            const Text("How often should it be watered?"),
            Padding(
              padding: const EdgeInsets.all(5),
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
                    onChanged: (WaterFreq? newValue) {
                      setState(() {
                        selectedFreq = newValue!;
                      });
                    },
                    items: WaterFreq.values.map<DropdownMenuItem<WaterFreq>>((WaterFreq value) {
                      return DropdownMenuItem<WaterFreq>(
                        value: value,
                        child: Text(value.label),
                      );
                    }).toList(),
                  ),
                ),
              ),
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

            const Text("Suggestions"),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: selectedSuggestions,
                decoration: const InputDecoration(
                  hintText: "Something you want to add?",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                final name = selectedName.text.trim();
                final freqLabel = selectedFreq.label;
                final sugg = selectedSuggestions.text.trim();

                if (name.isNotEmpty && freqLabel.isNotEmpty && iconPath.isNotEmpty) {
                  
                  savePlant(context, iconPath, name, seletedPlantType, freqLabel, _selectedDate!, sugg);

                  selectedName.clear();
                  selectedSuggestions.clear();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => InHomePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in name and select an icon')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
