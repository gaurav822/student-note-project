import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:student_notes/Models/admodel.dart';

import 'package:student_notes/SecuredStorage/securedstorage.dart';

class Adhelper {
  static final String url = dotenv.get('API_URL');

  static Future<AdModel> listAdvertisements() async {
    String access = await SecuredStorage.getAccess();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + access
    };

    try {
      var response = await http.get(Uri.parse('$url/ads/list/?page=1'),
          headers: requestHeaders);

      return AdModel.fromJson(response.body);
    } catch (e) {
      print("The access token from ad before catch" + access);
      print("Advertise helper catch");
      print(e.toString());
      return AdModel(count: 0, next: 0, previous: 0, results: []);
    }
  }
}
