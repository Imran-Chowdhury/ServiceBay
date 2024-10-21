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
    required String mechanicName,
  }) async {
    try {
      state = true; // Set loading state

      // Firestore reference
      CollectionReference bookings = FirebaseFirestore.instance.collection('bookings');

      // Add booking to Firestore
      await bookings.add({
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
      });

      state = false; // Set loading state back to false
    } catch (e) {
      state = false;
      print('Error creating booking: $e');
    }
  }
}
