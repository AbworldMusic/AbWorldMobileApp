import 'package:WorldOfMusic/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'nav_drawer.dart';
import 'package:intl/intl.dart';
import 'class_sheet.dart';


class FacultyHomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FacultyHomeScreenState();
}

class FacultyHomeScreenState extends State<FacultyHomeScreen>{
  
  var id;
  var name = '';
  var role = '';
  var date = '';
  var day = '';
  var month = '';
  var sessionId= '';
  var status = 'Not at center';
  var inCenter = false;
  var slots = [];
  var slot_ids = [];
  var otp = new TextEditingController();

  sendOTP() async{
    // var otpResponse  = await http.get("https://2factor.in/API/V1/c08ea13b-61dd-11ea-9fa5-0200cd936042/SMS/9606637773/AUTOGEN");
    var otpResponse  = await http.get("https://2factor.in/API/V1/c08ea13b-61dd-11ea-9fa5-0200cd936042/SMS/9945613932/AUTOGEN");
    var otpResponseBody = jsonDecode(otpResponse.body);
    sessionId = otpResponseBody['Details'];
        
    if(otpResponseBody=="Success"){
      setState(() {                
        status = "At center";
      });
    }
    setState(() {
      otp.text = "";
      status="Confirm OTP";
    });
  }

  verifyOTP() async{
    var verifyResponse  = await http.get("https://2factor.in/API/V1/c08ea13b-61dd-11ea-9fa5-0200cd936042/SMS/VERIFY/$sessionId/${otp.text}");    
    var verifyResponseBody = jsonDecode(verifyResponse.body);
    if(verifyResponseBody['Status']=="Success"){
      if(inCenter){
        var confirm = await http.post("https://abworldmusic.in/API_confirm_arrival",
          body: {
            "user_id": id.toString(),
            "type": "Logout"
          }
        );
        if(jsonDecode(confirm.body)['message']=='confirmed'){
          setState(() {
            inCenter = false;
            status = "Not at center";            
          });
        } 
      } else{
        var confirm = await http.post("https://abworldmusic.in/API_confirm_arrival",
          body: {
            "user_id": id.toString(),
            "type": "Arrival"
          }
        );
        if(jsonDecode(confirm.body)['message']=='confirmed'){
          setState(() {
            inCenter = true;
            status = "At center";
          });
        } 
      }
           
    }
  }

  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Init");
    setState(() {
      id = prefs.getString("id");
      name = prefs.getString("name").split(" ")[0];
      role =  prefs.getString('role');
      var dateObj = new DateTime.now();
      date = DateFormat('dd').format(dateObj);
      day = DateFormat('EEEE').format(dateObj);
      month = DateFormat('LLLL').format(dateObj);
    });

    var statusresp =  await http.get("https://abworldmusic.in/API_facultyStatus?id=$id");
    var statusJson = jsonDecode(statusresp.body);
    print(statusJson['status']);
    setState(() {
      status = statusJson["status"][0] == "Arrival" ? "At center" : "Not at center";
      inCenter = statusJson["status"][0] == "Arrival" ? true : false;
      
    });
    print(status);
    var slotsResponse = await http.post("https://abworldmusic.in/API_get_slots_for_faculty",
      body: {
        "user_id": id.toString(),
        "day": day
      }
    );
    
