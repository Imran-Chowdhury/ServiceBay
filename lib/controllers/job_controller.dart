

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
  print(FirebaseFirestore.instance
      .collectionGroup('jobs')
      .get());
  return FirebaseFirestore.instance
      .collectionGroup('jobs')
      .snapshots(); // Fetches all jobs across all mechanics
}


List<Appointment> getBookingsFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Extract all the relevant booking fields from Firestore document
    final carMake = data['carMake'] ?? 'Unknown Make';
    final carModel = data['carModel'] ?? 'Unknown Model';
    final customerName = data['customerName'] ?? 'Unknown Customer';
    final customerPhone = data['customerPhone'] ?? 'Unknown Phone';
    final customerEmail = data['customerEmail'] ?? 'Unknown Email';
    final bookingTitle = data['bookingTitle'] ?? 'No Title';


    // Store additional information in notes field or use a custom data model
    final notes = 'Phone: $customerPhone\nEmail: $customerEmail\nCar: $carMake $carModel';

    return Appointment(
      startTime: DateTime.parse(data['startDateTime']),
      endTime: DateTime.parse(data['endDateTime']),
      subject: data['bookingTitle'] ?? 'No Title',
      // notes: '${data['carMake']} ${data['carModel']}',
      notes: notes,
    );
  }).toList();
}


class BookingDataSource extends CalendarDataSource {
  BookingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

