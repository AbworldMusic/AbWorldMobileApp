import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'student_home.dart';
import 'student_profile.dart';
import 'community.dart';
import 'add_new_post.dart';
import 'metronome.dart';
import 'faculty_home.dart';
import 'reset_password.dart';
import 'fee_reciepts.dart';
import 'studio_sessions.dart';
import 'register.dart';
import 'attendance.dart';
import 'lesson_groups.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "JosefinSans",
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/Login': (BuildContext context) => HomePage(),
        '/StudentHome': (BuildContext context) => StudentHomeScreen(),
        '/StudentProfile': (BuildContext context) => StudentProfileScreen(),
        '/Community': (BuildContext context) => CommunityScreen(),
        '/AddNewPost': (BuildContext context) => AddNewPostScreen(),
        '/Metronome': (BuildContext context) => Metronome(),
        '/FacultyHome': (BuildContext context) => FacultyHomeScreen(),
        '/ResetPassword': (BuildContext context) => ResetPassword(),
        '/FeeReciepts': (BuildContext context) => FeeReciept(),
        '/Studio': (BuildContext context) => StudentStudioScreen(),
        '/Register': (BuildContext context) => RegisterScreen(),
        '/Attendance': (BuildContext context) => AttendanceScreen(),
        '/LessonGroups': (BuildContext context) => LessonGroupsScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var studentId = new TextEditingController();
  var password = new TextEditingController();
  var otpStatus = "";
  var showPassword = false;
  var pwIcon = Icons.visibility_off;

  _set_preferences(Map data, role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (role == "Student") {
      prefs.setString("id", data["id"].toString());
      prefs.setString("name", data["name"]);
      prefs.setString("age", data["age"]);
      prefs.setString("instrument", data["instrument"]);
      prefs.setString("course", data["course"]);
      prefs.setString("role", 'Student');
    } else if (role == "Guest") {
      prefs.setString("id", data["id"].toString());
      prefs.setString("name", data["name"]);
      prefs.setString("role", data['role']);
      prefs.setString("enquiry_for", data['enquiry_for']);
    } else {
      prefs.setString("id", data["id"].toString());
      prefs.setString("name", data["name"]);
      prefs.setString("role", data['role']);
    }
  }

  check_if_logged_in() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("id").trim() != "") {
      print(prefs.getString("role"));
      if (prefs.getString("role").trim() == "Student") {
        Navigator.pushReplacementNamed(context, "/StudentHome");
      } else {
        Navigator.pushReplacementNamed(context, "/FacultyHome");
      }
    }
  }

  @override
  void initState() {
    check_if_logged_in();
    super.initState();
  }

  void _login() async {
    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.parse(s, (e) => null) != null;
    }

    showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
              height: 80,
              child: SpinKitRing(
                color: Colors.blue,
                lineWidth: 3,
              )),
        ));
    if (studentId.text.trim() == "") {
      Navigator.pop(context);
      showDialog(
          context: context,
          child: AlertDialog(
            content: Text("Student ID cannot be empty"),
          ));
    } else if (password.text.trim() == "") {
      Navigator.pop(context);
      showDialog(
          context: context,
          child: AlertDialog(
            content: Text("Password cannot be empty"),
          ));
    } else {
      var response = await http.post(
          "https://www.abworldmusic.in/api/API_login",
          body: {"id": studentId.text, 'password': password.text});
      print(response.body);
      var loginResponse = jsonDecode(response.body);

      if (loginResponse['message'] == "success" &&
          loginResponse['role'] == "Student") {
        await _set_preferences(loginResponse, 'Student');
        Navigator.pop(context);
        Navigator.pushNamed(context, '/StudentHome');
      } else if (loginResponse['message'] == "success" &&
          loginResponse['role'] == "Guest") {
        await _set_preferences(loginResponse, 'Guest');
        Navigator.pop(context);
        Navigator.pushNamed(context, '/StudentHome');
      } else if (loginResponse['message'] == "success") {
        await _set_preferences(loginResponse, 'Staff');
        Navigator.pop(context);
        Navigator.pushNamed(context, '/FacultyHome');
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            child: AlertDialog(
              content: Text("Incorrect Student ID or password",
                  style: TextStyle(color: Colors.red[700])),
            ));
      }
    }
  }

  void otp_verify() async {
    var firebaseAuth = await FirebaseAuth.instance;

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      setState(() {
        otpStatus = "\nEnter the code sent to your device";
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      setState(() {
        otpStatus = "\nOTP timed out! Please request for another OTP";
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        otpStatus = '${authException.message}';
        print(otpStatus);

        if (authException.message.contains('not authorized'))
          otpStatus = 'Something has gone wrong, please try later';
        else if (authException.message.contains('connection'))
          otpStatus = 'Please check your internet connection and try again';
        else
          otpStatus = 'Something has gone wrong, please try later';
      });
    };

    firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+919945613932",
        timeout: Duration(seconds: 120),
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.grey[300],
            Colors.white,
            Colors.white,
            Colors.grey[300]
          ])),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 30),
              height: 100,
              width: 100,
              child: Image.asset("assets/Logo.png")),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: TextFormField(
                controller: studentId,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    hintText: "Enter phone number",
                    hintStyle: TextStyle(fontSize: 18),
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff330033), width: 2.0))),
                style: TextStyle(fontSize: 18),
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: password,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  hintStyle: TextStyle(fontSize: 18),
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff330033), width: 2.0)),
                  suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          if (showPassword == false) {
                            showPassword = true;
                            pwIcon = Icons.visibility;
                          } else {
                            showPassword = false;
                            pwIcon = Icons.visibility_off;
                          }
                        });
                      },
                      child: Icon(pwIcon, color: Color(0xff330033))),
                ),
                style: TextStyle(fontSize: 18),
              )),
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/ResetPassword');
              },
              child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Forgot password?"))),
          InkWell(
            onTap: () {
              _login();
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
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
              child: Text("Don't have an account?")),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/Register');
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              margin: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff330033), width: 2.0),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                "REGISTER",
                style: TextStyle(fontSize: 18, color: Color(0xff330033)),
              ),
            ),
          ),
        ],
      )),
    ));
  }
}
