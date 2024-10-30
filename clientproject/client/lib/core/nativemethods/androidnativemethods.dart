import 'package:flutter/services.dart';
import 'package:payapp/core/components/print_text.dart';

class NativeMethods {
  static const batteryChannel = MethodChannel("com.sambhavapps/Contacts");

  static Future getContacts() async {
    final list = await batteryChannel.invokeMethod("getContactsList");
    printThis(list.length);
    return list;
  }
}
