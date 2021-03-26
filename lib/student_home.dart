import 'package:WorldOfMusic/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'student_profile.dart';
import 'nav_drawer.dart';


class StudentHomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => StudentHomeScreenState();
}

class StudentHomeScreenState extends State<StudentHomeScreen>{
  
  var id;
  var name ="";
  var age;
  var role = "";
  var enquiry_for = "";
  var instrument;
  var course;
  var isNextClassLoaded = false;
  var courseSize = {
    "Hobby": 2,
    "intermediate": 3,
    "Advanced": 4,
  };
  var slots=[];
  var lesson  = {};

  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("id");
      name = prefs.getString("name").split(" ")[0];
      role = prefs.getString("role");
      if(role=="Student"){
        age = prefs.getString("age");
        instrument = prefs.getString("instrument");
        course = prefs.getString("course");
        getClassDetails(prefs.getString("id"));
        getLessonDetails(prefs.getString("id"));
      
      } else{
        enquiry_for = prefs.getString("enquiry_for");
      }
    });
    
  }
  getClassDetails(var id) async {
    print("https://www.abworldmusic.in/API_get_class_details?id=$id");
    var classResponseObject = await http.get("https://www.abworldmusic.in/API_get_class_details?id=$id");
    setState(() {
      slots = jsonDecode(classResponseObject.body)['slots'];
    });
  }

  getLessonDetails(var id) async {
    print("https://www.abworldmusic.in/API_current_lesson?id=$id");
    var lessonResponseObject = await http.get("https://www.abworldmusic.in/API_current_lesson?id=$id");
    setState(() {
      lesson = jsonDecode(lessonResponseObject.body);
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
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text("Hi $name!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          if(role=="Guest")
          Container(
            margin: EdgeInsets.only(right: 5, bottom: 20),
           
            
            width: (MediaQuery.of(context).size.width-45)/2,
            child: Text("Thanks for showing interest in us", style: TextStyle(fontSize: 16, color: Colors.grey[700]))
          ),

          
          Container(
            margin: EdgeInsets.only(bottom: 7),
            decoration: BoxDecoration(
              color: Color(0xffffe6f0),
              border: Border.all(color: Colors.grey[300])
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width-40)/2,
                  child: Text(role=="Student" ? "Student ID:" : "Enquiry ID:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                ),
                Text("WOM$id", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ],
            )
          ),
          if(role=="Guest")
          Container(
            margin: EdgeInsets.only(right: 5),
           
            padding: EdgeInsets.symmetric(vertical: 15),
            width: (MediaQuery.of(context).size.width-45)/2,
            child: Text("Enquiry for", style: TextStyle(fontSize: 14, color: Colors.grey[700]))
          ),
          if(role=="Guest")
          Container(
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: Color(0xffccf5ff)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: (MediaQuery.of(context).size.width-45)/2,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(Icons.mail, color: Color(0xff330033),),
                ),
                Text("$enquiry_for", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              ],
            )
          ),
          if(role=="Student")
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: Color(0xffccf5ff)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: (MediaQuery.of(context).size.width-45)/2,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Icon(Icons.accessibility_new, color: Color(0xff330033),),
                      ),
                      Text("$instrument", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    ],
                  )
                ),
                Container(
                  
                  decoration: BoxDecoration(
                    color: Color(0xffe0ccff)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  width: (MediaQuery.of(context).size.width-50)/2,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Icon(Icons.star_border, color: Color(0xff330033),),
                      ),
                      Text("$course", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    ],
                  )
                ),
              ],
            ),
          ),
         
          if(role=="Student")
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 15),
            child: Text("Class times", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          if(slots.isEmpty && role=="Student")
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.centerLeft,
            child: SpinKitRipple(color: Color(0xff330033), size: 16,),
          ),        
          if(role=="Student")  
          Container(
            margin: EdgeInsets.only(right: 10),
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              addRepaintBoundaries: true,
              shrinkWrap: true,
              children: <Widget>[
                for (int i=0;i<slots.length; i++)
                  Container(                      
                    width: MediaQuery.of(context).size.width /2 - 40,
                    // height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xffe6e6ff),
                      // border: Border.all(color: Color(0xffedb3ff)),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(slots[i].toString().split("day")[1], style: TextStyle(color: Colors.black, fontSize: 12)),
                        Text(slots[i].toString().split("day")[0]+"day", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300)),
                        
                      ],
                    )
                  )
              ]
            )
          ),

          if(lesson.isEmpty && role=="Student")
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.centerLeft,
            child: SpinKitRipple(color: Color(0xff330033), size: 16,),
          ),

          if(!lesson.isEmpty && role=="Student")
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 5, top: 30),
                child:  Text("Lesson card", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
              ),
              Container(
                width: MediaQuery.of(context).size.width- 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF6FCBE)
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Text("Current lesson: "+lesson['title'], style: TextStyle(fontSize: 18)),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text("Level "+lesson['level'].toString(), style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(lesson['description'].toString().trim(), style: TextStyle(fontWeight: FontWeight.w700)),
                    )
                  ],
                ),
              ),
            ],
          ),
          
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 25),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(),
              )
            ),
            child:  Text("Leaderboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child:  Text("Arriving soon!", style: TextStyle(fontSize: 14, color: Colors.grey))
          ),
          
          
        ]
      )
    );
  }

}