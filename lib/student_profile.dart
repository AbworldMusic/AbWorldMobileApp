import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'full_screen_image.dart';
import 'package:image_picker/image_picker.dart';


class StudentProfileScreen extends StatefulWidget{
  @override
  State<StudentProfileScreen> createState() => StudentProfileScreeState();
}

class StudentProfileScreeState extends State<StudentProfileScreen>{

  var id;
  var name ="";
  var age;
  var instrument;
  var course;
  var showEditPasswordBtn = false;
  var password = TextEditingController();
  var profilePictureUrl = "";

  viewImage(){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FullScreenImage(profilePictureUrl))
      );
  }

  changeProfilePicture() async{
    var sourceChosen = await showDialog(context: context,
        child: AlertDialog(
          content: Container(
            height: 95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    Navigator.pop(context,"Camera");
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      boxShadow: [BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),]
                    ),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.camera, size: 30),
                        Text("Camera")
                      ],
                    )
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context,"Gallery");
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      boxShadow: [BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),]
                    ),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.image, size: 30),
                        Text("Gallery")
                      ],
                    )
                  ),
                )
              ],
            ),
          )
        )
      );
    var image;
    if (sourceChosen == 'Camera') 
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    else 
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var confirmOption = await showDialog(context: context,
      child: AlertDialog(
        content: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: (){
                  Navigator.pop(context,"Yes");
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.green[700],
                  padding: EdgeInsets.all(15),
                  width: 100,
                  height: 60,
                  child: Text(
                    "Yes", style: TextStyle(color: Colors.white),
                  )
                )
              ),
              InkWell(
                onTap: (){
                  Navigator.pop(context,"Cancel");
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.red[700],
                  padding: EdgeInsets.all(15),
                  width: 100,
                  height: 60,
                  child: Text(
                    "Cancel", style: TextStyle(color: Colors.white),
                  )
                )
              ),
            ],
          ),
        ),
      )
    );
    if(confirmOption=="Yes"){
      var uri = Uri.parse("https://www.abworldmusic.in/API_update_profile_picture_url");
      var request = new http.MultipartRequest("POST", uri);
      var pic = await http.MultipartFile.fromPath("image", image.path);
      request.files.add(pic);
      request.fields['id'] = id;
      showDialog(context: context, child: AlertDialog(content: Text("Uploading!!"),));
      var response = await request.send();
      var responseData =
          await response.stream.toBytes();
      var responseString =
          String.fromCharCodes(responseData);
      print(responseString);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, "/StudentProfile");
    }
  }

  getProfilePictureUrl(var id) async{    
    print("https://www.abworldmusic.in/API_get_profile_picture_url?id=$id");
    var response = await http.get("https://www.abworldmusic.in/API_get_profile_picture_url?id=$id");  
    print(response.body);
    setState(() {
      profilePictureUrl =  jsonDecode(response.body)['image'];  
    });
  }

  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("id");
      name = prefs.getString("name").split(" ")[0];
      age = prefs.getString("age");
      instrument = prefs.getString("instrument");
      course = prefs.getString("course");
    });
    getProfilePictureUrl(id);
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
              Navigator.pushNamed(context, '/StudentHome');
            },
            child: Container(
              margin:  EdgeInsets.only(right: 20, bottom: 5),
              padding:  EdgeInsets.all(10),            
              child: Icon(Icons.home, color: Colors.white)
            )
          ),          
        ],
      ),

      body: ListView(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[

              Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height-100,
                color: Color(0xff330033),
                child: Container(
                  height: MediaQuery.of(context).size.height-300,
                  color: Colors.grey[200],
                ), 
              ),
              Container(
                margin: EdgeInsets.only(top: 140),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () async{
                        var optionChosen = await showDialog(context: context,
                          child: AlertDialog(
                            content: Container(
                              height: 125,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context,"View");
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.only(bottom: 15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        boxShadow: [BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5.0,
                                        ),]
                                      ),
                                      child: Text("View profile photo", style: TextStyle(fontSize: 18),)
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pop(context,"Change");
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        boxShadow: [BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5.0,
                                        ),]
                                      ),
                                      child: Text("Change profile photo", style: TextStyle(fontSize: 18),)
                                    ),
                                  )
                                ],
                              ),
                            )
                          )
                        );
                        if(optionChosen=="View")
                          viewImage();
                        else
                          changeProfilePicture();
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[500]
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: profilePictureUrl == null || profilePictureUrl == "https://www.abworldmusic.in/MySite/images/" ? AssetImage("assets/profile-picture-placeholder.png") : NetworkImage(profilePictureUrl)
                          )
                        ),                      
                      ), 
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: 40),
                      child: Text("Name: $name", style: TextStyle(fontSize: 18),)
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: 10),
                      child: Text("Age: $age", style: TextStyle(fontSize: 18),)
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: 10),
                      child: Text("Instrument: $instrument", style: TextStyle(fontSize: 18),)
                    ),
                     Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: 10),
                      child: Text("Course: $course", style: TextStyle(fontSize: 18),)
                    )
                  ],
                )  
              )
              

            ],
          )
        ],
      )
    );
  }

}