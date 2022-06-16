import 'package:intl/intl.dart';

class TimeAgo{
  static String dayCalculate(int time){
    DateTime date=DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat("EEEE").format(date);
  }

  static String dateAgo(int time){
    DateTime date=DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat().add_jm().format(date);
  }
  static String timeAgoSinceDateNow(int time){
        DateTime date=DateTime.fromMillisecondsSinceEpoch(time);
        final date2=DateTime.now();
        final diff=date2.difference(date);

        if(diff.inDays > 8){
          return DateFormat("dd-MM-yyyy HH:mm:ss").format(date);

        }else if((diff.inDays / 7).floor() >= 1)
          return 'Last Week';
        else if(diff.inDays >= 2)
          return '${diff.inDays} days ago';
        else if(diff.inDays >=1)
          return '1 day ago';
        else if(diff.inHours >= 2)
          return '${diff.inHours} hours ago';
        else if(diff.inHours >= 1)
          return '1 hour ago';
        else if(diff.inMinutes >= 2)
          return '${diff.inMinutes} minutes ago';
        else if(diff.inMinutes >= 1)
          return '1 minute ago';
        else if(diff.inSeconds >=8)
          return '${diff.inSeconds} seconds ago';
        else
          return 'Just now';

    }
}