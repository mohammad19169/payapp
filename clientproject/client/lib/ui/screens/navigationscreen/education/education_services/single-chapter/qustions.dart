import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:payapp/core/components/print_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../themes/colors.dart';

class Questions extends StatefulWidget {
  final String categoryId;
  final String examName;
  final String subjectName;
  final String chapterName;

  const Questions(
      {Key? key,
      required this.categoryId,
      required this.examName,
      required this.subjectName,
      required this.chapterName})
      : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  List questionsData = [];
  bool rightAnswer = true;
  int qsIndex = 0;
  var scrollController;
  bool markIt = false;
  bool isShowSolutions = false;
  bool isSelected = false;
  bool isCheckAns = false;
  bool isLoading = true;
  List selectOptions = [];
  List checkMark = [];

  late Timer _timer;
  int seconds = 00;
  int minutes = 00;
  int hours = 0;
  bool isTimerStart = false;

  String formatTime(int time) {
    return time < 10 ? '0$time' : '$time';
  }

  void startTimer(bool isStart) {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (isStart == false) {
            timer.cancel();
          } else {
            seconds += 1;
            if (seconds > 59) {
              minutes += 1;
              seconds = 0;
              if (minutes > 59) {
                hours += 1;
                minutes = 0;
              }
            }
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the scrollController here
    scrollController = ScrollController();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('token');
    final url =
        'https://xyzabc.sambhavapps.com/v1/education/quiz/find/chapter/${widget.categoryId}';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        setState(() {
          isLoading = true;
        });
        var data = json.decode(response.body)["data"];
        print("This is Data");
        data.forEach((x) {
          x["all_answer"].asMap().forEach((index, element) {
            String getCharAtPosition(int position) {
              if (position < 0 || position >= 26) {
                return "Invalid position. Please enter a value between 0 and 25.";
              }
              return String.fromCharCode('A'.codeUnitAt(0) + position);
            }

            var g = {
              "answerText": element,
              "rightAnswer": element == x["correct_answer"],
              "position": getCharAtPosition(index),
            };
            x["all_answer"][index] = g;
            // print(x["all_answer"]);
            // print(
            //     'Index: $index, Element: $element, Position: ${getCharAtPosition(index)}');
          });

          questionsData = [...questionsData, x];
        });
        print("Questions Data : ");
        print(questionsData);
        setState(() {
          isLoading = false;
        });
      });
    } else {
      // Display an error message to the user, e.g., using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error loading questions. Please try again.'),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: ThemeColors.primaryBlueColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "${widget.examName} > ${widget.subjectName} > ${widget.chapterName}",
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
              color: ThemeColors.primaryBlueColor,
            ),
            actions: [
              InkWell(
                onTap: () {
                  setState(() {
                    isTimerStart = true;
                  });
                  startTimer(true);
                },
                child: Container(
                  width: 110,
                  margin: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
                  decoration: BoxDecoration(
                      color: ThemeColors.primaryBlueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          width: 1, color: ThemeColors.primaryBlueColor)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.watch_later_outlined,
                          color: ThemeColors.primaryBlueColor,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        isTimerStart
                            ? Text(
                                "${formatTime(minutes)}:${formatTime(seconds)}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.primaryBlueColor,
                                ),
                              )
                            : const Text(
                                "Start Timer",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.primaryBlueColor,
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator()) // Show loading indicator
              : questionsData.isEmpty
                  ? const Center(child: Text("No Questions to display here"))
                  : SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 50),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Qs${qsIndex + 1} (Single Correct)",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 14),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    markIt = !markIt;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      markIt
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      size: 25,
                                      color: ThemeColors.primaryBlueColor,
                                    ),
                                    const Text(
                                      "Mark It",
                                      style: TextStyle(
                                          color: ThemeColors.primaryBlueColor,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "${questionsData[qsIndex]["question"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Image.network(
                                "${questionsData[qsIndex]['question_image']}",
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: ThemeColors.primaryBlueColor
                                            .withOpacity(0.1),
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                ThemeColors.primaryBlueColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      questionsData[qsIndex]["tag"],
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: ThemeColors.primaryBlueColor),
                                    ),
                                  ),
                                  isCheckAns
                                      ? InkWell(
                                          onTap: () {
                                            setState(() {
                                              isShowSolutions = true;
                                            });
                                            Timer(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              scrollController.animateTo(
                                                  scrollController
                                                      .position.maxScrollExtent,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeIn);
                                            });
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color:
                                                  ThemeColors.primaryBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "Show Solutions",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              ...(questionsData[qsIndex]["all_answer"] as List)
                                  .map((answer) => InkWell(
                                        onTap: () {
                                          isCheckAns
                                              ? null
                                              : setState(() {
                                                  selectOptions.clear();
                                                  selectOptions.add(
                                                      "${answer["position"]}");
                                                  checkAnd(
                                                      answer["rightAnswer"]);
                                                });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 1,
                                                  color: selectOptions.contains(
                                                          "${answer["position"]}")
                                                      ? Colors.green
                                                          .withOpacity(0.5)
                                                      : Colors.transparent),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: selectOptions.contains(
                                                            "${answer["position"]}")
                                                        ? Colors.green
                                                            .withOpacity(0.3)
                                                        : ThemeColors
                                                            .primaryBlueColor
                                                            .withOpacity(0.3),
                                                    blurRadius: 4,
                                                    spreadRadius: 2,
                                                    offset: const Offset(0, 1))
                                              ]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: selectOptions.contains(
                                                              "${answer["position"]}")
                                                          ? rightAnswer
                                                              ? Colors.green
                                                              : Colors.redAccent
                                                          : Colors
                                                              .grey.shade300,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${answer["position"]}",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: selectOptions
                                                                    .contains(
                                                                        "${answer["position"]}")
                                                                ? Colors.white
                                                                : Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  SizedBox(
                                                    width: isCheckAns == true
                                                        ? size.width * 0.6
                                                        : size.width * 0.7,
                                                    child: Text(
                                                      "${answer["answerText"]}",
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (isCheckAns == true &&
                                                  checkMark.isNotEmpty &&
                                                  selectOptions.contains(
                                                      "${answer["position"]}"))
                                                ...checkMark,
                                            ],
                                          ),
                                        ),
                                      )),
                              isShowSolutions
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Text(
                                          "Solution: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Image.network(
                                          questionsData[qsIndex]
                                              ["solution_image"],
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                        )
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ],
                      ),
                    ),
          bottomNavigationBar: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            width: size.width,
            height: 80,
            decoration: BoxDecoration(
                border: Border.fromBorderSide(
                    BorderSide(width: 1, color: Colors.grey.shade300))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: qsIndex != 0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (qsIndex > 0) {
                          qsIndex--;
                          isCheckAns = false;
                          isShowSolutions = false;
                          isSelected = false;
                          selectOptions.clear();
                        }
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 1, color: ThemeColors.primaryBlueColor),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 7),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: ThemeColors.primaryBlueColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isCheckAns = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: selectOptions.isNotEmpty
                          ? isCheckAns
                              ? Colors.grey.shade300
                              : ThemeColors.primaryBlueColor
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Check Answer",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selectOptions.isNotEmpty
                              ? isCheckAns
                                  ? Colors.grey
                                  : Colors.white
                              : Colors.grey,
                          fontSize: 15),
                    ),
                  ),
                ),
                Visibility(
                  visible: qsIndex + 1 != questionsData.length,
                  child: InkWell(
                    onTap: () {
                      if (qsIndex < questionsData.length) {
                        setState(() {
                          if (qsIndex < questionsData.length) {
                            if (isCheckAns) {
                              qsIndex++;
                              isCheckAns = false;
                              isShowSolutions = false;
                              isSelected = false;
                              selectOptions.clear();
                            }
                          }
                        });
                      } else {
                        null;
                      }

                      printThis("qsIndex === $qsIndex");
                      printThis(
                          " qsJson.qsJson.length === ${questionsData.length}");
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 1, color: ThemeColors.primaryBlueColor),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: ThemeColors.primaryBlueColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell buildQsOption({
    required String label,
    required String position,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                width: 1,
                color: selectOptions.contains("A")
                    ? Colors.green.withOpacity(0.5)
                    : Colors.transparent),
            boxShadow: [
              BoxShadow(
                  color: selectOptions.contains("A")
                      ? Colors.green.withOpacity(0.3)
                      : ThemeColors.primaryBlueColor.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: const Offset(0, 1))
            ]),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: selectOptions.contains("A")
                    ? Colors.green
                    : Colors.grey.shade300,
              ),
              child: Center(
                child: Text(
                  "A",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: selectOptions.contains("A")
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              "1.98787990",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  void checkAnd(rightAns) {
    checkMark.clear();
    rightAnswer = rightAns;
    checkMark.add(
      rightAns
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 30,
            )
          : const Icon(
              Icons.clear,
              color: Colors.redAccent,
              size: 30,
            ),
    );
  }
}
