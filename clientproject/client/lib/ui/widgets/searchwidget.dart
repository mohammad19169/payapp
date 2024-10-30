import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class SearchWidget extends StatelessWidget {
  final Function()? onTap;
  const SearchWidget({Key? key,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(1000),
      onTap: onTap,
      child: Container(
        color: Colors.blue.shade50,
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1000)),
          child: Row(children: [
            const Icon(Iconsax.search_normal_1),

            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:15),
              child: Text("Search by Name or Number",style: GoogleFonts.poppins(color: Colors.grey,fontSize: 15),maxLines: 1,overflow: TextOverflow.ellipsis,),
            ))
          ],),
        ),
      ),
    );
  }
}
