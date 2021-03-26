import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'nav_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeeReciept extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FeeRecieptState();
}

class FeeRecieptState extends State<FeeReciept>{
  
  var data = [];

  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id =prefs.getString("id");
    var response = await http.post("https://abworldmusic.in/API_fees",
          body: {
            "id": id.toString(),            
          }
        );
    var respBody = jsonDecode(response.body);
    setState(() {
      data = respBody;
    });
  }

  @override
  void initState() {    
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff330033),
      ),
      drawer: NavDrawer(),
    body: 
    ListView(
      padding: EdgeInsets.only(left: 15, right: 15),
      children: <Widget>[
        Container(margin: EdgeInsets.only(top: 20),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            
            Container(
              padding: EdgeInsets.all(15),
              child: Text("Paid for", style: TextStyle(fontSize: 18)),             
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text("Paid on", style: TextStyle(fontSize: 18)),          
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text("Amount", style: TextStyle(fontSize: 18)),          
            )
            
          ],
        ),
        Container(
          height: 1.0,
          decoration: BoxDecoration(            
            border: Border(
              bottom: BorderSide()
            )
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: new BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: data.length,
          itemBuilder: (BuildContext ctxt, int Index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[400])
                )
              ),
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: (MediaQuery.of(context).size.width-60)/3,
                    child: Text(data[Index]['name'], style: TextStyle(fontSize: 16),),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: (MediaQuery.of(context).size.width-60)/3,
                    child: Text(data[Index]['date'], style: TextStyle(fontSize: 16),),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: (MediaQuery.of(context).size.width-60)/3,
                    child: Text(data[Index]['price'], style: TextStyle(fontSize: 16),),
                  ),
                                  
                ],
              ),
            );
          }
        ),
        
      ],
    ),);
  }
}