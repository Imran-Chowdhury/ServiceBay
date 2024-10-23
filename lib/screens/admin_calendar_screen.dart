import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_bay/widgets/custom_drawer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/calendar_controller.dart';
import '../controllers/job_controller.dart';
class AdminCalendarScreen extends ConsumerStatefulWidget {
  const AdminCalendarScreen({Key? key}) : super(key: key);

  @override
  _AdminCalendarScreenState createState() => _AdminCalendarScreenState();
}

class _AdminCalendarScreenState extends ConsumerState<AdminCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(calendarControllerProvider); // Listen to state changes for rebuilding the UI

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Admin Calendar'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAdminBookings(), // Replace this with the actual Firestore stream fetching
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final appointments = getBookingsFromSnapshot(snapshot.data!); // Process snapshot data

          return SfCalendar(
            key: ValueKey(viewState),
            view: viewState, // Calendar view is dynamically updated based on state
            onTap: (CalendarTapDetails details) {
              if (details.appointments != null && details.appointments!.isNotEmpty) {
                final Appointment appointment = details.appointments![0];

                // Extract additional information from appointment notes
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
            backgroundColor: Colors.white,
            dataSource: BookingDataSource(appointments),
            headerStyle: const CalendarHeaderStyle(
              backgroundColor: Colors.red,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            viewHeaderStyle: const ViewHeaderStyle(
              backgroundColor: Colors.blue,
              dayTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              agendaStyle: AgendaStyle(
                backgroundColor: Colors.white,
                appointmentTextStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
