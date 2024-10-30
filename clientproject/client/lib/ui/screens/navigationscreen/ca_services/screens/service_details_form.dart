import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widgets/app_bar_widget.dart';

class ServiceDetailsForm extends StatefulWidget {
  final String id;

  const ServiceDetailsForm({Key? key, required this.id}) : super(key: key);

  @override
  _ServiceDetailsFormState createState() => _ServiceDetailsFormState();
}

class _ServiceDetailsFormState extends State<ServiceDetailsForm> {
  List<Map<String, dynamic>> formData = [];
  bool isLoading = true;
  Map<String, File> fileData = {};

  @override
  void initState() {
    super.initState();
    print("ID : ");
    print(widget.id);
    fetchData(widget.id);
  }

  Future<void> fetchData(String serviceId) async {
    var apiUrl = Uri.parse(
        'https://xyzabc.sambhavapps.com/v1/ca/service/form/service/$serviceId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Login token ${prefs.getString('token')}");
    String token = prefs.getString('auth-token') ?? '';

    var response = await http.get(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("Response code : ${response.statusCode}");

    print("Response body : ${response.body}");
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        formData =
            List<Map<String, dynamic>>.from(jsonData['data'][0]['form_data']);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> submitForm() async {
    MethodChannel channel = const MethodChannel('easebuzz');

    String accessKey = "Access key generated by the Initiate Payment API";
    String payMode = "test";
    Object parameters = {"access_key": accessKey, "pay_mode": payMode};
    final paymentResponse =
        await channel.invokeMethod("payWithEasebuzz", parameters);
    /* payment_response is the HashMap containing the response of the payment.
You can parse it accordingly to handle response */
    String result = paymentResponse['result'];
    print("=======> Payment Response: ");
    print(paymentResponse);
    print("=======> Payment Result: ");
    print(result);
    // Implement form submission logic here
    // You can use formData and fileData to construct your request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Service Details Form",
        size: 55,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var field in formData)
                        field['type'] == 'file'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    field['lable'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.upload_file_outlined,
                                              color: Colors.indigo,
                                              size: 25,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Choose File",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      Colors.deepPurple),
                                              // Set background color
                                              foregroundColor:
                                                  WidgetStateProperty.all(
                                                      Colors.white),
                                              // Set text color
                                              padding:
                                                  WidgetStateProperty.all(
                                                      const EdgeInsets.symmetric(
                                                          vertical: 15,
                                                          horizontal: 20)),
                                              // Set padding
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  // Set border radius
                                                  side: const BorderSide(
                                                      color: Colors
                                                          .deepPurple), // Set border color
                                                ),
                                              ),
                                              textStyle: WidgetStateProperty
                                                  .all<TextStyle>(
                                                const TextStyle(
                                                    fontSize:
                                                        16), // Set text style
                                              ),
                                            ),
                                            onPressed: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles();

                                              if (result != null) {
                                                setState(() {
                                                  fileData[field['_id']] = File(
                                                      result
                                                          .files.single.path!);
                                                });
                                              }
                                            },
                                            child: const Text("Upload"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      field['lable'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Type here',
                                        // Add an icon as a prefix
                                        border: OutlineInputBorder(
                                          // Add border styling
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        filled: true,
                                        // Fill the input field with a color
                                        fillColor: Colors.grey[200],
                                        // Set fill color
                                        enabledBorder: OutlineInputBorder(
                                          // Border when enabled
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // Border when focused
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          // Border when error
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2.0),
                                        ),
                                        errorStyle: const TextStyle(
                                            color: Colors
                                                .red), // Style for error text
                                      ),
                                      validator: (value) {
                                        if (field['required'] &&
                                            value?.isEmpty == true) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                          onPressed: submitForm,
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20)),
                            shape: WidgetStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(color: Colors.blue)),
                            ),
                            textStyle: WidgetStateProperty.all<TextStyle>(
                              const TextStyle(fontSize: 16), // Set text style
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
