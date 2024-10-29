

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/calendar_controller.dart';
import '../controllers/job_controller.dart';
import '../widgets/custom_drawer.dart';
import 'appointment_details_screen.dart';





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
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0XFFd71e23),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back button here
        ),

        // title: widget.role == 'mechanic'? const Text('Mechanic Calendar'):Text('Admin Calendar'),

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
            showDatePickerButton: true, // Enables the month/year picker
            initialSelectedDate: DateTime.now(),
            // monthViewSettings: MonthViewSettings(
            //   navigationDirection: MonthNavigationDirection.vertical,
            //   showTrailingAndLeadingDates: true,
            // ),



            onTap: (CalendarTapDetails details) {
              if (details.appointments != null && details.appointments!.isNotEmpty) {
                final appointments = details.appointments!; // All appointments for that day

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // backgroundColor:const Color(0XFFdbcfd0),
                      // backgroundColor: Color(0xFFF5F5DC),

                      title: Text(DateFormat('yyyy-MM-dd').format(details.date!),
                        style: const TextStyle(
                        // color:  Color(0XFFdbcfd0)
                          color:  Colors.black,
                      ),),
                      content: Container(
                        // color: Color(0XFFd71e23),
                        // color: Color(0xFFF5F5DC),

                        height: height*.5,
                        width: width*.3,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final Appointment appointment = appointments[index];
                            return ListTile(
                              title: Text(
                                appointment.subject,
                                style:  TextStyle(
                                  // color: Color(0XFFdbcfd0),
                                  color: Colors.black,
                                  fontSize: width*.045,
                                ),), // Show appointment title
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
                          child: Text('Close', style:  TextStyle(
                            // color: Color(0XFFdbcfd0),
                            color: Colors.black,
                            fontSize: width*.045,
                          ),),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            appointmentTextStyle: const TextStyle(
              color: Colors.black
            ),

            backgroundColor: Colors.white, // Change the background color to white
            dataSource: BookingDataSource(appointments),
            todayTextStyle: const TextStyle(
              // color: Colors.black, // Set the text color for today
              fontWeight: FontWeight.bold,
              // fontSize: width*.05
            ),
            todayHighlightColor: const Color(0XFFd71e23),

            selectionDecoration: BoxDecoration(

              border: Border.all(color: Colors.red, width: 2), // Outline the selected date
              shape: BoxShape.rectangle, // You can also use BoxShape.circle for circular selection
            ),
            headerStyle:CalendarHeaderStyle(
              backgroundColor: const Color(0XFFd71e23), // Change header background color
              textStyle: TextStyle(
                color: Colors.white, // Header text color
                fontSize: width *.06,
              ),
            ),
            viewHeaderStyle:  ViewHeaderStyle(
              backgroundColor: Colors.grey, // Change the view header background
              dayTextStyle: TextStyle(
                color: Colors.white, // Day text color
                fontSize: width*.04,
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





