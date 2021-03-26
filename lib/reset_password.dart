import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  var phone = new TextEditingController();
  var email = new TextEditingController();
  var id =new TextEditingController();
  var role = new TextEditingController();
  var password = new TextEditingController();
  var cPassword = new TextEditingController();
  var pageC = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff330033),
        ),
        body: PageView(
          controller: pageC,
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                          hintText: "Enter phone number",
                          hintStyle: TextStyle(fontSize: 18),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff330033), width: 2.0))),
                      style: TextStyle(fontSize: 18),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          hintText: "Enter email id",
                          hintStyle: TextStyle(fontSize: 18),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff330033), width: 2.0))),
                      style: TextStyle(fontSize: 18),
                    )),
                InkWell(
                  onTap: () async {
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
                    if (phone.text.trim() == '' || email.text.trim() == '') {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text("Please fill all fields"),
                          ));
                    } else {
                      var response = await http.post(
                          "https://www.abworldmusic.in/API_forgot_password",
                          body: {
                            "phone": phone.text,
                            "email": email.text.toString()
                          });
                      var forgotResponse = jsonDecode(response.body);
                      if (forgotResponse['message'] == 'success') {
                        setState(() {
                          role.text = forgotResponse['found_in'];
                          id.text = forgotResponse['id'].toString();
                          Navigator.pop(context);
                          pageC.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.ease);
                        });
                      }
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
            ListView(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Enter password",
                          hintStyle: TextStyle(fontSize: 18),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff330033), width: 2.0))),
                      style: TextStyle(fontSize: 18),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: TextFormField(
                      controller: cPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Confirm password",
                          hintStyle: TextStyle(fontSize: 18),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff330033), width: 2.0))),
                      style: TextStyle(fontSize: 18),
                    )),
                InkWell(
                  onTap: () async {
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
                    if (password.text.trim() == '' || cPassword.text.trim() == '') {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text("Please fill all fields"),
                          ));
                    } else if (password.text != cPassword.text) {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text("Passwords do not match"),
                          ));
                    } else {
                      var response = await http.post(
                          "https://www.abworldmusic.in/API_reset_password",
                          body: {
                            "role": role.text,
                            "password": password.text,
                            "id": id.text
                          });
                      var forgotResponse = jsonDecode(response.body);
                      if (forgotResponse['message'] == 'success') {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/Login');
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text("Password reset successfully"),
                          ));
                      } else{
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/Login');
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text("Snap! Something went wrong"),
                          ));
                      }
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
                      "SUBMIT",
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
