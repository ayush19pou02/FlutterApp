import 'package:login_page/homepage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import './alarm_helper.dart';
import 'theme_data.dart';
// import './data.dart';
import './alarm_info.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'main.dart';
AlarmHelper _alarmHelper = AlarmHelper();
var _id=_alarmHelper.getCount();
class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  String? _alarmTimeString;
  //int id=0;
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }), ModalRoute.withName('/'));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0 , 10.0 , 24.0 ,10.0),
                  child: Image(
                    image: AssetImage(
                        'assets/back_arrow_icon.png'),
                  ),
                ),
              ),
              Text(
                'Reminders',
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: CustomColors.dividerColor,
                    fontSize: 24),
              ),
           ]
          ),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data!;
                  //print(_currentAlarms);
                  return ListView(
                    children: snapshot.data!.map<Widget>((alarm) {
                      var alarmTime =
                          DateFormat('hh:mm aa').format(alarm.alarmDateTime);
                      var gradientColor = GradientTemplate
                          .gradientTemplate[alarm.gradientColorIndex].colors;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColor,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradientColor.last.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(4, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.label,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      alarm.title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'avenir'),
                                    ),
                                  ],
                                ),
                                // Switch(
                                //   onChanged: (bool value) {},
                                //   value: true,
                                //   activeColor: Colors.white,
                                // ),
                              ],
                            ),
                            // Text(
                            //   'Mon-Fri',
                            //   style: TextStyle(
                            //       color: Colors.white, fontFamily: 'avenir'),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  alarmTime,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'avenir',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.white,
                                    onPressed: () async{
                                      if(alarm.id!=null) {
                                        await _alarmHelper.delete(alarm.id!);
                                        loadAlarms();
                                      }

                                    }),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).followedBy([
                      if (_currentAlarms!.length < 5)

                          // strokeWidth: 2,
                          // color: CustomColors.clockOutline,
                          // borderType: BorderType.RRect,
                          // radius: Radius.circular(24),
                          // dashPattern: [5, 4],
                           Container(
                            // width: double.infinity,
                            // decoration: BoxDecoration(
                            //   color: CustomColors.clockBG,
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(24)),
                            // ),
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString =
                                    DateFormat('HH:mm').format(DateTime.now());
                                showModalBottomSheet<dynamic>(
                                  // useRootNavigator: true,
                                  context: context,
                                  // clipBehavior: Clip.antiAlias,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.vertical(
                                  //     top: Radius.circular(24),
                                  //   ),
                                  // ),
                                  builder: (BuildContext bc) {
                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Container(
                                          height: MediaQuery.of(context).size.height * 0.20,
                                          color: Colors.blueGrey,
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            children: [
                                              FlatButton(
                                                onPressed: () async {
                                                  var selectedTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                                  if (selectedTime != null) {
                                                    final now = DateTime.now();
                                                    var selectedDateTime =
                                                        DateTime(
                                                            now.year,
                                                            now.month,
                                                            now.day,
                                                            selectedTime.hour,
                                                            selectedTime
                                                                .minute);
                                                    _alarmTime =
                                                        selectedDateTime;
                                                    setModalState(() {
                                                      _alarmTimeString =
                                                          DateFormat('HH:mm')
                                                              .format(
                                                                  selectedDateTime);
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  _alarmTimeString!,
                                                  style:
                                                      TextStyle(fontSize: 32),
                                                ),
                                              ),
                                              // ListTile(
                                              //   title: Text('Repeat'),
                                              //   trailing: Icon(
                                              //       Icons.arrow_forward_ios),
                                              // ),
                                              // ListTile(
                                              //   title: Text('Sound'),
                                              //   trailing: Icon(
                                              //       Icons.arrow_forward_ios),
                                              // ),
                                              // ListTile(
                                              //   title: Text('Title'),
                                              //   trailing: Icon(
                                              //       Icons.arrow_forward_ios),
                                              // ),
                                              FloatingActionButton.extended(
                                                onPressed: onSaveAlarm,
                                                icon: Icon(Icons.alarm),
                                                label: Text('Save'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                                // scheduleAlarm();
                              },
                              child: Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                                      begin: Alignment(0.0, -1.0),
                                      end: Alignment(0.0, 1.0)),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Image(
                                  image: AssetImage(
                                    "assets/add_icon.png",
                                  ),
                                ),
                              ),
                            ),
                          )

                      else
                        Center(
                            child: Text(
                          'Only 5 alarms allowed!',
                          style: TextStyle(
                              color: Colors.red,
                            fontWeight: FontWeight.bold
                          ),
                        )),
                    ]).toList(),
                  );
                }
                return Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  // Future<int> getCount() async {
  //   //database connection
  //   var db = await this.database;
  //   var x = await db.rawQuery('SELECT COUNT (*) from
  //       $tableAlarm');
  //       int count = Sqflite.firstIntValue(x);
  //   return count;
  // }


  void scheduleAlarm(
      DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notify',
      'Channel for Alarm notification',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(0, 'Office', alarmInfo.title,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }

  void onSaveAlarm() async{
    DateTime scheduleAlarmDateTime;
    // if (_alarmTime!.isAfter(DateTime.now()))
    //   scheduleAlarmDateTime = _alarmTime!;
    // else
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));
      var h = scheduleAlarmDateTime.hour;
      var m = scheduleAlarmDateTime.minute;
    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: 'alarm',

    );

    // _id=await _id+1 as Future<int>;
    _alarmHelper.insertAlarm(alarmInfo);
    scheduleAlarm(scheduleAlarmDateTime, alarmInfo);
    FlutterAlarmClock.createAlarm(h,m);
    Navigator.pop(context);

    loadAlarms();
  }

  // void deleteAlarm(int id) async{
  //
  //     await _alarmHelper.delete(id);
  //   //unsubscribe for notification
  //   loadAlarms();
  // }
}
