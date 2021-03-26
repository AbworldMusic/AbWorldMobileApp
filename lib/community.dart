import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'full_screen_image.dart';
import 'nav_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class CommunityScreen extends StatefulWidget {
  @override
  State<CommunityScreen> createState() => CommunityScreenState();
}

class CommunityScreenState extends State<CommunityScreen> {
  var all_posts = [];
  var videoPlayerControllers = {};
  var videoPlayerIcons = {};
  var current_user_id;
  ScrollController scroll;
  var role;
  var loadingNewPosts = false;

  getMorePosts() async {
    print("Loading more posts");
    loadingNewPosts = true;
    var response = await http.get(
        "https://www.abworldmusic.in/API_community_get?user_id=" +
            current_user_id.toString() +
            "&id=" +
            all_posts[all_posts.length - 1]["id"].toString());
    print(response.body);

    var current_posts = jsonDecode(response.body);
    for (var i = 0; i < current_posts.length; i++) {
      all_posts.add(current_posts[i]);
      var filename = current_posts[i]['filename'];
      if (filename.trim() != "" &&
          ["mp4", "vid"].contains(filename.split(".")[1])) {
        var _controller = new VideoPlayerController.network(
            "https://www.abworldmusic.in/MySite/images/" + filename);
        _controller.initialize();
        videoPlayerControllers[current_posts[i]['id']] = _controller;
        videoPlayerIcons[current_posts[i]['id']] =
            Icon(Icons.play_arrow, color: Colors.white, size: 40);
      }
    }
    setState(() {
      for (var i = 0; i < current_posts.length; i++) {
        all_posts.add(current_posts[i]);
      }
    });
    loadingNewPosts = false;
  }

  getAllPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    current_user_id = prefs.getString("id");
    var response = await http.get(
        "https://www.abworldmusic.in/API_community_get?user_id=" +
            current_user_id.toString());
    print(response.body);
    setState(() {
      role = prefs.getString("role");
      all_posts = jsonDecode(response.body);
      for (int i = 0; i < all_posts.length; i++) {
        var filename = all_posts[i]['filename'];
        if (filename.trim() != "" &&
            ["mp4", "vid"].contains(filename.split(".")[1])) {
          var _controller = new VideoPlayerController.network(
              "https://www.abworldmusic.in/MySite/images/" + filename);
          _controller.initialize();
          videoPlayerControllers[all_posts[i]['id']] = _controller;
          videoPlayerIcons[all_posts[i]['id']] =
              Icon(Icons.play_arrow, color: Colors.white, size: 40);
        }
      }
      print(videoPlayerControllers);
    });
  }

  pauseAllVideos() {
    for (int i in videoPlayerControllers.keys) {
      videoPlayerControllers[i].pause();
      videoPlayerIcons[i] =
          Icon(Icons.play_arrow, color: Colors.white, size: 40);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPosts();
    scroll = new ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scroll.position.extentAfter < 500 && !loadingNewPosts) {
      getMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff330033),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/StudentProfile');
            },
            child: Container(
                margin: EdgeInsets.only(right: 20, bottom: 5),
                padding: EdgeInsets.all(10),
                child: Icon(Icons.person_outline, color: Colors.white)),
          )
        ],
      ),
      drawer: NavDrawer(),
      body: Container(
        color: Color(0xff110011),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            ListView.builder(
                controller: scroll,
                physics: BouncingScrollPhysics(),
                itemCount: all_posts.length,
                itemBuilder: (BuildContext ctxt, int Index) {
                  if (all_posts[Index]['filename'].trim() != "" &&
                      [
                        "mp4",
                        "vid"
                      ].contains(all_posts[Index]['filename'].split(".")[1])) {
                    return Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 25),
                              child: Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5, top: 25),
                              child: Text(all_posts[Index]["username"],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: 15, right: 15, top: 20, bottom: 10),
                            width: MediaQuery.of(context).size.width - 30,
                            height: MediaQuery.of(context).size.width - 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[900]),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                VideoPlayer(
                                  videoPlayerControllers[all_posts[Index]
                                      ['id']],
                                ),
                                InkWell(
                                  onTap: () {
                                    if (videoPlayerControllers[all_posts[Index]
                                            ['id']]
                                        .value
                                        .isPlaying) {
                                      videoPlayerControllers[all_posts[Index]
                                              ['id']]
                                          .pause();
                                      setState(() {
                                        videoPlayerIcons[all_posts[Index]
                                                ['id']] =
                                            Icon(Icons.play_arrow,
                                                color: Colors.white, size: 40);
                                      });
                                    } else {
                                      pauseAllVideos();
                                      videoPlayerControllers[all_posts[Index]
                                              ['id']]
                                          .play();
                                      setState(() {
                                        videoPlayerIcons[all_posts[Index]
                                                ['id']] =
                                            Icon(Icons.pause,
                                                color: Colors.white, size: 40);
                                      });
                                    }
                                  },
                                  child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      alignment: Alignment.center,
                                      width: 50,
                                      height: 50,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Color(0xff330033),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: videoPlayerIcons[all_posts[Index]
                                          ['id']]),
                                ),
                              ],
                            )),
                        Row(children: <Widget>[
                          if (all_posts[Index]['likedBySelf'] == "0")
                            InkWell(
                              onTap: () async {
                                if (role == "Student") {
                                  var response = await http.post(
                                      "https://www.abworldmusic.in/API_like_post",
                                      body: {
                                        "post_id":
                                            all_posts[Index]["id"].toString(),
                                        "user_id": all_posts[Index]['user_id']
                                            .toString(),
                                        "current_user_id": current_user_id,
                                      });

                                  var responseBody = jsonDecode(response.body);
                                  if (responseBody['like'] == "+1") {
                                    setState(() {
                                      all_posts[Index]['likedBySelf'] = "1";
                                      all_posts[Index]['likes'] = (int.parse(
                                                  all_posts[Index]['likes']) +
                                              1)
                                          .toString();
                                    });
                                  } else {
                                    setState(() {
                                      all_posts[Index]['likedBySelf'] = "0";
                                      all_posts[Index]['likes'] = (int.parse(
                                                  all_posts[Index]['likes']) -
                                              1)
                                          .toString();
                                    });
                                  }
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                    left: 15,
                                    top: 10,
                                  ),
                                  child:
                                      Icon(Icons.thumb_up, color: Colors.grey)),
                            ),
                          if (all_posts[Index]['likedBySelf'] == "1")
                            InkWell(
                              onTap: () async {
                                if (role == "Student") {
                                  var response = await http.post(
                                      "https://www.abworldmusic.in/API_like_post",
                                      body: {
                                        "post_id":
                                            all_posts[Index]["id"].toString(),
                                        "user_id": all_posts[Index]['user_id']
                                            .toString(),
                                        "current_user_id": current_user_id,
                                      });

                                  var responseBody = jsonDecode(response.body);
                                  if (responseBody['like'] == "+1") {
                                    setState(() {
                                      all_posts[Index]['likes'] = (int.parse(
                                                  all_posts[Index]['likes']) +
                                              1)
                                          .toString();
                                    });
                                  } else {
                                    setState(() {
                                      all_posts[Index]['likes'] = (int.parse(
                                                  all_posts[Index]['likes']) -
                                              1)
                                          .toString();
                                    });
                                  }
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                    left: 15,
                                    top: 10,
                                  ),
                                  child: Icon(
                                    Icons.thumb_up,
                                    color: Color(0xff330033),
                                  )),
                            ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 15),
                            child: Text(
                                all_posts[Index]["likes"].toString() + " likes",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ]),
                        Container(
                          margin:
                              EdgeInsets.only(top: 15, left: 15, bottom: 30),
                          child: Text(all_posts[Index]["caption"],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w100)),
                        ),
                      ],
                    ));
                  } else {
                    return Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 25),
                              child: Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5, top: 25),
                              child: Text(all_posts[Index]["username"],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width - 30,
                          height: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[900]),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://www.abworldmusic.in/MySite/images/" +
                                      all_posts[Index]['filename']),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Row(children: <Widget>[
                          if (all_posts[Index]['likedBySelf'] == "0")
                            InkWell(
                              onTap: () async {
                                if (role == "Student") {
                                  var response = await http.post(
                                      "https://www.abworldmusic.in/API_like_post",
                                      body: {
                                        "post_id":
                                            all_posts[Index]["id"].toString(),
                                        "user_id": current_user_id
                                      });

                                  var responseBody = jsonDecode(response.body);
                                  if (responseBody['like'] == "+1") {
                                    setState(() {
                                      all_posts[Index]['likedBySelf'] = "1";
                                      all_posts[Index]['likes'] = (int.parse(
                                                  all_posts[Index]['likes']) +
                                              1)
                                          .toString();
                                    });
                                  } else {
                                    setState(() {
                                      all_posts[Index]['likedBySelf'] = "0";
                                      all_posts[Index]['likes'] = (int.parse(
                                                  all_posts[Index]['likes']) -
                                              1)
                                          .toString();
                                    });
                                  }
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                    left: 15,
                                    top: 10,
                                  ),
                                  child:
                                      Icon(Icons.thumb_up, color: Colors.grey)),
                            ),
                          if (all_posts[Index]['likedBySelf'] == "1")
                            InkWell(
                              onTap: () async {
                                if (role == "Student") {
                                  print(all_posts[Index].toString());
                                  var response = await http.post(
                                      "https://www.abworldmusic.in/API_like_post",
                                      body: {
                                        "post_id":
                                            all_posts[Index]["id"].toString(),
                                        "user_id": current_user_id
                                      });
                                  print(response.body);
                                  var responseBody = jsonDecode(response.body);
                                  if (responseBody['like'] == "+1") {
                                    setState(() {
                                      all_posts[Index]['likedBySelf'] = "1";
                                      all_posts[Index]['likes'] = (int.parse(
                                                  all_posts[Index]['likes']) +
                                              1)
                                          .toString();
                                    });
                                  } else {
                                    setState(() {
                                      all_posts[Index]['likedBySelf'] = "0";
                                      all_posts[Index]['likes'] = (int.parse(
                                                  all_posts[Index]['likes']) -
                                              1)
                                          .toString();
                                    });
                                  }
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                    left: 15,
                                    top: 10,
                                  ),
                                  child: Icon(
                                    Icons.thumb_up,
                                    color: Color(0xff330033),
                                  )),
                            ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 15),
                            child: Text(
                                all_posts[Index]["likes"].toString() + " likes",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ]),
                        Container(
                          margin:
                              EdgeInsets.only(top: 15, left: 15, bottom: 30),
                          child: Text(all_posts[Index]["caption"],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w100)),
                        ),
                      ],
                    ));
                  }
                }),
            if (role == "Student")
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/AddNewPost");
                },
                child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(20),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0xff330033),
                    ),
                    child: Icon(Icons.add, color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