    setState(() {
      if(slotsResponse.body!="No slots today"){
        var slotsBody = jsonDecode(slotsResponse.body);
        var slotObj = slotsBody['slots'];
        for(var i in slotObj.keys){
          slot_ids.add(i);
          slots.add(slotObj[i]);
        }
      }            
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
        actions: <Widget>[
          InkWell(
            onTap: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushNamed(context, '/Login');
            },
            child: Container(
              margin:  EdgeInsets.only(right: 20, bottom: 5),
              padding:  EdgeInsets.all(10),
             
              child: Icon(Icons.exit_to_app, color: Colors.white)
            ),
        ),],
        backgroundColor: Color(0xff330033),
        automaticallyImplyLeading: false,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[100], Colors.grey[300]]
          ),
        ),
        child: ListView(
        padding: EdgeInsets.all(15),
        
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: 40),child: Text("Welcome $name!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),),
          
          
          Container(
            width: 150,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),              
            ),
            child: Row(

              children: <Widget>[
                Icon(Icons.person_outline,),
                Container(
                  margin: EdgeInsets.only(top: 1, left: 6),
                  child: Text(role, style: TextStyle(fontSize: 16),)
                )
              ],
            )
          ),


          Container(
            width: MediaQuery.of(context).size.width - 30,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              boxShadow: [BoxShadow(
                color: Colors.grey[300],
                offset: Offset(0.0, 5.0),
                blurRadius: 5
              )],
              borderRadius: BorderRadius.circular(10)
            ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(date, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(month.toString()),
                      Text(day.toString()),
                    ],
                  )
                ],
              ),
            )            
          ),

          Container(
            margin: EdgeInsets.only(bottom: 5, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text("Current Status:", style: TextStyle(fontSize: 14)),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 5),
                      child: Icon(Icons.location_on, size: 22, color: Colors.black),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 13, right: 10),
                      child: Text(status, style: TextStyle(fontSize: 18))
                    )
                  ],
                )
              ],
            ),
          ),

          if(status=='Not at center')
          InkWell(
            onTap: (){
              sendOTP();
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 5, top: 25),
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text("Confirm Arrival", style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ))
            )
          ),

          
          if(status=='Confirm OTP')
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5, top: 25),
                    child: Text("Enter confirmation OTP", style: TextStyle(fontSize: 12),)
                  ),
                  Container( 
                    width: MediaQuery.of(context).size.width*0.5,               
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(5)
                      ),
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      style: TextStyle(
                        fontSize: 20
                      ),
                      controller: otp,
                    )
                  ),      
                ],
              ),
              InkWell(
                onTap: (){
                  verifyOTP();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5,top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13), 
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2)
                  ),
                  child: Text("Verify", style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ))
                ),
              )            
            ],
          ),    

          if(status=="At center")      
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(Icons.check_box, color: Colors.green),
                  ),
                  Text("Arrival confirmed", style: TextStyle(color: Colors.green[700], fontSize: 16, fontWeight: FontWeight.w600),)
                ],
              ),
              InkWell(
                onTap: () async{
                  var confirm = await showDialog(
                    context: context, 
                    child: AlertDialog(
                      content: Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text("Are you sure you want to logout ?", style: TextStyle(fontSize: 18))
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context, "No");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 16))
                                  )
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context, "Yes");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text("YES", style: TextStyle(color: Colors.black, fontSize: 16))
                                  )
                                ),
                              ],
                            )

                          ],
                        )
                      ),
                    )
                  );
                  print(confirm);
                  if(confirm=="Yes"){
                    sendOTP();
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 5, top: 25),
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.white,                    
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text("LOG OUT", style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                  ))
                )
              ),

            ]
            
          ),
          
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 25),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(),
              )
            ),
            child: Row(
              children: <Widget>[
                 Text("Your classes today", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                 Container(
                   margin: EdgeInsets.only(left: 10),
                   child: Icon(Icons.access_time),
                 )
              ],
            )
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                for(int i=0; i<slots.length; i++)
                  InkWell(
                    onTap: () async{
                       if(status=="Not at center"){
                          var confirm = await showDialog(
                          context: context, 
                          child: AlertDialog(
                            content: Container(
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Text("Visit the center to see more details about this class", style: TextStyle(fontSize: 18))
                                  ),
                                ],
                              )
                            ),
                          )
                        );
                        
                       } else{
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ClassSheet(slot_ids[i], slots[i])),
                        );
                       }
                       
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(3)
                      ),
                      child: Text(slots[i].toString(), style: TextStyle(fontSize: 16)),
                    )
                  ),                  
              ],
            )
          ),
          

        ],
      ),
      ) 
      
      );
  }

}