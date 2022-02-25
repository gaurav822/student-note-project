import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_notes/Models/admodel.dart';
import '../provider/profileprovider.dart';

class Adhelper {
  static final String url = dotenv.get('API_URL');

  Adhelper() {
    //
  }

  Future<AdModel> listAdvertisements(BuildContext context) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${Provider.of<ProfileProvider>(context, listen: false).getAccessToken()}'
    };

    try {
      var response = await http.get(Uri.parse('$url/ads/list/?page=1'),
          headers: requestHeaders);

      return AdModel.fromJson(response.body);
    } catch (e) {
      print("Advertise helper catch");
      print(e.toString());
      return AdModel(count: 0, next: 0, previous: 0, results: []);
    }
  }
}
