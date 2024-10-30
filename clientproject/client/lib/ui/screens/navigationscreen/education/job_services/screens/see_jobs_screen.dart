import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payapp/ui/screens/navigationscreen/education/job_services/screens/preferences_screen.dart';

import '../../../../../../themes/colors.dart';
import 'build_resume_screen.dart';
import 'experience_screen.dart';
import 'jobs_search_screen.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:location/location.dart';

class Country {
  final int id;
  final String name;
  final String iso3;
  final String iso2;
  final String? numericCode; // Optional
  final String? phoneCode; // Optional
  final String capital;
  final String? currency; // Optional
  final String? currencyName; // Optional
  final String? currencySymbol; // Optional
  final String? tld; // Optional
  final String? native;
  final String region;
  final String? subregion; // Optional
  final double latitude;
  final double longitude;
  final String emoji;

  Country({
    required this.id,
    required this.name,
    required this.iso3,
    required this.iso2,
    this.numericCode,
    this.phoneCode,
    required this.capital,
    this.currency,
    this.currencyName,
    this.currencySymbol,
    this.tld,
    required this.native,
    required this.region,
    this.subregion,
    required this.latitude,
    required this.longitude,
    required this.emoji,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      iso3: json['iso3'],
      iso2: json['iso2'],
      numericCode: json['numeric_code'],
      phoneCode: json['phone_code']?.toString(),
      capital: json['capital'],
      currency: json['currency'],
      currencyName: json['currency_name'],
      currencySymbol: json['currency_symbol'],
      tld: json['tld'],
      native: json['native'],
      region: json['region'],
      subregion: json['subregion'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      emoji: json['emoji'],
    );
  }
}

class CountryWithStates {
  final int id;
  final List<CountryState> states;

  CountryWithStates({
    required this.id,
    required this.states,
  });

  factory CountryWithStates.fromJson(Map<String, dynamic> json) {
    return CountryWithStates(
      id: json['id'],
      states: List<CountryState>.from(
          json['states'].map((x) => CountryState.fromJson(x))),
    );
  }
}

class CountryState {
  final int id;
  final String name;
  final String stateCode;

  CountryState({
    required this.id,
    required this.name,
    required this.stateCode,
  });

  factory CountryState.fromJson(Map<String, dynamic> json) {
    return CountryState(
      id: json['id'],
      name: json['name'],
      stateCode: json['state_code'],
    );
  }
}

class CountryWithStatesAndCities {
  final int id;
  final List<StateWithCities> states;

  CountryWithStatesAndCities({required this.id, required this.states});

  factory CountryWithStatesAndCities.fromJson(Map<String, dynamic> json) {
    return CountryWithStatesAndCities(
      id: json['id'],
      states: List<StateWithCities>.from(
          json['states'].map((x) => StateWithCities.fromJson(x))),
    );
  }
}

class StateWithCities {
  final int id;
  final List<City> cities;

  StateWithCities({required this.id, required this.cities});

  factory StateWithCities.fromJson(Map<String, dynamic> json) {
    return StateWithCities(
      id: json['id'],
      cities: List<City>.from(json['cities'].map((x) => City.fromJson(x))),
    );
  }
}

class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  City({required this.id,
    required this.name,
    required this.latitude,
    required this.longitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
    );
  }
}

class Language {
  final String code;
  final String name;
  final String native;

  Language({
    required this.code,
    required this.name,
    required this.native,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'],
      name: json['name'],
      native: json['native'],
    );
  }
}

class SeeJobsScreen extends StatefulWidget {
  final ResumeData resumeData;
  final Course selectedCourse;
  final Map<Job, bool> selectedJobs;

  const SeeJobsScreen({super.key,
    required this.resumeData,
    required this.selectedCourse,
    required this.selectedJobs});

  @override
  _SeeJobsScreenState createState() => _SeeJobsScreenState();
}

