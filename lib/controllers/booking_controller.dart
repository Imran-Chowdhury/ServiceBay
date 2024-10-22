import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final bookingControllerProvider = StateNotifierProvider<BookingController, bool>((ref) {
  return BookingController();
});

class BookingController extends StateNotifier<bool> {
  BookingController() : super(false);

  Future<void> createBooking({
    required String carMake,
    required String carModel,
    required String carYear,
    required String carPlate,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String bookingTitle,
    required String startDateTime,
    required String endDateTime,
    // required String mechanicName,
    required String mechanicUid
  }) async {
    try {
      String mechanicName = '';
      state = true; // Set loading state
      final FirebaseFirestore fireStore = FirebaseFirestore.instance;

      DocumentSnapshot mechaDoc = await FirebaseFirestore.instance.collection('mechanic')
          .doc(mechanicUid)
          .get();
      if (mechaDoc.exists) {
        // Get additional user info like name and role
        mechanicName = mechaDoc['name'];
      }

      DocumentReference<Map<String, dynamic>> bookingsRef = fireStore
          .collection('bookings')       // Main collection
          .doc(mechanicUid)               // Mechanic UID document
          .collection('jobs').doc(bookingTitle);        // Subcollection 'bookings'

      // Add a new booking document to the 'bookings' subcollection
      await bookingsRef.set({
        'carMake': carMake,
        'carModel': carModel,
        'carYear': carYear,
        'carPlate': carPlate,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerEmail': customerEmail,
        'bookingTitle': bookingTitle,
        'startDateTime': startDateTime,
        'endDateTime': endDateTime,
        'mechanicName': mechanicName,
        'mechanicUid': mechanicUid,
        // 'createdAt': FieldValue.serverTimestamp(),  // Timestamp for when the booking was created
      });



      state = false; // Set loading state back to false
    } catch (e) {
      state = false;
      print('Error creating booking: $e');
    }
  }
}