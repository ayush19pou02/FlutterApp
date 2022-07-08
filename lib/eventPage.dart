import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/homepage.dart';
import 'package:login_page/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'SignInScreen.dart';
import 'auth.dart';
import 'taskPage.dart';

import 'database.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,

        // on appbar text containing 'GEEKS FOR GEEKS'
        title: Text("Tasks"),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            //Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                                  return HomePage();
                                }), ModalRoute.withName('/'));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(
                            top: 16.0,
                            bottom: 16.0,
                          ),
                          child: Image(
                            image: AssetImage('assets/logo.png'),
                          ),
                        ),
                      ]
                    ),
                  ),

                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context,AsyncSnapshot snapshot) {
                        if(snapshot.data.length==0)
                          {
                            return Container(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(MdiIcons.emoticonHappy, size: 120.0,color: Colors.amberAccent),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(24.0,10.0,16.0,280.0),
                                      child: Text('All done',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold
                                        ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Taskpage(
                                        task: snapshot.data[index],
                                      ),
                                    ),
                                  ).then(
                                        (value) {
                                      setState(() {});
                                    },
                                  );
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Taskpage(
                            task: null,
                          )),
                    ).then((value) {
                      setState(() {});
                    });
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
            ],
          ),
        ),
      ),
    );
  }
}

