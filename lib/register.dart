import 'package:WorldOfMusic/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'student_profile.dart';
import 'nav_drawer.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var instrument = TextEditingController();
  var course = TextEditingController();
  var goal = TextEditingController();
  var otp = TextEditingController();
  var pageC = PageController();
  var sessionId = '';
  var enquiry_id = '';
  var queue_no = '';
  var enquiry_msg = '';

  sendOTP() async {
    // var otpResponse  = await http.get("https://2factor.in/API/V1/c08ea13b-61dd-11ea-9fa5-0200cd936042/SMS/9606637773/AUTOGEN");
    var otpResponse = await http.get(
        "https://2factor.in/API/V1/c08ea13b-61dd-11ea-9fa5-0200cd936042/SMS/${phone.text}/AUTOGEN");
    var otpResponseBody = jsonDecode(otpResponse.body);
    sessionId = otpResponseBody['Details'];

    if (otpResponseBody == "Success") {
      setState(() {
        pageC.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      });
    }
  }

  verifyOTP() async {
    var verifyResponse = await http.get(
        "https://2factor.in/API/V1/c08ea13b-61dd-11ea-9fa5-0200cd936042/SMS/VERIFY/$sessionId/${otp.text}");
    var verifyResponseBody = jsonDecode(verifyResponse.body);
    if (verifyResponseBody['Status'] == "Success") {
      FocusScope.of(context).unfocus();
      var response =
          await http.post("https://www.abworldmusic.in/API_new_enquiry", body: {
        "name": name.text,
        "phone": phone.text,
        "email": email.text,
        "instrument": instrument.text,
        "course": course.text,
        "goal": goal.text
      });
      print(response.body);
      var enquiryResponse = jsonDecode(response.body);
      if (enquiryResponse["message"] == 'success') {
        if (enquiryResponse["type"] == 'new') {
          setState(() {
            enquiry_id = "WOMSTU" + enquiryResponse["id"].toString();
            queue_no = enquiryResponse["queue_no"].toString();
            enquiry_msg = "Your enquiry has been recorded successfully";
            pageC.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        } else if (enquiryResponse["type"] == 'old') {
          setState(() {
            enquiry_id = "WOMSTU" + enquiryResponse["id"].toString();
            queue_no = enquiryResponse["queue_no"].toString();
            enquiry_msg = "Here is the status of your enquiry";
            pageC.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        } else if (enquiryResponse["type"] == 'closed') {
          setState(() {
            enquiry_id = "WOMSTU" + enquiryResponse["id"].toString();
            queue_no = enquiryResponse["queue_no"].toString();
            enquiry_msg =
                "Your enquiry is already attended to. Please contact us for any more queries";
            pageC.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff330033),
          automaticallyImplyLeading: true,
        ),
        body: PageView(
          controller: pageC,
          // physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.only(top: 15),
                    child: Text("Help us get to know you better",
                        style: TextStyle(fontSize: 18))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: TextStyle(fontSize: 18),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff330033), width: 2.0))),
                      style: TextStyle(fontSize: 18),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                          hintText: "Phone",
                          hintStyle: TextStyle(fontSize: 18),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff330033), width: 2.0))),
                      style: TextStyle(fontSize: 18),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(fontSize: 18),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff330033), width: 2.0))),
                      style: TextStyle(fontSize: 18),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text("Instrument"),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            instrument.text = "Guitar";
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: instrument.text == "Guitar"
                                  ? Colors.black
                                  : Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text("Guitar",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: instrument.text == "Guitar"
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            instrument.text = "Keyboard";
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: instrument.text == "Keyboard"
                                  ? Colors.black
                                  : Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text("Keyboard",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: instrument.text == "Keyboard"
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            instrument.text = "Drums";
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: instrument.text == "Drums"
                                  ? Colors.black
                                  : Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text("Drums",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: instrument.text == "Drums"
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text("Course"),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            course.text = "Beginner";
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: course.text == "Beginner"
                                  ? Colors.black
                                  : Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text("Beginner",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: course.text == "Beginner"
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            course.text = "intermediate";
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: course.text == "intermediate"
                                  ? Colors.black
                                  : Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text("intermediate",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: course.text == "intermediate"
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            course.text = "Advanced";
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: course.text == "Advanced"
                                  ? Colors.black
                                  : Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text("Advanced",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: course.text == "Advanced"
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: TextFormField(
                    controller: goal,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: "Goal",
                        hintStyle: TextStyle(fontSize: 18),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff330033), width: 2.0))),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (name.text.trim() == "") {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text("Name cannot be empty"),
                          ));
                    } else if (phone.text.trim() == "") {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text("Phone cannot be empty"),
                          ));
                    } else if (email.text.trim() == "") {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text("Email cannot be empty"),
                          ));
                    } else if (instrument.text.trim() == "") {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content:
                                Text("Please select atleast one instrument"),
                          ));
                    } else if (course.text.trim() == "") {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text("Please select atleast one course"),
                          ));
                    } else {
                      pageC.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease);
                      sendOTP();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Color(0xff330033),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            ListView(children: <Widget>[
              Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                      "Please enter the verification code / OTP sent to your phone",
                      style: TextStyle(fontSize: 18))),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextFormField(
                  controller: otp,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                      hintText: "OTP",
                      hintStyle: TextStyle(fontSize: 18),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xff330033), width: 2.0))),
                  style: TextStyle(fontSize: 18),
                ),
              ),
              InkWell(
                onTap: () async {
                  verifyOTP();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Color(0xff330033),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ]),
            ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.only(top: 35),
                    child: Text(enquiry_msg, style: TextStyle(fontSize: 18))),
                Container(
                  alignment: Alignment.center,
                  child: Icon(Icons.check_circle_outline,
                      size: 100, color: Colors.green[800]),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.only(top: 35),
                    child: Text("Your enquiry ID is",
                        style: TextStyle(fontSize: 18))),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(5),
                    child: Text(enquiry_id.toString(),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600))),
                Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.only(top: 15),
                    child: Text("You are ${queue_no} on the waiting list",
                        style: TextStyle(fontSize: 18))),
                Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.all(15),
                    child: Text(
                        "Our correspondent will get in touch with you shortly",
                        style: TextStyle(fontSize: 14))),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/Login');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Color(0xff330033),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Return to Home",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
