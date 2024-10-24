import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../controllers/booking_controller.dart';

import '../utils/booking_validator.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _carMakeController = TextEditingController();
  final _carModelController = TextEditingController();
  final _carYearController = TextEditingController();
  final _carPlateController = TextEditingController();

  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerEmailController = TextEditingController();

  final _bookingTitleController = TextEditingController();
  final _startDateTimeController = TextEditingController();
  final _endDateTimeController = TextEditingController();

   String? _selectedMechanic; // Mechanic dropdown value

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _carMakeController.dispose();
    _carModelController.dispose();
    _carYearController.dispose();
    _carPlateController.dispose();

    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();

    _bookingTitleController.dispose();
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();

    super.dispose();
  }

  Future<void> _pickDateTime(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {

      // setState(() {
      //   controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      // });
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime fullDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    // final mechanicsList = ref.watch(mechanicsProvider);
    final bookingState = ref.watch(bookingControllerProvider);
    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width  = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f0),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor:  Color(0XFFd71e23),
        // title: Text('Create Booking'),
      ),
      body: bookingState?
          const Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                height: height*.3,
                width: double.infinity,

                decoration: BoxDecoration(
                    color: Color(0XFFd71e23),
                    borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(width*.09), bottomRight: Radius.circular(width*.09))
                )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [



                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Image.asset(
                //     'assets/images/booking.png', // Your image path
                //     height: height * 0.3,
                //   ),
                // ),
                SizedBox(height: height * 0.06),
                Text(
                  ' Booking Form',
                  style: TextStyle(
                    fontSize: width *.099,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: height * 0.03),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Car Details
                        CustomTextField(
                          controller: _bookingTitleController,
                          labelText: 'Booking Title',
                          validate: BookingValidator.Validator,
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: _carMakeController,
                          labelText: 'Car Make',
                          validate: BookingValidator.Validator,
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: _carModelController,
                          labelText: 'Car Model',
                          validate: BookingValidator.Validator,
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: _carYearController,
                          labelText: 'Car Year',
                          validate: BookingValidator.Validator,
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: _carPlateController,
                          labelText: 'Registration Plate',
                          validate: BookingValidator.Validator,
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: _customerNameController,
                          labelText: 'Customer Name',
                          validate: BookingValidator.Validator,
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: _customerPhoneController,
                          labelText: 'Customer Phone',
                          validate: BookingValidator.Validator,
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: _customerEmailController,
                          labelText: 'Customer Email',
                          validate: BookingValidator.Validator,
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: _startDateTimeController,
                          labelText: 'Start Date & Time',
                          readOnly: true,
                          onTap: () => _pickDateTime(context, _startDateTimeController),
                          validate: BookingValidator.Validator,
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: _endDateTimeController,
                          labelText: 'End Date & Time',
                          readOnly: true,
                          onTap: () => _pickDateTime(context, _endDateTimeController),
                          validate: BookingValidator.Validator,
                        ),

                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('mechanic').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            // if (snapshot.connectionState == ConnectionState.waiting) {
                            //   return const CircularProgressIndicator(); // Show loading indicator
                            // }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Text('No mechanics available');
                            }

                            // Map snapshot data to dropdown items
                            List<DropdownMenuItem<String>> mechanicsItems = snapshot.data!.docs.map((doc) {
                              return DropdownMenuItem<String>(
                                value: doc.id, // Assign the mechanic's UID
                                child: Text(doc['name'] as String), // Show mechanic's name
                              );
                            }).toList();

                            return DropdownButtonFormField<String>(
                              value: _selectedMechanic,
                              hint: const Text('Select Mechanic'),
                              items: mechanicsItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedMechanic = value;
                                });
                              },
                              validator: (value) => value == null ? 'Select a mechanic' : null,
                            );
                          },
                        ),


                        SizedBox(height: height * 0.02),
                        CustomButton(
                          screenHeight: height,
                          buttonName: 'Book',
                          // buttonColor: const Color(0xFFffc801),
                          buttonColor: const Color(0xFFed2f31),
                          icon: const Icon(
                            Icons.bookmark_add_outlined,
                            color: Colors.white,
                          ),
                          onpressed: () {
                            if (_formKey.currentState!.validate()) {
                              // print(_selectedMechanic!);
                              // Call booking function
                              ref.read(bookingControllerProvider.notifier).createBooking(
                                  carMake: _carMakeController.text,
                                  carModel: _carModelController.text,
                                  carYear: _carYearController.text,
                                  carPlate: _carPlateController.text,
                                  customerName: _customerNameController.text,
                                  customerPhone: _customerPhoneController.text,
                                  customerEmail: _customerEmailController.text,
                                  bookingTitle: _bookingTitleController.text,
                                  startDateTime: _startDateTimeController.text,
                                  endDateTime: _endDateTimeController.text,
                                  mechanicUid: _selectedMechanic!,
                                  context: context// Mechanic UID
                              );
                            }

                          },


                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