class _SeeJobsScreenState extends State<SeeJobsScreen> {
  String _selectedEnglishProficiency =
      "Good English"; // Default selected proficiency
  int activeStep = 3;
  Country? selectedCountry;
  CountryState? selectedState;
  City? selectedCity;
  String? _logoUrl;
  Language? selectedLanguage;
  List<Country> countries = [];
  List<CountryWithStates> states = [];
  List<CountryWithStatesAndCities> cities = [];
  List<Language> languages = [];
  List<String> englishProficiencyLevels = [
    "No English",
    "Thoda English",
    "Good English",
    "Fluent English"
  ];
  Location location = Location();
  LocationData? _locationData;

  Future<void> loadJsonData() async {
    final countryResponse =
    await rootBundle.loadString('assets/data/countriesminified.json');
    final stateResponse =
    await rootBundle.loadString('assets/data/statesminified.json');
    final cityResponse =
    await rootBundle.loadString('assets/data/citiesminified.json');
    final languageResponse =
    await rootBundle.loadString('assets/data/languagesminified.json');
    setState(() {
      countries = List<Country>.from(
          json.decode(countryResponse).map((x) => Country.fromJson(x)));
      states = List<CountryWithStates>.from(
          json.decode(stateResponse).map((x) => CountryWithStates.fromJson(x)));
      print(json.decode(cityResponse));
      cities = List<CountryWithStatesAndCities>.from(json
          .decode(cityResponse)
          .map((jsonCountry) =>
          CountryWithStatesAndCities.fromJson(jsonCountry)));
      languages = List<Language>.from(json
          .decode(languageResponse)
          .map((jsonLanguage) => Language.fromJson(jsonLanguage)));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    loadJsonData();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  Future<void> _postJobPreferences() async {
    Future<void> uploadImage(XFile image) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://xyzabc.sambhavapps.com/v1/media/uploads'),
        );
        request.headers['Authorization'] = 'Bearer $token';
        request.files
            .add(await http.MultipartFile.fromPath('media', image.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final responseJson = jsonDecode(responseData);
          setState(() {
            _logoUrl =
            responseJson['url']; // Adjust this based on your API response
          });
        } else {
          print(await response.stream.bytesToString());
          print(response.statusCode);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User token not found. Please log in again.')),
        );
      }
    }

    await uploadImage(widget.resumeData.profilePicture!);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    if (token == null) {
      // Handle token not available case
      return;
    }
    List<String> getTrueJobs(Map<Job, bool> jobMap) {
      List<String> trueJobs = [];

      jobMap.forEach((job, isTrue) {
        if (isTrue) {
          trueJobs.add(job.id);
        }
      });
      return trueJobs;
    }

    List<String> trueJobs = getTrueJobs(widget.selectedJobs);

    var resumeData = {
      "logo": _logoUrl,
      "name": widget.resumeData.fullName,
      "email": widget.resumeData.email,
      "age": widget.resumeData.age,
      "gender": widget.resumeData.gender,
      "qualification": widget.selectedCourse.id,
      "department": trueJobs,
      "location": "${_locationData!.latitude}, ${_locationData!.longitude}",
      "languages": [_selectedEnglishProficiency, "English"]
      /// selectedLanguage!.name
    };
    print(resumeData);
    var response = await http.post(
      Uri.parse('https://xyzabc.sambhavapps.com/v1/job/p1/employe'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(resumeData),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => JobSearchScreen(),
      ));
    } else {
      print(response.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to post job preferences"),
        backgroundColor: Colors.redAccent,));
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<CountryState>> getStateItems() {
      var list = <DropdownMenuItem<CountryState>>[];
      if (selectedCountry != null) {
        Iterable<CountryWithStates> country =
        states.where((country) => country.id == selectedCountry!.id);
        list =
            country.first.states.map<DropdownMenuItem<CountryState>>((state) {
              return DropdownMenuItem(value: state, child: Text(state.name));
            }).toList();
      }
      return list;
    }

    List<DropdownMenuItem<City>> getCityItems() {
      List<DropdownMenuItem<City>> list = [];
      if (selectedState != null) {
        list = cities
            .where((country) => country.id == selectedCountry!.id)
            .first
            .states
            .where((state) => state.id == selectedState!.id)
            .first
            .cities
            .map<DropdownMenuItem<City>>((city) {
          return DropdownMenuItem(value: city, child: Text(city.name));
        }).toList();
      }
      return list;
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              foregroundColor:
              WidgetStateProperty.all(ThemeColors.darkBlueColor),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.blue)),
              ),
              textStyle: WidgetStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 16), // Set text style
              ),
            ),
            child: const Text(
              '        BACK      ',
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            )),
        const SizedBox(
          width: 20,
        ),
        OutlinedButton(
            onPressed: () async {
              await _postJobPreferences();
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => JobSearchScreen(),
              // ));
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.blue)),
              ),
              textStyle: WidgetStateProperty.all<TextStyle>(
                const TextStyle(fontSize: 16), // Set text style
              ),
            ),
            child: const Text(
              '        SEE JOBS      ',
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ))
      ]),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                height: 80,
                color: ThemeColors.primaryBlueColor,
                child: StepProgressIndicator()),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey,
              child: const Text(
                "Additional info like language preferences, Resume, etc. helps us to filter relevant jobs for you",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              child: Wrap(
                spacing: 20,
                children: englishProficiencyLevels.map((level) {
                  bool isSelected = level == _selectedEnglishProficiency;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedEnglishProficiency = level;
                      });
                    },
                    child: Container(
                      height: 70,
                      width: 170,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blueAccent
                            : Colors.transparent, // Indicate selected
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          level,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(3),
              ),
              child: DropdownButton<Country>(
                value: selectedCountry,
                padding: const EdgeInsets.all(0),
                icon: const SizedBox(),
                underline: const SizedBox(),
                hint: const Text("Select Country"),
                onChanged: (newValue) {
                  setState(() {
                    selectedCountry = newValue;
                    selectedState =
                    null; // Reset state and city on country change
                    selectedCity = null;
                  });
                },
                items: countries.map<DropdownMenuItem<Country>>((country) {
                  return DropdownMenuItem(
                      value: country,
                      child: Text("${country.emoji} ${country.name}"));
                }).toList(),
              ),
            ),
            if (selectedCountry != null)
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: DropdownButton<CountryState>(
                  value: selectedState,
                  padding: const EdgeInsets.all(0),
                  icon: const SizedBox(),
                  underline: const SizedBox(),
                  hint: const Text("Select State"),
                  onChanged: (newValue) {
                    setState(() {
                      selectedState = newValue;
                      selectedCity = null; // Reset city on state change
                    });
                  },
                  items: getStateItems(),
                ),
              ),
            if (selectedState != null)
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: DropdownButton<City>(
                  value: selectedCity,
                  padding: const EdgeInsets.all(0),
                  icon: const SizedBox(),
                  underline: const SizedBox(),
                  hint: const Text("Select City"),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCity = newValue;
                    });
                  },
                  items: getCityItems(),
                ),
              ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(3),
              ),
              child: DropdownButton<Language>(
                value: selectedLanguage,
                padding: const EdgeInsets.all(0),
                icon: const SizedBox(),
                underline: const SizedBox(),
                hint: const Text("Select Language"),
                onChanged: (newValue) {
                  setState(() {
                    selectedLanguage = newValue;
                  });
                },
                items: languages.map<DropdownMenuItem<Language>>((language) {
                  return DropdownMenuItem(
                      value: language, child: Text(language.name));
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.check, color: Colors.white),
          ),
          Expanded(
            child: Divider(color: Colors.blue, thickness: 3),
          ),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.check, color: Colors.white),
          ),
          Expanded(
            child: Divider(color: Colors.grey, thickness: 3),
          ),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.check, color: Colors.white),
          ),
          Expanded(
            child: Divider(color: Colors.grey, thickness: 3),
          ),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              '4',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
