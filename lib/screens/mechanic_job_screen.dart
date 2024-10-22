

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/calendar_controller.dart';
import '../controllers/job_controller.dart';
import '../widgets/custom_drawer.dart';





class MechanicCalendarScreen extends ConsumerStatefulWidget {
  final String mechanicUid;

  MechanicCalendarScreen({required this.mechanicUid});

  @override
  _MechanicCalendarScreenState createState() => _MechanicCalendarScreenState();
}

class _MechanicCalendarScreenState extends ConsumerState<MechanicCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final viewController = ref.watch(calendarControllerProvider.notifier); // Access the controller for state changes
    final viewState = ref.watch(calendarControllerProvider); // Listen to state changes for rebuilding the UI

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(

        title: Text('Mechanic Calendar'),
        // actions: [
        //   // Dropdown to select the Calendar view (Day, Week, Month)
        //   DropdownButton<CalendarView>(
        //     value: viewState, // Bind the dropdown value to the current state
        //     icon: Icon(Icons.filter_list),
        //     onChanged: (CalendarView? newView) {
        //       if (newView != null) {
        //         viewController.changeCalenderView(newView); // Update state when a new view is selected
        //       }
        //     },
        //     items: const [
        //       DropdownMenuItem(
        //         value: CalendarView.day,
        //         child: Text('Day View'),
        //       ),
        //       DropdownMenuItem(
        //         value: CalendarView.week,
        //         child: Text('Week View'),
        //       ),
        //       DropdownMenuItem(
        //         value: CalendarView.month,
        //         child: Text('Month View'),
        //       ),
        //     ],
        //   ),
        // ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getMechanicBookings(widget.mechanicUid), // Fetch mechanic bookings from Firestore
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




