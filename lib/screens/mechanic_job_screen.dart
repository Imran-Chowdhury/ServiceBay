

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/job_controller.dart';

class MechanicCalendarScreen extends StatelessWidget {
  final String mechanicUid; // Pass mechanic UID

  MechanicCalendarScreen({required this.mechanicUid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getMechanicBookings(mechanicUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = getBookingsFromSnapshot(snapshot.data!);

        return SfCalendar(
          view: CalendarView.month,
          dataSource: BookingDataSource(appointments),
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: true,
          ),
        );
      },
    );
  }
}
