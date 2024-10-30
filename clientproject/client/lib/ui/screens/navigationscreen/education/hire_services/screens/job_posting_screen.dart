import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payapp/themes/colors.dart';
import 'package:payapp/ui/screens/navigationscreen/education/hire_services/screens/job_description_screen.dart';
import '../../../../../widgets/app_bar_widget.dart';

class JobPostingData {
  String jobTitle = '';
  String city = '';
  String locality = '';
  String areaOfWork = '';
  int salaryRangeStart = 0;
  int salaryRangeEnd = 0;
  bool offerBonus = false;
  int bonusMax = 0;
  String bonusType = '';
  int numberOfStaff = 1;

  bool isComplete() {
    return jobTitle.isNotEmpty &&
        city.isNotEmpty &&
        locality.isNotEmpty &&
        areaOfWork.isNotEmpty &&
        salaryRangeStart != 0 &&
        salaryRangeEnd != 0 &&
        (!offerBonus ||
            (offerBonus && bonusMax != 0 && bonusType.isNotEmpty)) &&
        numberOfStaff != 0;
  }
}

class JobPostingScreen extends StatefulWidget {
  const JobPostingScreen({super.key});

  @override
  _JobPostingScreenState createState() => _JobPostingScreenState();
}

class _JobPostingScreenState extends State<JobPostingScreen> {
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController areaOfWorkController = TextEditingController();
  final TextEditingController salaryRangeStartController =
      TextEditingController();
  final TextEditingController salaryRangeEndController =
      TextEditingController();
  final TextEditingController bonusMaxController = TextEditingController();
  final TextEditingController bonusTypeController = TextEditingController();
  bool offerBonus = false;
  int numberOfStaff = 1;

  JobPostingData jobPostingData = JobPostingData();

  @override
  void initState() {
    super.initState();
    fetchDepartmentOptions();
  }

  List<Map<String, dynamic>> departmentOptions = [];

  Future<void> fetchDepartmentOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    Uri url = Uri.parse('https://xyzabc.sambhavapps.com/v1/job/p1/departments');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          departmentOptions =
              List<Map<String, dynamic>>.from(responseData['data']);
        });
      } else {
        // Handle error
      }
    } else {
      // Handle error
    }
  }

  void _navigateToNextScreen() {
    if (!jobPostingData.isComplete()) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            JobDescriptionScreen(jobPostingData: jobPostingData),
      ));
    } else {
      // Show an error message or handle incomplete data
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Incomplete Data'),
            content: const Text('Please fill all the required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showBottomSheet(
      String title, List<String> options, TextEditingController controller) {
    List<String> filteredOptions = List.from(options);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                    ),
                    onChanged: (text) {
                      setState(() {
                        filteredOptions = options
                            .where((option) => option
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        final option = filteredOptions[index];
                        return ListTile(
                          title: Text(option),
                          onTap: () {
                            controller.text = option;
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTextFieldWithDescription({
    required String description,
    required TextEditingController controller,
    List<String>? options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: ThemeColors.darkBlueColor,
          ),
        ),
        const SizedBox(height: 8),
        if (options != null && options.isNotEmpty)
          GestureDetector(
            onTap: () {
              _showBottomSheet(controller.text, options, controller);
              setState() {}
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Center(
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          controller.text != ""
                              ? controller.text
                              : "Tap to select",
                          style: TextStyle(
                              color: Colors.black ?? Colors.blueGrey,
                              fontWeight: controller.text != ""
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16),
                        )),
                  ],
                ),
              ),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            // height: 50,
            child: TextField(
              controller: controller,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.5,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              readOnly: true,
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Job Posting', size: 50),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'I Want to Hire a',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ThemeColors.darkBlueColor,
              ),
            ),
            TextField(
              controller: jobTitleController,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.5,
                color: ThemeColors.darkBlueColor,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const Text(
              'In the city',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ThemeColors.darkBlueColor,
              ),
            ),
            TextField(
              controller: cityController,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.5,
                color: ThemeColors.darkBlueColor,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),

              keyboardType: TextInputType.text,
            ),
            const Text(
              'For the Locality',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ThemeColors.darkBlueColor,
              ),
            ),
            TextField(
              controller: localityController,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.5,
                color: ThemeColors.darkBlueColor,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            _buildTextFieldWithDescription(
              description: 'Area of Work',
              controller: areaOfWorkController,
              options: departmentOptions
                  .map((dept) => dept['title'].toString())
                  .toList(),
            ),
            const SizedBox(height: 8),
            const Text("I will pay a monthly salary of : "),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: salaryRangeStartController,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.5,
                      color: ThemeColors.darkBlueColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Min',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: salaryRangeEndController,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.5,
                      color: ThemeColors.darkBlueColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Max',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Do you offer bonus in addition to monthly salary?'),
                Checkbox(
                  value: offerBonus,
                  onChanged: (value) {
                    setState(() {
                      offerBonus = value!;
                    });
                  },
                ),
              ],
            ),
            if (offerBonus) ...[
              const SizedBox(height: 16),
              TextField(
                controller: bonusMaxController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.5,
                  color: ThemeColors.darkBlueColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Maximum Bonus Offered',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bonusTypeController,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.5,
                  color: ThemeColors.darkBlueColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Bonus Type (e.g., Performance, Year-End)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: numberOfStaff.toString()),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.5,
                color: ThemeColors.darkBlueColor,
              ),
              decoration: InputDecoration(
                labelText: 'Number of Staff Needed',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                numberOfStaff = int.parse(text);
              },
            ),
            const SizedBox(height: 400, width: 40)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNextScreen,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
