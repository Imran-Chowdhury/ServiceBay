

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_bay/controllers/calendar_controller.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/job_controller.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// // CalendarController to manage calendar view state
// final calendarControllerProvider = StateNotifierProvider<CalendarController, CalendarView>((ref) {
//   return CalendarController();
// });
//
// class CalendarController extends StateNotifier<CalendarView> {
//   CalendarController() : super(CalendarView.month);
//
//   // Method to change the calendar view
//   void changeCalendarView(CalendarView view) {
//     state = view; // Updates the calendar view state
//   }
// }

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
      appBar: AppBar(
        title: Text('Mechanic Calendar'),
        actions: [
          // Dropdown to select the Calendar view (Day, Week, Month)
          DropdownButton<CalendarView>(
            value: viewState, // Bind the dropdown value to the current state
            icon: Icon(Icons.filter_list),
            onChanged: (CalendarView? newView) {
              if (newView != null) {
                viewController.changeCalenderView(newView); // Update state when a new view is selected
              }
            },
            items: const [
              DropdownMenuItem(
                value: CalendarView.day,
                child: Text('Day View'),
              ),
              DropdownMenuItem(
                value: CalendarView.week,
                child: Text('Week View'),
              ),
              DropdownMenuItem(
                value: CalendarView.month,
                child: Text('Month View'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getMechanicBookings(widget.mechanicUid), // Fetch mechanic bookings from Firestore
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final appointments = getBookingsFromSnapshot(snapshot.data!);

          return SfCalendar(
            view: viewState, // Bind the calendar view to the current state
            onTap: (CalendarTapDetails details) {
              if (details.appointments != null && details.appointments!.isNotEmpty) {
                final Appointment appointment = details.appointments![0];

                // Split the notes to extract additional information
                final List<String> notes = appointment.notes!.split('\n');
                final phone = notes[0].split(': ')[1]; // Extract phone
                final email = notes[1].split(': ')[1]; // Extract email

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(appointment.subject),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Customer Name: ${appointment.location}'),
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





// class MechanicCalendarScreen extends ConsumerStatefulWidget {
//   final String mechanicUid; // Pass mechanic UID
//
//   MechanicCalendarScreen({required this.mechanicUid});
//
//   @override
//   _MechanicCalendarScreenState createState() => _MechanicCalendarScreenState();
// }
//
// class _MechanicCalendarScreenState extends ConsumerState<MechanicCalendarScreen> {
//   // Set the initial calendar view to Month
//   CalendarView _calendarView = CalendarView.month;
//
//
//   @override
//   Widget build(BuildContext context) {
//     final viewController = ref.watch(calendarControllerProvider.notifier);
//     final viewState = ref.watch(calendarControllerProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mechanic Calendar'),
//         actions: [
//           // Dropdown to select the Calendar view (Day, Week, Month)
//           DropdownButton<CalendarView>(
//             value: viewState,
//             // value: _calendarView,
//             icon: Icon(Icons.filter_list),
//             onChanged: (CalendarView? newView) {
//               if (newView != null) {
//                 viewController.changeCalenderView(newView);
//                 // setState(() {
//                 //
//                 //   _calendarView = newView;
//                 // });
//               }
//             },
//             items: const [
//               DropdownMenuItem(
//                 value: CalendarView.day,
//                 child: Text('Day View'),
//               ),
//               DropdownMenuItem(
//                 value: CalendarView.week,
//                 child: Text('Week View'),
//               ),
//               DropdownMenuItem(
//                 value: CalendarView.month,
//                 child: Text('Month View'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: getMechanicBookings(widget.mechanicUid),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final appointments = getBookingsFromSnapshot(snapshot.data!);
//
//           return SfCalendar(
//             view: viewState,
//             // view: _calendarView,
//             // Dynamically set the view
//             onTap: (CalendarTapDetails details) {
//               if (details.appointments != null &&
//                   details.appointments!.isNotEmpty) {
//                 final Appointment appointment = details.appointments![0];
//
//                 // Split the notes to extract additional information
//                 final List<String> notes = appointment.notes!.split('\n');
//                 final phone = notes[0].split(': ')[1]; // Extract phone
//                 final email = notes[1].split(': ')[1]; // Extract email
//
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text(appointment.subject),
//                       content: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('Customer Name: ${appointment.location}'),
//                           Text('Phone: $phone'),
//                           Text('Email: $email'),
//                           Text('Car: ${notes[2]}'), // Car make and model
//                           Text('Booking Start: ${appointment.startTime}'),
//                           Text('Booking End: ${appointment.endTime}'),
//                         ],
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text('Close'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               }
//             },
//             backgroundColor: Colors.white,
//             // Change the background color to white
//             dataSource: BookingDataSource(appointments),
//             headerStyle: const CalendarHeaderStyle(
//               backgroundColor: Colors.red, // Change header background color
//               textStyle: TextStyle(
//                 color: Colors.white, // Header text color
//                 fontSize: 20,
//               ),
//             ),
//             viewHeaderStyle: const ViewHeaderStyle(
//               backgroundColor: Colors.blue, // Change the view header background
//               dayTextStyle: TextStyle(
//                 color: Colors.white, // Day text color
//                 fontSize: 16,
//               ),
//             ),
//
//             monthViewSettings: const MonthViewSettings(
//               appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
//               agendaStyle: AgendaStyle(
//                 backgroundColor: Colors.white, // Agenda background color
//                 appointmentTextStyle: TextStyle(
//                   color: Colors.black, // Appointment text color
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

