class Booking {
  final String carMake;
  final String carModel;
  final String carYear;
  final String carPlate;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String bookingTitle;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String mechanicName;
  final String mechanicUid;

  Booking({
    required this.carMake,
    required this.carModel,
    required this.carYear,
    required this.carPlate,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.bookingTitle,
    required this.startDateTime,
    required this.endDateTime,
    required this.mechanicName,
    required this.mechanicUid,
  });

  // // Convert Booking object to a Map for Firestore
  // Map<String, dynamic> toMap() {
  //   return {
  //     'carMake': carMake,
  //     'carModel': carModel,
  //     'carYear': carYear,
  //     'carPlate': carPlate,
  //     'customerName': customerName,
  //     'customerPhone': customerPhone,
  //     'customerEmail': customerEmail,
  //     'bookingTitle': bookingTitle,
  //     'startDateTime': startDateTime.toIso8601String(),
  //     'endDateTime': endDateTime.toIso8601String(),
  //     'mechanicName': mechanicName,
  //     'mechanicUid': mechanicUid,
  //   };
  // }

  // Create a Booking object from a Firestore Map
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      carMake: map['carMake'],
      carModel: map['carModel'],
      carYear: map['carYear'],
      carPlate: map['carPlate'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      customerEmail: map['customerEmail'],
      bookingTitle: map['bookingTitle'],
      startDateTime: DateTime.parse(map['startDateTime']),
      endDateTime: DateTime.parse(map['endDateTime']),
      mechanicName: map['mechanicName'],
      mechanicUid: map['mechanicUid'],
    );
  }
}
