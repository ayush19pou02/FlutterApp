import './enums.dart';
import './alarm_info.dart';
import './menu_info.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.alarm,
      title: 'Reminders', imageSource: 'assets/alarm_icon.png'),
  MenuInfo(MenuType.clock,
      title: 'Clock', imageSource: 'assets/clock_icon.png'),
];
// List<AlarmInfo> alarms = [
//   AlarmInfo(
//       alarmDateTime: DateTime.now().add(Duration(hours: 1)),
//       title: 'Office',
//       gradientColorIndex: 0, id: 0),
//   AlarmInfo(
//       alarmDateTime: DateTime.now().add(Duration(hours: 0)),
//       title: 'Sport',
//       gradientColorIndex: 1, id: 1),
// ];
