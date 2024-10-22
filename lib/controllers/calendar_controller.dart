

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final calendarControllerProvider = StateNotifierProvider<CalendarController, CalendarView>((ref) {
  return CalendarController();
});

class CalendarController extends StateNotifier<CalendarView>{
  // CalendarController(this.calendarView) : super(CalendarView.month);
  CalendarController() : super(CalendarView.month);
  // CalendarView calendarView;


  void changeCalenderView(CalendarView view){
    state = view;
  }

// void changeViewToMonth(){
//   state = CalendarView.month;
// }



// void changeViewToWeek(){
//   state = CalendarView.week;
// }

}