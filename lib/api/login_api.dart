import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> login(String username, String password) async {
  try {
    const url = 'https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "API_Body": [
          {"Unique_Id": "", "Pw": password}
        ],
        "Api_Action": "GetUserData",
        "Company_Code": username
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final String? docMsg = responseBody['Response_Body']?[0]['Doc_Msg'];

      final int statusCode = responseBody['Status_Code'];
      if (statusCode != 200) {
        throw 'Invalid Username';
      }
      if (docMsg == 'Invalid Password') {
        throw 'Invalid Password';
      }
      return jsonDecode(response.body);
    } else {
      throw 'Internal Error, Please try again later';
    }
  } catch (e) {
    throw '$e';
  }
}
