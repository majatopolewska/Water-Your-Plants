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

List<Map<String, dynamic>> _userPlants = [];

class _CareSuggestionsWidgetState extends State<CareSuggestionsWidget> {

  @override
  void initState() {
    super.initState();
    _loadPlantDetails();
  }

  void _loadPlantDetails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('plants')
        .get();

    setState(() {
      _userPlants = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userPlants.isEmpty) {
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
        ..._userPlants.map((plant) {
          final plantId = plant['plant_id'];
          final plantName = plant['name'];
          final iconPath = plant['icon'];

          return FutureBuilder<Map<String, dynamic>?>(
            future: PlantService().fetchPlantDetails(plantId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const SizedBox(); // Or show a fallback card
              }

              final data = snapshot.data!;
              final sunlight = (data['sunlight'] as List<dynamic>?)?.join(', ') ?? 'Unknown';
              final watering = data['watering'] ?? 'Unknown';

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
                    const SizedBox(height: 8),
                    Text('☀️ Sunlight: $sunlight', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('💧 Watering: $watering', style: TextStyle(fontSize: 16)),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ],
    );
  }
}