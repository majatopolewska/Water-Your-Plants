import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantService
{
  Future<Map<String, dynamic>> fetchPlantDetails(int plantId) async {
    final response = await http.get(
      Uri.parse('https://perenual.com/api/species-care-guide-list/$plantId?key=YOUR_API_KEY'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load plant care guide');
    }
  }
}