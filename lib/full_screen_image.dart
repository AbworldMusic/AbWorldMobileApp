import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  
  var profilePictureUrl;
  FullScreenImage(this.profilePictureUrl);


  @override
  Widget build(BuildContext context1) {
     return MaterialApp(
       home: Scaffold(
         body: PhotoView(
           minScale: PhotoViewComputedScale.contained * 1.0,
            imageProvider: this.profilePictureUrl == null || this.profilePictureUrl == "https://www.abworldmusic.in/MySite/images/" ? AssetImage("assets/profile-picture-placeholder.png") : NetworkImage(this.profilePictureUrl)
         )
       ),
     );
    }
}

