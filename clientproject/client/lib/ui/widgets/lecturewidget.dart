import 'package:flutter/material.dart';
import 'package:payapp/models/videolecturemodel.dart';
import 'package:payapp/themes/colors.dart';

import '../../config/apiconfig.dart';



class LectureWidget extends StatelessWidget {
  final VideoLectureModel lecture;
  final Function()? onTap;
  const LectureWidget({Key? key, required this.lecture,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          splashColor: ThemeColors.primaryBlueColor.withOpacity(.05),
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20),

          onTap: onTap,

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            height: 120,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide( //                   <--- right side
                        color: Colors.black,
                        width: 3.0,
                      ),
                    )
                  ),
                  child: Image.network(
                        Constants.forImg +
                            lecture.image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: 120,
                        filterQuality: FilterQuality.high,
                      ),
                ),
                Expanded(
                  child:Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Text(lecture.description,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
