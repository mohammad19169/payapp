import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingTile extends StatelessWidget {
  final String title;
  const HeadingTile({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0,left: 15),
      child: Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
    );
  }
}
