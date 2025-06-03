import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//  URL for REAL SERVER
//app server uses version 2
String basedUrl = "http://ayeyar.technology/projects/myanmar-promotions-v2/api/";
//resource server uses version 1
String basedImageUrl = "http://ayeyar.technology/projects/myanmar-promotions/public/images/uploaded/";

class HttpService {
  //GET REQUEST METHOD
  Future get({required String url}) async {
    var parsedUrl = Uri.parse(basedUrl + url);
    http.Response response = await http.get(parsedUrl);
    return httpResponseToJson(response);
  }

  //POST REQUEST METHOD
  Future post({required String url, required Map<String, dynamic> body}) async {
    var parsedUrl = Uri.parse(basedUrl + url);
    http.Response response = await http.post(parsedUrl, body: body);
    return httpResponseToJson(response);
  }

  Future postRequest({required String url, required Map<String, dynamic> body}) async {
    var parsedUrl = Uri.parse(url);
    http.Response response = await http.post(parsedUrl, body: body);
    return httpResponseToJson(response);
  }

  //GET REQUEST METHOD
  Future getRequest({required String url}) async {
    var parsedUrl = Uri.parse(url);
    http.Response response = await http.get(parsedUrl);
    return httpResponseToJson(response);
  }


  //HTTP RESPONSE ARE CONVERTED TO JSON FORMAT
  httpResponseToJson(http.Response response) {
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
     return json.decode('{"status": false,"description":"'+response.reasonPhrase.toString()+'"}');
    }
  }
}
