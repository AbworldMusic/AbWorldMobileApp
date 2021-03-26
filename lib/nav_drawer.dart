import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child:ListView(
          children: <Widget>[
            Container(
              height: 150,
              color: Color(0xff330033),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/StudentHome");
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,

                  ),] 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.home),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Dashboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                    ),                    
                  ],
                )
              )
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/Community");
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,

                  ),] 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.people),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Community", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                    ),                    
                  ],
                )
              )
            ),

            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/Attendance");
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,

                  ),] 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.present_to_all),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Attendance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                    ),                    
                  ],
                )
              )
            ),

            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/LessonGroups");
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,

                  ),] 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.present_to_all),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Lesson groups", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                    ),                    
                  ],
                )
              )
            ),

            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/Studio");
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,

                  ),] 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.beach_access),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Studio Sessions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                    ),                    
                  ],
                )
              )
            ),
            
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/FeeReciepts");
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,

                  ),] 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.attach_money),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Fee reciepts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                    ),                    
                  ],
                )
              )
            ),
            
            InkWell(
              onTap: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushReplacementNamed(context, "/Login");
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,

                  ),] 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.people),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Log out", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                    ),                    
                  ],
                )
              )
            ),
            
          ],
        ),
      );
  }
  
}