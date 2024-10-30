import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payapp/models/subjectmodel.dart';
import 'package:payapp/themes/colors.dart';



class SubjectTileWidget extends StatelessWidget {
  final SubjectModel subject;
  final Function()? onTap;
  const SubjectTileWidget({Key? key, required this.subject,this.onTap}) : super(key: key);

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

            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subject.name,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),),
                const Icon(Iconsax.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
