import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiId{
  Map<String, String> perenualSearchKeywords = {
    'Succulents': 'american century',
    'Cacti': 'cactus',
    'Monstera': 'monstera',
    'Spider Plants': 'spider',
    'Pothos': 'pothos',
    'Orchids': 'orchid',
    'Columbine': 'columbine',
    'Snake Plants': 'snake plant',
    'Lilies': 'lily',
  };

  Future<int?> fetchPerenualPlantId(String category) async {
    final searchTerm = perenualSearchKeywords[category]?.toLowerCase() ?? category.toLowerCase();

    final response = await http.get(Uri.parse(
      'https://perenual.com/api/species-list?key=sk-PLSA67f43a133cacd9643&q=$searchTerm',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['data'];
      if (results.isNotEmpty) {
        for(var result in results)
        {
          final commonName = (result['common_name'] ?? '').toString().toLowerCase();
          final scientificName = (result['scientific_name'] ?? '').toString().toLowerCase();

          if (commonName.contains(searchTerm)) {
            return result['id'];
          }
          if(scientificName.contains(searchTerm)){
            return result['id'];
          }
        }

        return results[0]['id'];
      }
    }
    return null;
  }
}