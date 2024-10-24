

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
    final bookingTitle = notes[7];


    // final startTime = DateFormat('yyyy-MM-dd h:mm').format(notes[8] as DateTime);
    // final endTime = DateFormat('yyyy-MM-dd h:mm').format(notes[9] as DateTime);
    final mechanicName = notes[8];
    final mechanicId = notes[9];

    String startDate = DateFormat('yyyy-MM-dd h:mm').format(appointment.startTime);
    String endDate = DateFormat('yyyy-MM-dd h:mm').format(appointment.endTime);



    return Scaffold(
      appBar: AppBar(
        // title: Text(appointment.subject),
        // title: Text(bookingTitle.trim()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Align(
              alignment: Alignment.topCenter,
              child: Text(appointment.subject),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('Booking Start: ${appointment.startTime}'),
                // Text('Booking End: ${appointment.endTime}'),
                Text('Start'),
                Text('End'),

              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('Booking Start: ${appointment.startTime}'),
                // Text('Booking End: ${appointment.endTime}'),
                Text('$startDate'),
                Text('$endDate'),

              ],
            ),
            const Text('Customer Details'),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 150,
                  // constraints: BoxConstraints(minHeight: 50, maxHeight: 200,minWidth: 150, maxWidth: double.infinity),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
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
                          child: Text(
                            customerName.trim(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            maxLines: 1,  // Ensures it fits in one line
                            overflow: TextOverflow.ellipsis,  // Truncates with '...'
                          ),
                        ),
                        SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            phone.trim(),
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            email.trim(),
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const Text('Car Details'),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 150,
                  // constraints: BoxConstraints(minHeight: 50, maxHeight: 200,minWidth: 150, maxWidth: double.infinity),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
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
                          child: Text(
                            carMake.trim(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            maxLines: 1,  // Ensures it fits in one line
                            overflow: TextOverflow.ellipsis,  // Truncates with '...'
                          ),
                        ),
                        SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            carModel.trim(),
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            registrationPlate.trim(),
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            carYear.trim(),
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


            const Text('Mechanic Details'),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 150,
                  // constraints: BoxConstraints(minHeight: 50, maxHeight: 200,minWidth: 150, maxWidth: double.infinity),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
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
                          child: Text(
                            mechanicName.trim(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            maxLines: 1,  // Ensures it fits in one line
                            overflow: TextOverflow.ellipsis,  // Truncates with '...'
                          ),
                        ),
                        SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            mechanicId.trim(),
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
















            // Text('Car: ${notes[2]}'),

          ],
        ),
      ),
    );
  }
}




