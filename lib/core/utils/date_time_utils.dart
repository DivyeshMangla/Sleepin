import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  static String formatDays(List<int> days) {
    if (days.isEmpty) return 'Once';
    if (days.length == 7) return 'Everyday';
    
    final isWeekdays = days.length == 5 && 
        days.contains(1) && days.contains(2) && days.contains(3) && 
        days.contains(4) && days.contains(5);
        
    if (isWeekdays) return 'Weekdays';
    
    final isWeekend = days.length == 2 && days.contains(6) && days.contains(7);
    if (isWeekend) return 'Weekends';

    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    days.sort();
    return days.map((d) => weekDays[d - 1]).join(', ');
  }
}
