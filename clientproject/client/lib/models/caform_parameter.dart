


class CaFormModel {
  String id;
  String categoryId;
  String title;
  // String description;
  // List<String> benefits;
  List<dynamic> details;
  String image;
  String price;
  String status;
  List<dynamic> bannerImage;
  String descriptionVideo;
  String fullDescription;
  // List<CaFormParameterModel> formParamaters;



  CaFormModel({
    required this.id,
    required this.categoryId,
    required this.title,
    // required this.description,
    // required this.benefits,
    required this.details,
    required this.image,
    required this.price,
    required this.status,
    required this.bannerImage,
    required this.descriptionVideo,
    required this.fullDescription,
    // required this.formParamaters,



  });





  factory CaFormModel.fromMap(Map<dynamic, dynamic> map) {
    // final parameters = map["form"] as List;
    // final details = (map['benefits']??[])as List;
    return CaFormModel(
        id: map['id'] ?? "",
        categoryId: map['catagory_id'] ?? "",
        title: map['title']??"",
        // description: map['description']??"",
        // benefits:map['benefits']??[""],
        // details: details.map((e) => CaServiceDetailsModel.fromMap(e)).toList(),
        details:map['benefits']??[""],
        image: map['logo']??"",
        price: map['price']??"",
        status: map['status']??"",
        bannerImage: map['banners']??[],
        descriptionVideo: map['de_video']??"",
        fullDescription: map['full_description']??"",
        // formParamaters: parameters.map((e) => CaFormParameterModel.fromMap(e)).toList()
    );
  }







}

class CaFormParameterModel {
  String id;
  String caServiceId;
  String inputType;
  String type;
  String label;
  String options;
  String validation;
  String required;


  CaFormParameterModel({
    required this.id,
    required this.caServiceId,
    required this.inputType,
    required this.type,
    required this.label,
    required this.options,
    required this.validation,
    required this.required,

  });





  factory CaFormParameterModel.fromMap(Map<dynamic, dynamic> map) {
    return CaFormParameterModel(
      id: map['id'] ?? "",
      caServiceId: map['ca_service_id']??"",
      inputType: map['input_type']??"",
      type: map['type']??"",
      label: map['lable']??"",
      options: map['options']??"",
      validation: map['validation']??"",
      required: map['required']??"",

    );
  }







}



class CaServiceDetailsModel {
  String title;
  String description;


  CaServiceDetailsModel({
    required this.title,
    required this.description,
  });





  factory CaServiceDetailsModel.fromMap(Map<dynamic, dynamic> map) {
    return CaServiceDetailsModel(
      title: map['title'] ?? "",
      description: map['description']??"",
    );
  }







}



