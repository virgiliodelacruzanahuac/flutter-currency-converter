import 'dart:convert';
import 'package:http/http.dart' as http;

// docs https://github.com/fawazahmed0/currency-api#readme
//https://www.geeksforgeeks.org/http-get-response-in-flutter/
class obtienedatosapi {
  Future<String> getapi() async {
    String myurl =
        'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies.json';
    final response = await http.get(Uri.parse(myurl));
    print(response.body);
    return response.body.toString();
  }

  Future<Map> getdatos() async {
    String myregreso = '';
    myregreso = await getapi();
    Map<String, dynamic> data = jsonDecode(myregreso);
    return data;
  }
}
