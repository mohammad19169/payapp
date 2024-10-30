class CaHomeServicesModel {
  final String status;
  final List<CAHomeServicesDataModel> data;

  CaHomeServicesModel({
    required this.status,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data,
    };
  }

  factory CaHomeServicesModel.fromMap(Map<String, dynamic> map) {
    return CaHomeServicesModel(
      status: map['status'] ,
      data: map['data'] as List<CAHomeServicesDataModel>,
    );
  }
}

class CAHomeServicesDataModel {
  final String id;
  final String catName;
  final String cat_img;
  final int  status;

  CAHomeServicesDataModel({
    required this.id,
    required this.catName,
    required this.cat_img,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cat_name': catName,
      'cat_img': cat_img,
      'status': status,
    };
  }

  factory CAHomeServicesDataModel.fromMap(Map<String, dynamic> map) {
    return CAHomeServicesDataModel(
      id: map['id'] as String,
      catName: map['cat_name'] as String,
      cat_img: map['cat_img'] as String,
      status: map['status'] as int,
    );
  }
}
