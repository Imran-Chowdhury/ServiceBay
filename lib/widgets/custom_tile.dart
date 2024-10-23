import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0, // Set the elevation
      borderRadius: BorderRadius.circular(20.0), // Optional: Add rounded corners
      // shadowColor: Colors.black.withOpacity(0.5), // Optional: Customize the shadow color
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color:const Color(0XFFF5F5DC),

          borderRadius: BorderRadius.circular(20.0), // Same as Material's borderRadius
        ),
        child:  Column(
          children: [
            const SizedBox(height: 20,),
            const Icon(
              Icons.sticky_note_2_outlined,
              size: 80,
            ),

            Center(
              child: Text(

                'hskjahsd',
                style: const  TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
