import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/job_controller.dart';

class AdminCalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Calendar'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAdminBookings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }



          final appointments = getBookingsFromSnapshot(snapshot.data!);


          return SfCalendar(
            // key: ValueKey(v),
            onTap: (CalendarTapDetails details) {
              if (details.appointments != null && details.appointments!.isNotEmpty) {
                final Appointment appointment = details.appointments![0];

                // Split the notes to extract additional information
                final List<String> notes = appointment.notes!.split('\n');
                final phone = notes[0].split(': ')[1]; // Extract phone
                final email = notes[1].split(': ')[1]; // Extract email
                final customerName = notes[3].split(': ')[1];

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(appointment.subject),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Customer Name: $customerName'),
                          Text('Phone: $phone'),
                          Text('Email: $email'),
                          Text('Car: ${notes[2]}'), // Car make and model
                          Text('Booking Start: ${appointment.startTime}'),
                          Text('Booking End: ${appointment.endTime}'),
                        ],
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
            view: CalendarView.month,
            // dataSource: BookingDataSource(appointments),
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
            // monthViewSettings: MonthViewSettings(
            //   appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            //   // showAgenda: true,
            // ),
          );
        },
      ),
    );
  }
}
