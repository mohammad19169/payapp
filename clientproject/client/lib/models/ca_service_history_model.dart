class CaHistoryModel {
  String title;
  String amount;
  String date;



  CaHistoryModel({
    required this.title,
    required this.amount,
    required this.date,



  });





  factory CaHistoryModel.fromMap(Map<dynamic, dynamic> map) {
    return CaHistoryModel(
        title: map['servicetitle'] ?? "",
        amount: map['amount'] ?? "",
        date: map['date']??"",

    );
  }







}