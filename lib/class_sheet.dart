import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

var class_data = {};

class AttendanceBtn extends StatefulWidget {
  var status;
  var student_id;
  var faculty_id;
  var slot_id;
  AttendanceBtn(this.status, this.student_id, this.faculty_id, this.slot_id);
  @override
  State<AttendanceBtn> createState() => AttendanceBtnState(
      this.status, this.student_id, this.faculty_id, this.slot_id);
}

class AttendanceBtnState extends State<AttendanceBtn> {
  var status;
  var student_id;
  var faculty_id;
  var slot_id;

  AttendanceBtnState(
      this.status, this.student_id, this.faculty_id, this.slot_id);

  @override
  Widget build(BuildContext context) {
    if (status == "Absent")
      return InkWell(
          onTap: () async {
            setState(() {
              this.status = "Present";
              class_data[this.student_id][1] = "Present";
            });
          },
          child: Row(
            children: <Widget>[
              Container(
                  width: 45,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.red[900],
                      border: Border.all(color: Colors.red[900])),
                  child: Text(
                    "A",
                    style: TextStyle(color: Colors.white),
                  )),
              Container(
                  width: 45,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.green[800])),
                  child: Text(
                    "P",
                    style: TextStyle(color: Colors.green[800]),
                  )),
            ],
          ));
    if (status == "Present")
      return InkWell(
          onTap: () async {
            setState(() {
              this.status = "Absent";
              class_data[this.student_id][1] = "Absent";
            });
          },
          child: Row(
            children: <Widget>[
              Container(
                  width: 45,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red[900])),
                  child: Text(
                    "A",
                    style: TextStyle(color: Colors.red[900]),
                  )),
              Container(
                  width: 45,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green[800],
                      border: Border.all(color: Colors.green[800])),
                  child: Text(
                    "P",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ));
  }
}

class PromoteBtn extends StatefulWidget {
  var status;
  var student_id;

  PromoteBtn(this.status, this.student_id);
  @override
  State<PromoteBtn> createState() =>
      PromoteBtnState(this.status, this.student_id);
}

class PromoteBtnState extends State<PromoteBtn> {
  var status;
  var student_id;

  PromoteBtnState(this.status, this.student_id);

  @override
  Widget build(BuildContext context) {
    if (status == "Same lesson")
      return InkWell(
          onTap: () async {
            setState(() {
              this.status = "Promoted";
              class_data[this.student_id][2] = "Promote";
            });
          },
          child: Row(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.red[900],
                      border: Border.all(color: Colors.red[900], width: 2.0)),
                  child: Text(
                    "Practice",
                    style: TextStyle(color: Colors.white),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.green[800], width: 2.0)),
                  child: Text(
                    "Promote",
                    style: TextStyle(color: Colors.green[800]),
                  )),
            ],
          ));
    if (status == "Promoted")
      return InkWell(
          onTap: () async {
            setState(() {
              this.status = "Same lesson";
              class_data[this.student_id][2] = "Practice";
            });
          },
          child: Row(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red[900], width: 2.0)),
                  child: Text(
                    "Practice",
                    style: TextStyle(color: Colors.red[900]),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green[800],
                      border: Border.all(color: Colors.green[800], width: 2.0)),
                  child: Text(
                    "Promote",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ));
  }
}

class ClassSheet extends StatefulWidget {
  var class_id;
  var class_name;
  ClassSheet(this.class_id, this.class_name);

  @override
  State<StatefulWidget> createState() =>
      ClassSheetState(this.class_id, this.class_name);
}

