import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

import 'why_me.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  void _hireMe() {

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pitch = [
      Profile(),
      WhyMe(),
      MyCurrentCompany(),
      ListViewInterview(),
      MyNewCompany(),
    ];

    return MaterialApp(
      title: 'Kirill Dubovitskiy',
      theme: ThemeData(
        // primaryColor: Color(0xff9c27b0),
        primarySwatch: Colors.purple,
        accentColor: Color(0xff009688),

        cardTheme: CardTheme(
          margin: EdgeInsets.all(20),
        )
      ),
      home: Scaffold(
        appBar: AppBar(
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (var point in pitch)
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: point
                    ),
                  ),
              ],
            )
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _hireMe,
          tooltip: 'Hire me',
          child: Icon(Icons.work),
        ),
        bottomSheet: MoreAboutMe(),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  static const _avatar = 'https://pbs.twimg.com/profile_images/1212953242130251784/aIFH_Hkm_400x400.jpg';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              _avatar,
            ),
          ),
          title: Text('Kirill Dubovitskiy'),
          subtitle: Text('Mobile engineer'),
        ),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              onPressed: () {},
              child: Icon(MaterialCommunityIcons.github_circle)
            ),
            FlatButton(
              onPressed: () {},
              child: Icon(MaterialCommunityIcons.twitter)
            ),
            FlatButton(
              onPressed: () {},
              child: Icon(MaterialCommunityIcons.linkedin)
            ),
          ],
        ),
      ],
    );
  }
}

class MyCurrentCompany extends StatefulWidget {
  const MyCurrentCompany({Key key}) : super(key: key);

  @override
  _MyCurrentCompanyState createState() => _MyCurrentCompanyState();
}

class _MyCurrentCompanyState extends State<MyCurrentCompany> {
  Future<List<String>> images = fetchImages();

  static Future<List<String>> fetchImages() async {
    const endpoint = 'https://simplescraper.io/api/ujc62zH2QffMqQSEcdUM?apikey=Yn51t6IUyJLMV1dM4y3kL7V7KJdJQ33m&offset=0&limit=100';

    var response = await get(endpoint);
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> body = ((jsonDecode(response.body) as Map<String, dynamic>)['data'] as List).cast<Map<String, dynamic>>();
      return body.map((Map<String, dynamic> image) => image['image'] as String).toList();
    } else {
      throw 'Error getting padx.com images. Status code: ${response.statusCode}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'padx.com',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launch('https://padx.com/#apps'),
                      ),
                    ]
                  ),
                ),
                Text('Feature proposals'),
                Text('Architecture'),
                Text('Distribution'),
              ],
            ),
            Expanded(
              child: _gallery(),
            )
          ],
        )
      ],
    );
  }

  Widget _gallery() {
    return FutureBuilder<List<String>>(
      future: images,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (var image in snapshot.data) 
                Image.network(image)
            ],
          )
        );
      },
    );
  }
}

class ListViewInterview extends StatelessWidget {
  const ListViewInterview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('List view interview - lets skip the boring stuff'),
    );
  }
}

class MyNewCompany extends StatelessWidget {
  const MyNewCompany({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('My new company - '),
    );
  }
}

class MoreAboutMe extends StatelessWidget {
  const MoreAboutMe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (_) => Text('Advent of code 15'),
      onClosing: () {},
    );
  }
}
