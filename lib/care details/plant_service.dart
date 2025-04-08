import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantService {
  Future<Map<String, dynamic>?> fetchPlantDetails(int plantId) async {
    final url = 'https://perenual.com/api/species/details/$plantId?key=sk-PLSA67f43a133cacd9643';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    }

    return null;
  }
}