class ClassSheetState extends State<ClassSheet> {
  var id;
  var class_id;
  var class_name;
  var students = {};
  var class_completed = false;
  var pController = new PageController();
  ClassSheetState(this.class_id, this.class_name);

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("id");
    });
    class_data = {};
    if (class_data.isEmpty) {
      print(class_id);
      var studentsResponse = await http.get(
          "https://abworldmusic.in/API_get_student_list?class_id=" +
              class_id.toString());
      setState(() {
        class_completed = jsonDecode(studentsResponse.body)['class_completed'];
        students = jsonDecode(studentsResponse.body)['students'];
        for (var i in students.keys) {
          class_data[i] = [
            students[i][0],
            students[i][1],
            "Practice",
            TextEditingController(),
            students[i][2]
          ];
        }
      });
    }
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
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pController,
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  padding: EdgeInsets.only(bottom: 5),
                  decoration:
                      BoxDecoration(border: Border(bottom: BorderSide())),
                  child: Text(
                    "Class: " + this.class_name.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     Container(
                //       width: 180,
                //       margin: EdgeInsets.only(right: 10, bottom: 10),
                //       padding: EdgeInsets.all(10),
                //       alignment: Alignment.center,
                //       decoration: BoxDecoration(
                //         color: Colors.red[900],
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Text("Request Cancellation", style: TextStyle(color: Colors.white))
                //     ),
                //   ],
                // ),
                for (var i in class_data.keys)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(class_data[i][0].toString(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            if (!class_completed)
                              AttendanceBtn(class_data[i][1], i.toString(),
                                  id.toString(), this.class_id),
                            if (class_completed)
                              Container(
                                  child: Text(class_data[i][1],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: class_data[i][1] == "Present"
                                              ? Colors.green[800]
                                              : Colors.red[800])))
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        if (class_completed && class_data[i][1] == "Absent" )
                          Container(
                              child: Text(
                                  "Reason for absence: ${class_data[i][4].trim() != "" ? class_data[i][4]: 'Enrolled after class time'}")),
                        if (!class_completed)
                          PromoteBtn(
                              class_data[i][2] == "Practice"
                                  ? "Same lesson"
                                  : "Promoted",
                              i),
                      ],
                    ),
                  ),
                if (!class_completed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            pController.nextPage(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                            setState(() {});
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: 130,
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey[300],
                                      spreadRadius: 5.0,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text("Preview",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white))))
                    ],
                  )
              ],
            ),
            ListView(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black))),
                    child: Text(
                      "Present",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                for (var i in class_data.keys)
                  if (class_data[i][1] == "Present")
                    Container(
                        padding: EdgeInsets.all(15),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(class_data[i][0].toString(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                if (class_data[i][2] == "Practice")
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        color: Colors.yellow[700],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                if (class_data[i][2] == "Promote")
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        color: Colors.green[700],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                Text(class_data[i][2].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black))),
                    child: Text(
                      "Absent",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                for (var i in class_data.keys)
                  if (class_data[i][1] == "Absent")
                    Container(
                        padding: EdgeInsets.all(15),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(class_data[i][0].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    if (class_data[i][2] == "Practice")
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[700],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    if (class_data[i][2] == "Promote")
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            color: Colors.green[700],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    Text(class_data[i][2].toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: class_data[i][3],
                                decoration: InputDecoration(
                                  hintText: "Reason for absence",
                                  contentPadding: EdgeInsets.all(15),
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )),
                Container(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          pController.previousPage(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeIn);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: 130,
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.grey[300],
                                    spreadRadius: 5.0,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Text("Back",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)))),
                    InkWell(
                        onTap: () async {
                          var confirm = await showDialog(
                              context: context,
                              child: AlertDialog(
                                content: Container(
                                    height: 140,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding:
                                                EdgeInsets.only(bottom: 20),
                                            child: Text(
                                                "This action once completed cannot be undone. Are you sure you want to continue?",
                                                style:
                                                    TextStyle(fontSize: 18))),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context, "No");
                                                },
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text("CANCEL",
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16)))),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context, "Yes");
                                                },
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text("YES",
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16)))),
                                          ],
                                        )
                                      ],
                                    )),
                              ));
                          print(confirm);
                          if (confirm == "Yes") {
                            var all_good = true;
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  content: Container(
                                    height: 70,
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.center,
                                    child: SpinKitRing(
                                      color: Colors.black,
                                      lineWidth: 3.0,
                                    ),
                                  ),
                                ));
                            for (var k in class_data.keys) {
                              if (class_data[k][3].text.trim() == "" &&
                                  class_data[k][1] != "Present") {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      content: Container(
                                          height: 70,
                                          padding: EdgeInsets.all(15),
                                          alignment: Alignment.center,
                                          child: Text(
                                              "Please mention why ${class_data[k][0]} was absent",
                                              style: TextStyle(fontSize: 16))),
                                    ));
                                all_good = false;
                                break;
                              }
                            }
                            if (all_good) {
                              var day_and_date = DateFormat("dd/MM/yyyy HH:mm")
                                  .format(DateTime.now());
                              for (var k in class_data.keys) {
                                var response = await http.post(
                                    "https://abworldmusic.in/API_class_actions",
                                    body: {
                                      "student_id": k.toString(),
                                      "faculty_id": id.toString(),
                                      "date_and_day": day_and_date,
                                      "slot_id": this.class_id.toString(),
                                      "status": class_data[k][2],
                                      "attendance": class_data[k][1],
                                      "reason": class_data[k][3].text,
                                    });
                                if (class_data[k][1] == "Absent") {
                                  var verifyResponse = await http.post(
                                      "https://2factor.in/API/V1/c08ea13b-61dd-11ea-9fa5-0200cd936042/ADDON_SERVICES/SEND/TSMS",
                                      body: {
                                        "From": "ABWRLD",
                                        "To": "9945613932",
                                        "TemplateName":
                                            "Class absent notification 2",
                                        "VAR1": class_data[k][0].toString(),
                                        "VAR2": class_data[k][3].text
                                      });
                                  print(verifyResponse.body);
                                  print(response.body);
                                }
                              }
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, "/FacultyHome");
                              showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    content: Container(
                                      height: 200,
                                      padding: EdgeInsets.all(15),
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(bottom: 20),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(15),
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: Colors.green[800],
                                                    width: 5.0)),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.green[800],
                                              size: 40,
                                            ),
                                          ),
                                          Text(
                                            "Submitted successfuly",
                                            style: TextStyle(
                                                color: Colors.green[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            }
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: 130,
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.grey[300],
                                    spreadRadius: 5.0,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Text("Submit",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)))),
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
