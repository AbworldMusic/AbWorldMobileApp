import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'full_screen_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'nav_drawer.dart';
import 'package:video_player/video_player.dart';
  


class AddNewPostScreen extends StatefulWidget{
  @override
  State<AddNewPostScreen> createState() => AddNewPostScreenState();
}


class AddNewPostScreenState extends State<AddNewPostScreen>{

  var attached_filename = "";
  var caption = TextEditingController();
  var attached_file;
  var attached_file_type;
  var videoController;
  var videoIcon =  Icon(Icons.play_arrow, color: Colors.white, size: 40);

   @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }


  addPicture() async{
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
    if (sourceChosen == 'Camera') 
      attached_file = await ImagePicker.pickImage(source: ImageSource.camera);
    else if (sourceChosen == 'Gallery')
      attached_file = await await FilePicker.getFile();
    setState(() {
      attached_filename = attached_file.path.split('/')[attached_file.path
            .split('/')
            .length - 1].toString();   
      if(["mp4","vid"].contains(attached_filename.split(".")[1])){
        print("Video added");
        attached_file_type = 'video';
        print(attached_file);
        videoController = VideoPlayerController.file(File(attached_file.path));
        videoController.initialize();        
        print(videoController);
      }  
      else if(["jpg","png", "jpeg"].contains(attached_filename.split(".")[1])){
        print("Image added");
        attached_file_type = 'image';
      }
    });        
  }

  playPauseVideo(){
    setState(() {
      if (!videoController.value.isPlaying) {
        print("Video playing");
        videoController.play();
        videoIcon =  Icon(Icons.pause, color: Colors.white, size: 40);
      }
      else{
        videoController.pause();
        print("Video pausing");
        videoIcon =  Icon(Icons.play_arrow, color: Colors.white, size: 40); 
      }
    });
  }

  upload() async{
    var uri = Uri.parse(
        "https://www.abworldmusic.in/API_community_post");
    var request =
        new http.MultipartRequest("POST", uri);
    request.fields['caption'] = caption.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    request.fields['user_id'] = prefs.getString("id");
    var pic = await http.MultipartFile.fromPath("attachment", attached_file.path);
    request.files.add(pic);
    showDialog(context: context, child: AlertDialog(content: Text("Uploading!!"),));
      var response = await request.send();
      var responseData =
          await response.stream.toBytes();
      var responseString =
          String.fromCharCodes(responseData);
      print(responseString);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, "/Community");
      showDialog(
          context: context, 
          child: AlertDialog(
            content: Container(
              height: 200,
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.green[800], width: 5.0)
                    ),
                    child: Icon(Icons.check, color: Colors.green[800], size: 40,),
                  ),
                  Text("Upload successfull", style: TextStyle( color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 18),)
                ],
              ),
            ),
          )
        );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        
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

      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: (){
                  addPicture();
                },
                child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(15),
                width: 70,
                decoration: BoxDecoration(
                  color: Color(0xff330033),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: Offset(0.0, 5.0)
                  ),]
                ),   
                child: Icon(Icons.camera_alt, color: Colors.white, size: 25,),
              ),
              ),                          
            ],
          ),    
          Container(
            margin: EdgeInsets.only(left: 15, top: 20, bottom: 10),
            child: Text(
              "LET OTHERS KNOW WHAT YOU'RE UPTO!",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
          if(attached_filename!='' && attached_file_type=='image')          
            Container(
              margin: EdgeInsets.only(left: 15,right: 15, top: 20, bottom: 10),
              width: MediaQuery.of(context).size.width-60, 
              height: MediaQuery.of(context).size.width-60, 
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: MemoryImage(attached_file.readAsBytesSync()),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          if(attached_filename!='' && attached_file_type=='video')          
            Container(
              margin: EdgeInsets.only(left: 15,right: 15, top: 20, bottom: 10),
              width: MediaQuery.of(context).size.width-60, 
              height: MediaQuery.of(context).size.width-60, 
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(10),                
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[                  
                  VideoPlayer(videoController, ),
                  InkWell(
                    onTap: (){
                      playPauseVideo();
                    },
                    child:  AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      alignment: Alignment.center, 
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xff330033),
                        borderRadius: BorderRadius.circular(50)                      
                      ),
                      child: videoIcon,
                    ), 
                  ),                 
                ],
              )
            ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: caption,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5)
                )
              ),
            ),
          ),  
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    upload();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),                    
                    width: MediaQuery.of(context).size.width-30,
                    decoration: BoxDecoration(
                      color: Color(0xff330033),
                      borderRadius: BorderRadius.circular(5 ),
                      boxShadow: [BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 3.0)
                      ),]
                    ),   
                    child: Text("UPLOAD!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),)
                  ),      
                )
              ],
            ),
          )                        
        ],
      )
    );
  }

}