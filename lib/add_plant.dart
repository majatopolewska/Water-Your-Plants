import 'package:flutter/material.dart';
import 'water_freq.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

String selectedValue = 'Aloes';
WaterFreq wateringFrequencies = WaterFreq.onceAMonth;

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
                const SizedBox(height: 15),
                
                Text("Plant name"),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
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
                        value: selectedValue, 
                        isExpanded: true,
                        onChanged: (String? newValue){
                          setState(() {
                            selectedValue = newValue!;
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
                        value: wateringFrequencies, 
                        isExpanded: true,
                        onChanged: (WaterFreq? newValue){
                          setState(() {
                            wateringFrequencies = newValue!;
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
                
              ],
            ),
          ]
        ) 
      )
    );
  }
}