

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailScreen({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final List<String> notes = appointment.notes!.split('\n');

    final phone = notes[0];
    final email = notes[1];
    final carMake = notes[2];
    final carModel = notes[3];
    final carYear =notes[4];
    final registrationPlate =notes[5];

    final customerName = notes[6];
    // final bookingTitle = notes[7];


    final mechanicName = notes[8];
    final mechanicId = notes[9];

    String startDate = DateFormat('yyyy-MM-dd h:mm').format(appointment.startTime);
    String endDate = DateFormat('yyyy-MM-dd h:mm').format(appointment.endTime);

    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f0),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back button here
        ),

        backgroundColor: const Color(0XFFd71e23),
        // title: Text(appointment.subject),
        // title: Text(bookingTitle.trim()),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [

            Container(
                height: height*.3,
                width: double.infinity,

                decoration: BoxDecoration(
                    color: Color(0XFFd71e23),
                    borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(width*.09), bottomRight: Radius.circular(width*.09))
                )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Align(
                  alignment: Alignment.topCenter,
                  child: Text(appointment.subject,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: width*.06,
                        fontWeight: FontWeight.bold

                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      padding:  EdgeInsets.only(left: width*.08),
                      child: Text(
                        'Start',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:  width*.05,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right: width*.08),
                      child: Text(
                        'End',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:  width*.05,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text('Booking Start: ${appointment.startTime}'),
                    // Text('Booking End: ${appointment.endTime}'),
                    Text(
                      '$startDate',
                      style: TextStyle(
                        fontSize:  width*.04,

                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$endDate',
                      style: TextStyle(
                        fontSize:  width*.04,
                        color: Colors.white,
                      ),
                    ),

                  ],
                ),
                SizedBox(height: height * 0.02),

                Text(
                  ' Customer Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:  width*.05,
                  ),
                ),
                SizedBox(height: height * 0.02),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: width * .34,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0XFFdbcfd0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: tileTexts(customerName: customerName, width: width),
                            ),
                            SizedBox(height: 8),
                            Flexible(
                              child: tileTexts(customerName: phone, width: width),
                            ),
                            SizedBox(height: 8),
                            Flexible(
                              child: tileTexts(customerName: email, width: width),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),

                Text(' Car Details', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * .05,
                )),
                SizedBox(height: height * 0.02),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: width * .39,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0XFFdbcfd0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: tileTexts(customerName: carMake, width: width),
                            ),
                            SizedBox(height: 8),
                            Flexible(
                              child: tileTexts(customerName: carModel, width: width),
                            ),
                            SizedBox(height: 8),
                            Flexible(
                              child: tileTexts(customerName: registrationPlate, width: width),
                            ),
                            SizedBox(height: 8),
                            Flexible(
                              child: tileTexts(customerName: carYear, width: width),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),

                Text(' Mechanic Details', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * .05,
                )),
                SizedBox(height: height * 0.02),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      height: width * .37,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0XFFdbcfd0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: tileTexts(customerName: mechanicName, width: width),
                            ),
                            SizedBox(height: 8),
                            Flexible(
                              child: tileTexts(customerName: mechanicId, width: width),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class tileTexts extends StatelessWidget {
  const tileTexts({
    super.key,
    required this.customerName,
    required this.width,
  });

  final String customerName;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Text(
      customerName.trim(),
      style: TextStyle(
          fontSize: width*.045,
          fontWeight: FontWeight.w400,
          color: Colors.black
      ),
      maxLines: 1,  // Ensures it fits in one line
      overflow: TextOverflow.ellipsis,  // Truncates with '...'
    );
  }
}
