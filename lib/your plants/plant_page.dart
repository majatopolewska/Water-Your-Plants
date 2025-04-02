import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_plant.dart';

class PlantPage extends StatefulWidget {
  final Map<String, dynamic> plantData;

  const PlantPage({super.key, required this.plantData});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  void _deletePlant() async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final plantId = widget.plantData['id'];

    if (plantId == null) {
      print("Error: Plant ID is missing.");
      return;
    }

    print("Deleting plant with ID: $plantId"); // For debugging

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('plants')
        .doc(plantId)
        .delete();

    // Show confirmation (optional)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Plant deleted")),
    );

    Navigator.pop(context); // Go back after deleting
  } catch (e) {
    print("Error deleting plant: $e");

    // Show error to user (optional)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to delete plant: $e")),
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    final plant = widget.plantData;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 242, 203),
      appBar: AppBar(
        title: Text(plant['name'] ?? 'Plant Info'),
        backgroundColor: const Color.fromARGB(255, 132, 192, 169),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPlantPage(
                    plantData: widget.plantData,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deletePlant,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text("Plant Icon", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Image.asset(plant['icon'] ?? '', width: 60),
            const SizedBox(height: 15),

            Text('Name'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  plant['name'] ?? 'Unknown',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 15),

            Text('Species'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  plant['plantType'] ?? 'Unknown',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 15),

            Text('Watering Frequency'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  plant['frequency'] ?? 'Unknown',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 15),

            if ((plant['suggestions'] ?? "").isNotEmpty) ...[
              Text('Suggestions'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    plant['suggestions'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ],
        ),
      ),
    );
  }
}
