import 'package:flutter/material.dart';
import 'package:payapp/models/ca_models/paymentdata.dart';
import 'package:payapp/models/ca_service_history_model.dart';
import 'package:payapp/models/caform_parameter.dart';
import 'package:payapp/models/caservicemodel.dart';
import 'package:payapp/services/apis/apiservice.dart';

import '../../models/ca_models/home_services_model.dart';
import '../../models/cacategorise_services.dart';
import '../../services/apis/remote_services/remote_ca_sservices/remote_ca_services.dart';

class CaServicesProvider extends ChangeNotifier {
  CaServiceModel services = CaServiceModel(
    id: '',
    title: 'title',
    description: 'description',
    trainingVideo: 'trainingVideo',
    categories: [],
    bannerImage: [],
  );
  List<paymentdataModel> servicespaymentList = [
    paymentdataModel(
        type: false,
        required: "amr alaa ali",
        lable: "no labale till now",
        id: "01011577033")
  ];
  bool isLoading = false;
  bool isLoadingForm = false;
  bool isLoadingCategorised = false;
  List<CaCategoriseServiceModel> categoriseServices = [];
  List<CaHistoryModel> serviceHistory = [];
  CaFormModel? serviceDetails;

  bool visible = false;
  final List formFields = [];

  //*********************************************************************************
  //*********************************************************************************

  bool isLoadingCAHOmeServices = false;
  List<CAHomeServicesDataModel> cAHomeServices = [];

  Future<List<CAHomeServicesDataModel>> getCAHomeServices() async {
    isLoadingCAHOmeServices = true;
    // final List<CAHomeServicesDataModel> servicesTemp = await RemoteCAServices.fetchCAHomeServices();
    cAHomeServices = await RemoteCAServices.fetchCAHomeServices();
    print(
        "====================================================================");
    print(
        "====================================================================");
    print(
        "====================================================================");
    print(
        "============================!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${cAHomeServices.length}");
    print(
        "============================!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${cAHomeServices[1]}");
    isLoadingCAHOmeServices = false;
    print(
        "++++++++++++++++++++++ca servicesss done +++++++++++++++++++++++++++++");
    notifyListeners();
    return cAHomeServices;
  }

  //*********************************************************************************
  //*********************************************************************************

  CaServicesProvider() {
    isLoading = true;
    getServices();
  }

  Future<CaServiceModel?> getServices() async {
    final servicesTemp = await ApiService.fetchAllCaServices();
    final servicespayments = await ApiService.FRequreddata();
    services = servicesTemp;
    servicespaymentList = servicespayments;
    isLoading = false;
    notifyListeners();
    return services;
  }

  Future<List<CaCategoriseServiceModel>> getCategoriseServices(
      {required String id}) async {
    categoriseServices = await ApiService.fetchAllCategoriseServices(id: id);
    isLoadingCategorised = false;
    notifyListeners();
    return categoriseServices;
  }

  Future<CaFormModel?> getServiceForm({required String id}) async {
    formFields.clear();
    final value = await ApiService.fetchAllFormParameters(id: id);
    isLoading = false;
    // print("the value of services details is ===>>>>>>>>>>>>");
    // print("the value of services details is ===>>>>>>>>>>>>");
    // print("the value of services details is ===>>>>>>>>>>>>");
    // print("the value of services details is ===>>>>>>>>>>>>");
    // print("the value of services details is ===>>>>>>>>>>>>");
    // print(value["banners"]);
    // print(value["id"]);
    serviceDetails = CaFormModel(
        id: value["id"],
        categoryId: value["category_id"],
        title: value["title"],
        details: value["benefits"],
        image: value["logo"],
        price: value["price"],
        status: "success",
        bannerImage: value["banners"],
        descriptionVideo: "descriptionVideo",
        fullDescription:  "fullDescription");
    // if (serviceDetails != null) {
    //   for (var element in serviceDetails!.formParamaters) {
    //     if (element.inputType == "file") {
    //       formFields.add(ImagePickerWidget(
    //         label: element.label,
    //       ));
    //     } else if (element.type == "date") {
    //       formFields.add(DatePickerWidget(
    //         label: element.label,
    //       ));
    //     } else {
    //       formFields.add(FormFieldWidget(
    //         title: element.label,
    //         editingController: TextEditingController(),
    //         validator: (value) => FormValidator.validateMobile(value),
    //         validationType: element.validation,
    //       ));
    //     }
    //   }
    // }

    isLoadingForm = false;
    notifyListeners();
    return serviceDetails;
  }

  Future<List<CaHistoryModel>> getServiceHistory(
      {required String userId}) async {
    serviceHistory = await ApiService.fetchAllCaServiceHistory(userId: userId);
    isLoading = false;
    notifyListeners();
    return serviceHistory;
  }

  void visibilityOfVideo() {
    visible = !visible;
    notifyListeners();
  }
}
