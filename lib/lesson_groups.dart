import 'package:WorldOfMusic/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'student_profile.dart';
import 'nav_drawer.dart';

class LessonGroupsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LessonGroupsScreenState();
}

class LessonGroupsScreenState extends State<LessonGroupsScreen> {
  var data = [];
  var role;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    role = prefs.getString("role");
    var insturment = prefs.getString("instrument");
    var responseObject = await http.get(
        "https://www.abworldmusic.in/API_get_all_levels?id=$id&instrument=$insturment");
    setState(() {
      data = jsonDecode(responseObject.body);
      data = data[0]["levels"];
    });

  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff330033),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/StudentProfile');
              },
              child: Container(
                  margin: EdgeInsets.only(right: 20, bottom: 5),
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.person_outline, color: Colors.white)),
            )
          ],
        ),
        drawer: NavDrawer(),
        body: ListView(children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(bottom: 10, top: 10),
            child: Text(
              "Lesson groups",
              style: TextStyle(
                fontSize: 22,
                color: Color(0xff330033),
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext ctxt, int Index) {
                return Stack(alignment: Alignment.center, children: <Widget>[
                  Opacity(
                      opacity: 1.0,
                      child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    data[Index]["name"],
                                    style: TextStyle(fontSize: 18),
                                  )),
                                  Container(child: Icon(Icons.chevron_right))
                                ],
                              ),
                              
                            ],
                          ))),
                  Icon(Icons.lock, color: Colors.black, size: 30)
                ]);
              })
        ]));
  }
}
