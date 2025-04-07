import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantService
{
  Future<String?> fetchSunlightInfo(int plantId) async {
    final response = await http.get(Uri.parse(
      'https://perenual.com/api/species-care-guide-list/$plantId?key=sk-PLSA67f43a133cacd9643',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final sunlight = data['sunlight'];
      if (sunlight != null && sunlight is List) {
        return sunlight.join(', ');
      }
    }
    return null;
  }
}