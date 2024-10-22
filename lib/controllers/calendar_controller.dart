

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final calendarControllerProvider = StateNotifierProvider<CalendarController, CalendarView>((ref) {
  return CalendarController(CalendarView.month);
});

class CalendarController extends StateNotifier<CalendarView>{
  CalendarController(super.state);


  // CalendarController() : super(CalendarView.month);



  void changeCalenderView(CalendarView view){
    state = view;
    if(state==CalendarView.month){
      print('Month Selected');
    }else if(state==CalendarView.day){
      print('Day Selected');
    }else{
      print('Week Selected');
    }
  }

// void changeViewToMonth(){
//   state = CalendarView.month;
// }



// void changeViewToWeek(){
//   state = CalendarView.week;
// }

}