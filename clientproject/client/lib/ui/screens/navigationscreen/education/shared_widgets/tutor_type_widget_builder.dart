import 'package:flutter/material.dart';


InkWell tutorTypeWidget({
  required String label,
  required String image,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 140,
      height: 140,
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10,),
      decoration: BoxDecoration(
          color:  Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color:Colors.grey.shade300,
                spreadRadius: 1,
                blurRadius: 2,
                offset:const Offset(-1,2)
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 50, width: 50,),
          const SizedBox(height: 10,),
          Center(
            child: Text(label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}