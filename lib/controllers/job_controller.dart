

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


//Fetching for mechanics
Stream<QuerySnapshot<Map<String, dynamic>>> getMechanicBookings(String mechanicUid) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .doc(mechanicUid)
      .collection('jobs')
      .snapshots();
}

//Fetching for admins
Stream<QuerySnapshot<Map<String, dynamic>>> getAdminBookings() {
  return FirebaseFirestore.instance
      .collectionGroup('jobs')
      .snapshots(); // Fetches all jobs across all mechanics
}


List<Appointment> getBookingsFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      startTime: DateTime.parse(data['startDateTime']),
      endTime: DateTime.parse(data['endDateTime']),
      subject: data['bookingTitle'] ?? 'No Title',
      notes: '${data['carMake']} ${data['carModel']}',
    );
  }).toList();
}


class BookingDataSource extends CalendarDataSource {
  BookingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

