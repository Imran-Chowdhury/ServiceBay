

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/calendar_controller.dart';
import '../controllers/job_controller.dart';
import '../widgets/custom_drawer.dart';





class CalendarScreen extends ConsumerStatefulWidget {
  final String mechanicUid;
  final String? role;

  CalendarScreen(this.mechanicUid, {required this.role});

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
        stream: widget.role == 'mechanic'?getMechanicBookings(widget.mechanicUid):getAdminBookings(), // Fetch mechanic bookings from Firestore
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

                // Show a dialog with a list of appointments
                // showDialog(context: context, builder: (BuildContext context){
                //   return  Container(
                //     height: 30,
                //     width: 30,
                //     color: Colors.red,
                //   );
                // });


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

            // onTap: (CalendarTapDetails details) {
            //   if (details.appointments != null && details.appointments!.isNotEmpty) {
            //     final Appointment appointment = details.appointments![0];
            //
            //     // Split the notes to extract additional information
            //     final List<String> notes = appointment.notes!.split('\n');
            //     final phone = notes[0].split(': ')[1]; // Extract phone
            //     final email = notes[1].split(': ')[1]; // Extract email
            //     final customerName = notes[3].split(': ')[1];
            //
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return AlertDialog(
            //           title: Text(appointment.subject),
            //           content: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text('Customer Name: $customerName'),
            //               Text('Phone: $phone'),
            //               Text('Email: $email'),
            //               Text('Car: ${notes[2]}'), // Car make and model
            //               Text('Booking Start: ${appointment.startTime}'),
            //               Text('Booking End: ${appointment.endTime}'),
            //             ],
            //           ),
            //           actions: [
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.of(context).pop();
            //               },
            //               child: Text('Close'),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   }
            // },
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
    final phone = notes[0].split(': ')[1];
    final email = notes[1].split(': ')[1];
    final customerName = notes[3].split(': ')[1];

    return Scaffold(
      appBar: AppBar(
        title: Text(appointment.subject),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Name: $customerName'),
            Text('Phone: $phone'),
            Text('Email: $email'),
            Text('Car: ${notes[2]}'),
            Text('Booking Start: ${appointment.startTime}'),
            Text('Booking End: ${appointment.endTime}'),
          ],
        ),
      ),
    );
  }
}




