

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/calendar_controller.dart';
import '../controllers/job_controller.dart';
import '../widgets/custom_drawer.dart';





class CalendarScreen extends ConsumerStatefulWidget {
  final String uid;
  final String? role;

  CalendarScreen(this.uid, {required this.role});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width = size.width;


    final viewState = ref.watch(calendarControllerProvider); // Listen to state changes for rebuilding the UI

    return Scaffold(
      // drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFffffff),

        title: widget.role == 'mechanic'? const Text('Mechanic Calendar'):Text('Admin Calendar'),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.role == 'mechanic'?getMechanicBookings(widget.uid):getAdminBookings(), // Fetch mechanic bookings from Firestore
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final appointments = getBookingsFromSnapshot(snapshot.data!);

          return SfCalendar(
            key: ValueKey(viewState),
            view: viewState, // Bind the calendar view to the current state


            onTap: (CalendarTapDetails details) {
              if (details.appointments != null && details.appointments!.isNotEmpty) {
                final appointments = details.appointments!; // All appointments for that day

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Appointments on ${details.date}'),
                      content: Container(
                        height: height*.4,
                        width: width*.3,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final Appointment appointment = appointments[index];
                            return ListTile(
                              title: Text(appointment.subject), // Show appointment title
                              onTap: () {
                                // Navigate to the detail screen with the selected appointment
                                // Navigator.of(context).pop(); // Close the dialog
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentDetailScreen(
                                      appointment: appointment,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              }
            },

            backgroundColor: Colors.white, // Change the background color to white
            dataSource: BookingDataSource(appointments),
            headerStyle: const CalendarHeaderStyle(
              backgroundColor: Colors.red, // Change header background color
              textStyle: TextStyle(
                color: Colors.white, // Header text color
                fontSize: 20,
              ),
            ),
            viewHeaderStyle: const ViewHeaderStyle(
              backgroundColor: Colors.blue, // Change the view header background
              dayTextStyle: TextStyle(
                color: Colors.white, // Day text color
                fontSize: 16,
              ),
            ),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              agendaStyle: AgendaStyle(
                backgroundColor: Colors.white, // Agenda background color
                appointmentTextStyle: TextStyle(
                  color: Colors.black, // Appointment text color
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


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
                      height: width * .3,
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













                // Text(
                //   ' Customer Details',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontWeight: FontWeight.bold,
                //     fontSize:  width*.05,
                //   ),
                // ),
                // SizedBox(height: height * 0.02),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     child: Container(
                //       // height: 130,
                //       height: width*.34,
                //       // constraints: BoxConstraints(minHeight: 50, maxHeight: 200,minWidth: 150, maxWidth: double.infinity),
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         // color: Color(0XFFfdffff),
                //         color: Color(0XFFdbcfd0),
                //
                //         borderRadius: BorderRadius.circular(10),
                //         boxShadow: const [
                //           BoxShadow(
                //             color: Colors.black26,
                //             blurRadius: 10,
                //             offset: Offset(0, 5),
                //           ),
                //         ],
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(15.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Flexible(
                //               child: tileTexts(customerName: customerName, width: width),
                //             ),
                //             SizedBox(height: 8),
                //             Flexible(
                //               child: Text(
                //                 phone.trim(),
                //                 style: TextStyle(
                //                     fontSize: width*.045,
                //                     fontWeight: FontWeight.w400,
                //                     color: Colors.black
                //                 ),
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ),
                //             SizedBox(height: 8),
                //             Flexible(
                //               child: Text(
                //                 email.trim(),
                //                 style: TextStyle(
                //                     fontSize: width*.045,
                //                     fontWeight: FontWeight.w400,
                //                     color: Colors.black
                //                 ),
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: height * 0.02),
                //
                // Text(' Car Details',  style: TextStyle(
                //   fontWeight: FontWeight.bold,
                //   fontSize:  width*.05,
                // ),),
                // SizedBox(height: height * 0.02),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     child: Container(
                //       // height: 150,
                //       height: width*.39,
                //       // constraints: BoxConstraints(minHeight: 50, maxHeight: 200,minWidth: 150, maxWidth: double.infinity),
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         color: Color(0XFFdbcfd0),
                //         borderRadius: BorderRadius.circular(10),
                //         boxShadow: const [
                //           BoxShadow(
                //             color: Colors.black26,
                //             blurRadius: 10,
                //             offset: Offset(0, 5),
                //           ),
                //         ],
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(15.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Flexible(
                //               child: Text(
                //                 carMake.trim(),
                //                 style: TextStyle(
                //                     fontSize: width*.045,
                //                     fontWeight: FontWeight.w400,
                //                     color: Colors.black
                //                 ),
                //                 maxLines: 1,  // Ensures it fits in one line
                //                 overflow: TextOverflow.ellipsis,  // Truncates with '...'
                //               ),
                //             ),
                //             SizedBox(height: 8),
                //             Flexible(
                //               child: Text(
                //                 carModel.trim(),
                //                 style: TextStyle(
                //                     fontSize: width*.045,
                //                     fontWeight: FontWeight.w400,
                //                     color: Colors.black
                //                 ),
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ),
                //             SizedBox(height: 8),
                //             Flexible(
                //               child: Text(
                //                 registrationPlate.trim(),
                //                 style: TextStyle(
                //                     fontSize: width*.045,
                //                     fontWeight: FontWeight.w400,
                //                     color: Colors.black
                //                 ),
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ),
                //             SizedBox(height: 8),
                //             Flexible(
                //               child: Text(
                //                 carYear.trim(),
                //                 style: TextStyle(
                //                     fontSize: width*.045,
                //                     fontWeight: FontWeight.w400,
                //                     color: Colors.black
                //                 ),
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: height * 0.02),
                //
                // Text(' Mechanic Details',  style: TextStyle(
                //   fontWeight: FontWeight.bold,
                //   fontSize:  width*.05,
                // ),),
                // SizedBox(height: height * 0.02),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 25),
                //     child: Container(
                //       height: width*.3,
                //       // constraints: BoxConstraints(minHeight: 50, maxHeight: 200,minWidth: 150, maxWidth: double.infinity),
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         color: Color(0XFFdbcfd0),
                //         borderRadius: BorderRadius.circular(10),
                //         boxShadow: const [
                //           BoxShadow(
                //             color: Colors.black26,
                //             blurRadius: 10,
                //             offset: Offset(0, 5),
                //           ),
                //         ],
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(15.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Flexible(
                //               child: Text(
                //                 mechanicName.trim(),
                //                 style: TextStyle(
                //                     fontSize: width*.045,
                //                     fontWeight: FontWeight.w400,
                //                     color: Colors.black
                //                 ),
                //                 maxLines: 1,  // Ensures it fits in one line
                //                 overflow: TextOverflow.ellipsis,  // Truncates with '...'
                //               ),
                //             ),
                //             SizedBox(height: 8),
                //             Flexible(
                //               child: Text(
                //                 mechanicId.trim(),
                //                 style: TextStyle(
                //                     fontSize: width*.045,
                //                     fontWeight: FontWeight.w400,
                //                     color: Colors.black
                //                 ),
                //                 maxLines: 1,
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
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




