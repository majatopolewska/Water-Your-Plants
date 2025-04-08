import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_app/your%20plants/edit_plant.dart';
import 'plant_service.dart';

class CareSuggestionsWidget extends StatefulWidget {
  const CareSuggestionsWidget({super.key});

  @override
  State<CareSuggestionsWidget> createState() => _CareSuggestionsWidgetState();
}

Set<String> _expandedPlantIds = {}; 

class _CareSuggestionsWidgetState extends State<CareSuggestionsWidget> {

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Center(child: Text("Not logged in"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('plants')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final plants = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        if (plants.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 189, 221, 214),
              borderRadius: BorderRadius.circular(15),
            ),
            width: MediaQuery.of(context).size.width - 40,
            child: const Center(
              child: Text(
                "No plants yet",
                style: TextStyle(fontFamily: 'Modak', fontSize: 20),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                "Care suggestions",
                style: TextStyle(fontFamily: 'Modak', fontSize: 25),
              ),
            ),
            ...plants.map((plant) {
              final plantId = plant['plant_id'];
              final plantIdString = plantId.toString();
              final plantName = plant['name'];
              final iconPath = plant['icon'];

              return FutureBuilder<Map<String, dynamic>?>(
                future: PlantService().fetchPlantDetails(plantId),
                builder: (context, snapshot) {
                  final isExpanded = _expandedPlantIds.contains(plantIdString);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 189, 221, 214),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (iconPath != null)
                                  Image.asset(iconPath, width: 25),
                                const SizedBox(width: 8),
                                Text(
                                  plantName,
                                  style: const TextStyle(fontSize: 20, fontFamily: 'Modak'),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isExpanded) {
                                    _expandedPlantIds.remove(plantIdString);
                                  } else {
                                    _expandedPlantIds.add(plantIdString);
                                  }
                                });
                              },
                              icon: isExpanded
                                  ? const Icon(Icons.arrow_upward)
                                  : const Icon(Icons.arrow_downward),
                            ),
                          ],
                        ),

                        if (isExpanded && snapshot.connectionState == ConnectionState.done && snapshot.hasData)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text('☀️ Sunlight: ${(snapshot.data!['sunlight'] as List<dynamic>?)?.join(', ') ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('💧 Watering: ${snapshot.data!['watering'] ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('✂️ Pruning Months: ${(snapshot.data!['pruning_month'] as List<dynamic>?)?.join(', ') ?? 'None'}', style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('🌸 Flowering Season: ${snapshot.data!['flowering_season'] ?? 'Not available'}', style: TextStyle(fontSize: 16)),
                            ],
                          ),

                        if (isExpanded && snapshot.connectionState == ConnectionState.waiting)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: LinearProgressIndicator(),
                          ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }
}