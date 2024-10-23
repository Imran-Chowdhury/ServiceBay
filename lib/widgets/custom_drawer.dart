

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/calendar_controller.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final viewController = ref.read(calendarControllerProvider.notifier); // Get the calendar controller

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.calendar_view_day_sharp),
            title: Text('Day'),
            onTap: () {
              viewController.changeCalenderView(CalendarView.day); // Change to Day view
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_week_sharp),
            title: Text('Week'),
            onTap: () {
              viewController.changeCalenderView(CalendarView.week); // Change to Week view
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month_sharp),
            title: Text('Month'),
            onTap: () {
              viewController.changeCalenderView(CalendarView.month); // Change to Month view
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
