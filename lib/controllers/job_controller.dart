

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:service_bay/models/booking_model.dart';
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
    // Extract all the relevant booking fields from Firestore document

    DateTime startDateTime = DateTime.parse(data['startDateTime']);
    String formattedStartDateTime = DateFormat('yyyy-MM-dd h:mm').format(startDateTime);

    // DateTime endDateTime = DateTime.parse(data['startDateTime']);
    // String formattedEndDateTime = DateFormat('yyyy-MM-dd h:mm').format(endDateTime);


    Booking booking = Booking(carMake: data['carMake'], carModel: data['carModel'], carYear: data['carYear'],
        carPlate: data['carPlate'], customerName: data['customerName'],
        customerPhone: data['customerPhone'], customerEmail: data['customerEmail'],
        bookingTitle: data['bookingTitle'], startDateTime: data['startDateTime'],
        endDateTime:data['endDateTime'], mechanicName: data['mechanicName'],
        mechanicUid: data['mechanicUid']);

    // final carMake = data['carMake'] ?? 'Unknown Make';
    // final carModel = data['carModel'] ?? 'Unknown Model';
    // final customerName = data['customerName'] ?? 'Unknown Customer';
    // final customerPhone = data['customerPhone'] ?? 'Unknown Phone';
    // final customerEmail = data['customerEmail'] ?? 'Unknown Email';
    // final bookingTitle = data['bookingTitle'] ?? 'No Title';


    // Store additional information in notes field or use a custom data model
    // final notes = 'Phone: $customerPhone\nEmail: $customerEmail\nCar: $carMake $carModel\nCustomerName: $customerName ';
    final notes = '''
                Phone: ${booking.customerPhone}
                Email: ${booking.customerEmail}
                Car Make: ${booking.carMake} 
                Car Model:${booking.carModel} 
                Car Year: ${booking.carYear}
                License Plate: ${booking.carPlate}
                Name: ${booking.customerName}
                Booking Title: ${booking.bookingTitle}
                Mechanic Name: ${booking.mechanicName}
                Mechanic Id: ${booking.mechanicUid}
                ''';

    // Start Time: ${booking.startDateTime.toString()}
    // End Time: ${booking.endDateTime.toString()}
    return Appointment(
      startTime: DateTime.parse(data['startDateTime']),
      endTime: DateTime.parse(data['endDateTime']),
      subject: booking.bookingTitle,
      // subject: bookingTitle,
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

