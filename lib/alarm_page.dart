import 'package:login_page/homepage.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import './alarm_helper.dart';
import 'theme_data.dart';
import './alarm_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'main.dart';
AlarmHelper _alarmHelper = AlarmHelper();
class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  String? _alarmTimeString;
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
                              ],
                            ),
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
                           Container(
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString =
                                    DateFormat('HH:mm').format(DateTime.now());
                                showModalBottomSheet<dynamic>(
                                  context: context,
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


  void onSaveAlarm() async{
    DateTime scheduleAlarmDateTime;
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));
      var h = scheduleAlarmDateTime.hour;
      var m = scheduleAlarmDateTime.minute;
    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: 'alarm',

    );
    _alarmHelper.insertAlarm(alarmInfo);
    FlutterAlarmClock.createAlarm(h,m);
    Navigator.pop(context);

    loadAlarms();
  }
}
