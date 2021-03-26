import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';


class Metronome extends StatefulWidget{
  @override
  State<Metronome> createState() => MetronomeState();
}

class MetronomeState extends State<Metronome>{

  var bpm = TextEditingController(text: "60");
  var bpmValue = 60;
  var playIcon = Icon(Icons.play_arrow);
  var isPlaying = false;
  var audio = AudioPlayer();
  Timer timer;

  @override
  @override
  void dispose() {    
    super.dispose();
    timer.cancel();

  }
  
  playLocal() async {
    int result = await audio.play("assets/tick.mp3", isLocal: true);
    print(result);
  }
  
  _startMetronome(){
    audio.setUrl("assets/tick.mp3", isLocal: true);
    if(isPlaying){
      timer.cancel();
      setState(() {
        playIcon = Icon(Icons.play_arrow);
      });
      isPlaying = false;
    }
    else{
      isPlaying = true;
      setState(() {
        playIcon = Icon(Icons.pause);
      });
      timer = new Timer.periodic(
        new Duration(milliseconds: 1000 ), (timer) {
          playLocal();
          print("interval");
      });

    }
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
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

      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: bpm,
                onEditingComplete: (){
                  setState(() {
                    bpmValue = int.parse(bpm.text);
                  });
                },
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: InkWell(
                  child: playIcon,
                  onTap: (){
                    _startMetronome();
                  },
                ),
              )
              
            ],
          ),
        )
      )
    );
  }

}