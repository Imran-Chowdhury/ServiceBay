import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../controllers/booking_controller.dart';

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
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
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
    final mechanicsList = ref.watch(mechanicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Car Details
              TextFormField(
                controller: _carMakeController,
                decoration: InputDecoration(labelText: 'Car Make'),
                validator: (value) => value!.isEmpty ? 'Enter car make' : null,
              ),
              TextFormField(
                controller: _carModelController,
                decoration: InputDecoration(labelText: 'Car Model'),
                validator: (value) => value!.isEmpty ? 'Enter car model' : null,
              ),
              TextFormField(
                controller: _carYearController,
                decoration: InputDecoration(labelText: 'Car Year'),
                validator: (value) => value!.isEmpty ? 'Enter car year' : null,
              ),
              TextFormField(
                controller: _carPlateController,
                decoration: InputDecoration(labelText: 'Registration Plate'),
                validator: (value) => value!.isEmpty ? 'Enter registration plate' : null,
              ),

              SizedBox(height: 16.0),

              // Customer Details
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) => value!.isEmpty ? 'Enter customer name' : null,
              ),
              TextFormField(
                controller: _customerPhoneController,
                decoration: InputDecoration(labelText: 'Customer Phone'),
                validator: (value) => value!.isEmpty ? 'Enter customer phone' : null,
              ),
              TextFormField(
                controller: _customerEmailController,
                decoration: InputDecoration(labelText: 'Customer Email'),
                validator: (value) => value!.isEmpty ? 'Enter customer email' : null,
              ),

              SizedBox(height: 16.0),

              // Booking Title and Datetime
              TextFormField(
                controller: _bookingTitleController,
                decoration: InputDecoration(labelText: 'Booking Title'),
                validator: (value) => value!.isEmpty ? 'Enter booking title' : null,
              ),
              TextFormField(
                controller: _startDateTimeController,
                decoration: InputDecoration(labelText: 'Start Date & Time'),
                readOnly: true,
                onTap: () => _pickDateTime(context, _startDateTimeController),
                validator: (value) => value!.isEmpty ? 'Select start date and time' : null,
              ),
              TextFormField(
                controller: _endDateTimeController,
                decoration: InputDecoration(labelText: 'End Date & Time'),
                readOnly: true,
                onTap: () => _pickDateTime(context, _endDateTimeController),
                validator: (value) => value!.isEmpty ? 'Select end date and time' : null,
              ),

              SizedBox(height: 16.0),

              // Mechanic Dropdown
              mechanicsList.when(
                data: (mechanics) {
                  return DropdownButtonFormField<String>(
                    value: _selectedMechanic,
                    hint: Text('Select Mechanic'),
                    items: mechanics.map((mechanic) {
                      return DropdownMenuItem(
                        value: mechanic['name'],
                        child: Text(mechanic['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMechanic = value;
                      });
                    },
                    validator: (value) => value == null ? 'Select a mechanic' : null,
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (err, stack) => Text('Error fetching mechanics'),
              ),

              SizedBox(height: 16.0),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
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
                      mechanicName: _selectedMechanic!,
                    );
                  }
                },
                child: Text('Create Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
