import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_plant.dart';
import 'plant_page.dart';

class PlantListWidget extends StatelessWidget {
  const PlantListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('plants')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Stack(
            children: [
              Container(
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
              ),

              Positioned(
                bottom: 0,
                right: 10,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddPlantPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Add Your Plant',
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        final plants = snapshot.data!.docs;
        final int rows = (plants.length / 5).ceil();
        final double containerHeight = (rows * 60) + 80;

        return Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: containerHeight,
              padding: const EdgeInsets.fromLTRB(15, 50, 15, 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 189, 221, 214),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: plants.map((doc) {
                  final iconPath = doc['icon'] ?? '';
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PlantPage(plantData: {...doc.data(),'id': doc.id}))
                      );
                    },
                    child: Image.asset(iconPath, width: 50, height: 50),
                  );
                }).toList(),
              ),
            ),
            const Positioned(
              top: 10,
              left: 10,
              child: Text(
                "Your Plants",
                style: TextStyle(fontFamily: 'Modak', fontSize: 25),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 10,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddPlantPage()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'Add Your Plant',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}