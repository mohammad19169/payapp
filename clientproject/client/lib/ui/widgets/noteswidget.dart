import 'package:flutter/material.dart';
import 'package:payapp/models/notesmodel.dart';
import 'package:payapp/themes/colors.dart';

import '../../models/competitive_model.dart';
import '../screens/navigationscreen/education/downloadPdfButton.dart';



class NotesTileWidget extends StatelessWidget {
  final NotesModel notes;
  final Function()? onTap;
  const NotesTileWidget({Key? key, required this.notes,this.onTap}) : super(key: key);

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

                height: 80,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(notes.chapter_name,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),),
                          const SizedBox(height: 7,),
                          Text(notes.subject_name,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04,color: Colors.grey),),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //   Text(notes.subject_name,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04,color: Colors.grey),),
                          //   Text('Class:- '+notes.class_name,style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04,color: Colors.grey),),
                          // ],)
                        ],
                      ),
                    ),
                    DownloadPdfButton(competitiveNotes: CompetitiveNotes(id: "",fileName: notes.fileName,examId: "",pdfFile: notes.pdf_file,topic: ""),),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
