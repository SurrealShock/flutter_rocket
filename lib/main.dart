import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/services.dart';

// Will get rid of these later

final cardTitles = [
  "FALCON 1",
  "FALCON 9",
  "FALCON HEAVY",
  "BIG FALCON ROCKET"
];

final rocketAssets = [
  "images/Falcon-1.jpg",
  "images/Falcon-9.jpg",
  "images/Falcon-Heavy.jpg",
  "images/Big-Falcon-Rocket.jpg"
];

final rocketDetails = [
  "\nThe Falcon 1 was an expendable launch system privately developed and manufactured during 2006–2009.",
  "\nFalcon 9 is a family of two-stage-to-orbit medium lift launch vehicles, named for its use of nine Merlin first-stage engines.",
  "\nFalcon Heavy is a partially reusable super heavy-lift launch vehicle first launched in 2018.",
  "\nThe BFR system is planned to replace the Falcon 9 and Falcon Heavy launch vehicles, adding substantial capability to support long-duration spaceflight.",
];

void main() {
  CacheManager.inBetweenCleans = new Duration(days: 2);
  CacheManager.maxAgeCacheObject = new Duration(days: 2);
  getTheme().then((theme) {
    runApp(MyApp(defaultTheme: theme));
  });
}

class MyApp extends StatelessWidget {
  final ThemeData defaultTheme;
  const MyApp({Key key, this.defaultTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        data: (brightness) => defaultTheme,
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            theme: theme,
            home: HomePage(),
          );
        });
  }
}

Future<ThemeData> getTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool brightness = (prefs.getBool('dark') ?? false);
  return brightness ? _buildLightTheme() : _buildDarkTheme();
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: new Container(
        color: Theme.of(context).accentColor,
        height: double.infinity,
        child: FutureBuilder(
            future: fetchFutureLaunches(),
            builder: (context, snapshot) {
              final jsonResponse = json.decode(snapshot.data.toString());
              if (snapshot.hasData) {
                return new ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return new Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                        child: new Text("Future Launches:",
                            style: Theme.of(context).textTheme.subhead),
                      );
                    } else if ((index - 1) < 4) {
                      return _buildLaunchCard(
                          jsonResponse[index - 1]["mission_name"],
                          new DateFormat.EEEE()
                              .add_MMMM()
                              .add_d()
                              .add_y()
                              .add_Hm()
                              .format(new DateTime.fromMillisecondsSinceEpoch(
                                  jsonResponse[index - 1]["launch_date_unix"] *
                                      1000)),
                          context);
                    } else if ((index - 1) < 5) {
                      return new Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                        child: new Text("Rockets:",
                            style: Theme.of(context).textTheme.subhead),
                      );
                    } else {
                      return _buildExplorerCard(index - 6, context);
                    }
                  },
                );
              } else {
                return new Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).hintColor)));
              }
            }),
      ),
    );
  }
}

Future<String> fetchFutureLaunches() async {
  var cacheManager = await CacheManager.getInstance();
  var file = await cacheManager
      .getFile("https://api.spacexdata.com/v2/launches/upcoming");
  var fileJSON = file.readAsString();
  print("called cache");
  return fileJSON;
}

setTheme(Brightness dark) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool bright = dark == Brightness.dark ? true : false;
  await prefs.setBool('dark', bright);
}

ThemeData _buildDarkTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[800],
      secondaryHeaderColor: Colors.grey[800],
      accentColor: Colors.grey[850],
      hintColor: Colors.white,
      textTheme: TextTheme().copyWith(
          headline: TextStyle(
              color: Colors.white, fontSize: 18.0, fontFamily: "Sunflower"),
          subhead: TextStyle(
              color: Colors.white, fontSize: 16.0, fontFamily: "Sunflower"),
          display2: TextStyle(
              color: Colors.grey, fontSize: 16.0, fontFamily: "Sunflower"),
          body1: TextStyle(
              color: Colors.white, fontSize: 12.0, fontFamily: "Sunflower"),
          body2: TextStyle(
              color: Colors.white, fontSize: 14.0, fontFamily: "Sunflower")));
}

ThemeData _buildLightTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      secondaryHeaderColor: Colors.white,
      accentColor: Colors.grey[100],
      hintColor: Colors.black,
      textTheme: TextTheme().copyWith(
          headline: TextStyle(
              color: Colors.black, fontSize: 18.0, fontFamily: "Sunflower"),
          subhead: TextStyle(
              color: Colors.black, fontSize: 16.0, fontFamily: "Sunflower"),
          display2: TextStyle(
              color: Colors.grey[600], fontSize: 16.0, fontFamily: "Sunflower"),
          body1: TextStyle(
              color: Colors.black, fontSize: 12.0, fontFamily: "Sunflower"),
          body2: TextStyle(
              color: Colors.black, fontSize: 14.0, fontFamily: "Sunflower")));
}

