import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'water_freq.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

final TextEditingController selectedName = TextEditingController();
String seletedPlantType = 'Aloes';
WaterFreq selectedFreq = WaterFreq.onceAMonth;
final TextEditingController selectedSuggestions = TextEditingController();

String iconPath = '';

void savePlant(String icon, String name, String plantType, String frequency, String sugg)
{
  FirebaseFirestore.instance.collection('plants').add({
    'icon' : icon,
    'name': name,
    'plantType': plantType,
    'frequency': frequency,
    'suggestions': sugg,
    'createdAt': Timestamp.now(),
  });
}

class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> icons = [
      'assets/images/plant_icon_1.png',
      'assets/images/plant_icon_2.png',
      'assets/images/plant_icon_3.png',
      'assets/images/plant_icon_4.png',
      'assets/images/plant_icon_5.png',
      'assets/images/plant_icon_6.png',
      'assets/images/plant_icon_7.png',
      'assets/images/plant_icon_8.png',
      'assets/images/plant_icon_9.png',
    ];

    return AlertDialog(
      title: const Text("Choose an icon", style: TextStyle(fontFamily: 'Modak', fontSize: 20),),
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


class _AddPlantPageState extends State<AddPlantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 242, 203),
      body: Center(
        child: Column(
          children:[
            SizedBox(height: 150),
            Column(
              children: [

                Text("Plant Icon"),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const IconPickerDialog(),
                        );
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
                        items: <String>['Aloes', 'Cactus']
                          .map<DropdownMenuItem<String>>((String value) {
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
                            child: Text(value.label), // using your extension
                          );
                        }).toList()

                      ),
                    ),
                  )
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

                    if(name.isNotEmpty && freqLabel.isNotEmpty && iconPath.isNotEmpty)
                    {
                      savePlant(iconPath, name, seletedPlantType, freqLabel, sugg);

                      selectedName.clear();
                      selectedSuggestions.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Plant saved!')),
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
    );
  }
}