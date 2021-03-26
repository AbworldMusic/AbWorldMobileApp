import 'package:WorldOfMusic/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'student_profile.dart';
import 'nav_drawer.dart';


class AttendanceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AttendanceScreenState();
}

class AttendanceScreenState extends State<AttendanceScreen>{
  
  var data = [];
  var role;
  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    role = prefs.getString("role");
    var responseObject = await http.get("https://www.abworldmusic.in/API_get_attendance?id=$id");
    setState(() {
      data = jsonDecode(responseObject.body);
    });
    print(data);    
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
            onTap: (){
              Navigator.pushNamed(context, '/StudentProfile');
            },
            child: Container(
              margin:  EdgeInsets.only(right: 20, bottom: 5),
              padding:  EdgeInsets.all(10),              
              child: Icon(Icons.person_outline, color: Colors.white)
            )
          ,)
        ],
      ),

      drawer: NavDrawer(),
      body: ListView(
      children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(bottom: 10, top: 10),
            child: Text("Here is all the times you've been with us", style: TextStyle(fontSize: 22, color: Color(0xff330033),),),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom :5),
                      child: Text("Marked ${data[Index]['status']}", style: TextStyle(fontSize: 16))
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom :15),
                      child: Text("On ${data[Index]['date_and_day'].split(" ")[0]} at ${data[Index]['date_and_day'].split(" ")[1]}")
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom :5),
                      child: Text("By faculty ${data[Index]['faculty']}")
                    ),
                    if(data[Index]['status']=="Absent")
                    Container(
                      margin: EdgeInsets.only(bottom :5),
                      child: Text("Reason for absence ${data[Index]['reason']}")
                    ),
                  ],
                )
              );
            })
        ]
      )
    );
  }

}