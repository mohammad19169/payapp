import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payapp/config/apiconfig.dart';
import 'package:payapp/services/apis/apiservice.dart';

import '../../../../core/components/print_text.dart';
import '../../../../models/ca_models/home_services_model.dart';
class RemoteCAServices
{
  // static String basicAuth = 'Basic ${base64.encode(utf8.encode('usedr@demo.com:Asd@123456'))}';

  // static http.Client client = http.Client();
  static String Token='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1Nzc2Y2I3Zjk2NzA4ZTU3OTlkNGI5YSIsImlhdCI6MTcwMjQ1ODU2MCwiZXhwIjoxNzAyNTQ0OTYwfQ.NTCyTUaBACpegjkGKrkQHqv7Pzssi_OS_HJ1_SBPQcY';
  // static Map<String, String> headers = {'Cookie': Token};
  static Map<String,String> headers = {
    'Cookie': 'token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1Nzc2Y2I3Zjk2NzA4ZTU3OTlkNGI5YSIsImlhdCI6MTcwMjQ1ODU2MCwiZXhwIjoxNzAyNTQ0OTYwfQ.NTCyTUaBACpegjkGKrkQHqv7Pzssi_OS_HJ1_SBPQcY',
    'Accept': 'application/json'};
  static Map<String,String> Tempheaders = {
    'Cookie': 'token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1Nzc2Y2I3Zjk2NzA4ZTU3OTlkNGI5YSIsImlhdCI6MTcwMjQ1ODU2MCwiZXhwIjoxNzAyNTQ0OTYwfQ.NTCyTUaBACpegjkGKrkQHqv7Pzssi_OS_HJ1_SBPQcY',
    'Accept': 'application/json'};
  static Map<String, String>? postHeaders = {
  'Cookie': 'token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1Nzc2Y2I3Zjk2NzA4ZTU3OTlkNGI5YSIsImlhdCI6MTcwMjQ1ODU2MCwiZXhwIjoxNzAyNTQ0OTYwfQ.NTCyTUaBACpegjkGKrkQHqv7Pzssi_OS_HJ1_SBPQcY',
    'Accept': 'application/json'};

  static Future< List<CAHomeServicesDataModel>> fetchCAHomeServices() async {
    print("Running now");
    var url = Uri.parse(Constants.services);
    final response = await http.get(url,headers: {'Cookie':'token=${ApiService.AmrToken}'});
    // if (response.statusCode == 200) {
      final  responseData = jsonDecode(response.body);
    print("============================================================================");
    print("============================================================================");
    print("============================================================================");
    print("===============================================???$responseData??????????????");
      // if (responseData["status"] != false) {
        final notes = responseData["data"] as List;
        return notes.map((e) {
          print("============================================================================");
          printThis(e.toString());
          return CAHomeServicesDataModel.fromMap(e);}).toList();
      // }
      // else {
      //   return responseData["status"];
      // }
    // }
    // else {
    //   return;
    // }
  }

}