Widget _buildAppBar(BuildContext context) {
  return new AppBar(
    title: new Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: new Align(
          alignment: Alignment.centerLeft,
          child: Theme.of(context).brightness == Brightness.light
              ? new Image.asset(
                  "images/SpaceX-Logo-Dark.png",
                  width: 250.0,
                )
              : new Image.asset("images/SpaceX-Logo.png", width: 250.0)),
    ),
    actions: <Widget>[
      new IconButton(
        icon: Theme.of(context).brightness == Brightness.light
            ? new Image.asset("images/moon-dark.png")
            : new Image.asset("images/moon.png"),
        onPressed: () {
          DynamicTheme.of(context).setThemeData(
              Theme.of(context).brightness == Brightness.light
                  ? _buildDarkTheme()
                  : _buildLightTheme());
          setTheme(Theme.of(context).brightness);
        },
      ),
    ],
  );
}

Widget _buildLaunchCard(
    String title, String description, BuildContext context) {
  return new Padding(
    padding: const EdgeInsets.all(10.0),
    child: new Container(
      // height: 125.0,
      decoration: new BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: [new BoxShadow(color: Colors.black38, blurRadius: 3.0)],
      ),
      child: new Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Flexible(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    title,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  new Text(
                    description,
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildExplorerCard(int index, BuildContext context) {
  return new Padding(
    padding: const EdgeInsets.all(10.0),
    child: new GestureDetector(
      onTap: () {
        Navigator
            .of(context)
            .push(new DetailRocketClass(index, rocketAssets[index]));
      },
      child: new Container(
        // height: 125.0,
        decoration: new BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.all(const Radius.circular(10.0)),
          boxShadow: [new BoxShadow(color: Colors.black38, blurRadius: 3.0)],
        ),
        child: new Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Flexible(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      cardTitles[index],
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline,
                    ),
                    new Text(
                      rocketDetails[index],
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: new Container(
                  alignment: Alignment.centerRight,
                  child: _buildImageContainer(
                    rocketAssets[index],
                    100.0,
                    70.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DetailRocketClass extends MaterialPageRoute {
  DetailRocketClass(int index, String imageAsset)
      : super(
            builder: (context) =>
                new RocketDetail(index: index, imageAsset: imageAsset));
}

class RocketDetail extends StatelessWidget {
  final int index;
  final String imageAsset;
  RocketDetail({this.index, this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: new StreamBuilder(
        stream: Firestore.instance.collection("Rockets").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return new Center(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).hintColor)));
          else {
            return new SingleChildScrollView(
              child: new Padding(
                padding: const EdgeInsets.only(
                    bottom: 32.0, left: 32.0, right: 32.0),
                child: new Container(
                    child: Column(
                  children: <Widget>[
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: new Hero(
                              tag: imageAsset,
                              child: new GestureDetector(
                                onTap: () {
                                  Navigator
                                      .of(context)
                                      .push(new FullScreenImage(imageAsset));
                                },
                                child: _buildImageContainer(
                                  imageAsset,
                                  390.5,
                                  245.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(snapshot.data.documents[index]['title'],
                            style: Theme.of(context).textTheme.headline),
                        new Text("  PAYLOAD",
                            style:
                                TextStyle(color: Colors.blue, fontSize: 18.0)),
                      ],
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: new Text(
                        "${snapshot.data.documents[index]['description']}",
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                    new Column(
                      children: <Widget>[
                        _buildRocketSpecs(
                            'Thrust In Vacuum',
                            snapshot.data.documents[index]['thrustkN'],
                            snapshot.data.documents[index]['thrustLBF'],
                            context),
                        _buildRocketSpecs(
                            'Mass',
                            snapshot.data.documents[index]['masskg'],
                            snapshot.data.documents[index]['pounds'],
                            context),
                        new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: _buildRocketSpecs(
                                    'Height',
                                    snapshot.data.documents[index]['heightM'],
                                    snapshot.data.documents[index]['heightFT'],
                                    context),
                              ),
                            ),
                            new Expanded(
                              child: new Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: _buildRocketSpecs(
                                    'Width',
                                    snapshot.data.documents[index]['widthM'],
                                    snapshot.data.documents[index]['widthFT'],
                                    context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )),
              ),
            );
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget _buildRocketSpecs(
    String title, String value1, String value2, BuildContext context) {
  return new Padding(
    padding: const EdgeInsets.only(top: 12.0),
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(title, style: Theme.of(context).textTheme.subhead),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: new Container(
            width: double.infinity,
            height: 1.0,
            color: Theme.of(context).hintColor,
          ),
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(value1, style: Theme.of(context).textTheme.subhead),
            new Text("  " + value2,
                style: Theme.of(context).textTheme.display2),
          ],
        ),
      ],
    ),
  );
}

Widget _buildImageContainer(String imageAsset, double height, double width) {
  return new Container(
    height: height,
    width: width,
    decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(16.0),
        boxShadow: [new BoxShadow(color: Colors.black38, blurRadius: 5.0)]),
    child: ClipRRect(
      borderRadius: new BorderRadius.circular(16.0),
      child: new Material(
        child: new Image.asset(
          imageAsset,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

class SecondPage extends StatelessWidget {
  final String image;
  SecondPage({this.image});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: new Container(
        color: Theme.of(context).accentColor,
        child: new Center(
          child: new Hero(
            tag: image,
            child: new Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends MaterialPageRoute {
  FullScreenImage(String image)
      : super(builder: (context) => new SecondPage(image: image));
}
