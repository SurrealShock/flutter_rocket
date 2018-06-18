import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: _buildDarkTheme(),
        home: new Scaffold(
          appBar: _buildAppBar(),
          body: new Container(
            color: Theme.of(context).accentColor,
            height: double.infinity,
            child: new ListView.builder(
              itemCount: cardTitles.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return new Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                    child: new Text("Rockets:",
                        style: Theme.of(context).primaryTextTheme.subhead),
                  );
                } else if ((index - 1) < 4) {
                  return new BuildExplorerCard(
                    index: index - 1,
                  );
                } else if ((index - 1) < 5) {
                  return new Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                    child: new Text("Future Launches:",
                        style: Theme.of(context).primaryTextTheme.subhead),
                  );
                } else {}
              },
            ),
          ),
        ));
  }
}

ThemeData _buildDarkTheme() {
  final baseTheme = ThemeData(
    fontFamily: "Sunflower",
  );
  return baseTheme.copyWith(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[800],
      accentColor: Colors.grey[850],
      primaryTextTheme: new TextTheme(
          headline: new TextStyle(color: Colors.white, fontSize: 18.0),
          subhead: new TextStyle(color: Colors.white, fontSize: 16.0),
          display2: new TextStyle(color: Colors.grey, fontSize: 16.0),
          body1: new TextStyle(color: Colors.white, fontSize: 12.0),
          body2: new TextStyle(color: Colors.white, fontSize: 14.0)));
}

ThemeData _buildLightTheme() {
  final baseTheme = ThemeData.light();
  return baseTheme.copyWith(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      primaryTextTheme: new TextTheme(
          headline: new TextStyle(color: Colors.black, fontSize: 18.0),
          subhead: new TextStyle(color: Colors.black, fontSize: 16.0),
          display2: new TextStyle(color: Colors.grey, fontSize: 16.0),
          body1: new TextStyle(color: Colors.black, fontSize: 12.0),
          body2: new TextStyle(color: Colors.black, fontSize: 14.0)));
}


Widget _buildAppBar() {
  return new AppBar(
    title: new Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: new Align(
          alignment: Alignment.centerLeft,
          child: Image.asset('images/SpaceX-Logo.png', width: 250.0)),
    ),
    actions: <Widget>[
      new IconButton(
        icon: new Image.asset('images/Rocket.png'),
        onPressed: () {
          print("pressed");
        },
      ),
    ],
  );
}

class BuildExplorerCard extends StatelessWidget {
  final int index;
  const BuildExplorerCard({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              new DetailRocketClass(cardTitles[index], rocketAssets[index]));
        },
        child: new Container(
          height: 125.0,
          decoration: new BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(const Radius.circular(10.0)),
            boxShadow: [new BoxShadow(color: Colors.black45, blurRadius: 7.5)],
          ),
          child: new Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                        style: Theme.of(context).primaryTextTheme.headline,
                      ),
                      new Text(
                        rocketDetails[index],
                        style: Theme.of(context).primaryTextTheme.body1,
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new BuildImageContainer(
                      imageAsset: rocketAssets[index],
                      height: 100.0,
                      width: 70.0,
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
}

class DetailRocketClass extends MaterialPageRoute {
  DetailRocketClass(String title, imageAsset)
      : super(
            builder: (context) =>
                new RocketDetail(title: title, imageAsset: imageAsset));
}

class RocketDetail extends StatelessWidget {
  final String title;
  final String imageAsset;
  RocketDetail({this.title, this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new Container(
        height: double.infinity,
        child: new SingleChildScrollView(
          child: new Container(
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: new Hero(
                    tag: imageAsset,
                    child: new GestureDetector(
                      onTap: () {
                        Navigator
                            .of(context)
                            .push(new FullScreenImage(imageAsset));
                      },
                      child: new BuildImageContainer(
                        imageAsset: imageAsset,
                        height: 390.5,
                        width: 245.0,
                      ),
                    ),
                  ),
                ),
                new StreamBuilder(
                  stream: Firestore.instance.collection(title).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return new Container(
                          child: CircularProgressIndicator());
                    else {
                      return new Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: new Container(
                            child: Column(
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Text(title,
                                    style: Theme
                                        .of(context)
                                        .primaryTextTheme
                                        .headline),
                                new Text("  PAYLOAD",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18.0)),
                              ],
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: new Text(
                                "${snapshot.data.documents[0]['description']}",
                                style: Theme.of(context).primaryTextTheme.body2,
                              ),
                            ),
                            new Column(
                              children: <Widget>[
                                new BuildRocketSpecs(
                                  title: 'Thrust In Vacuum',
                                  value1: snapshot.data.documents[0]
                                      ['thrustkN'],
                                  value2: snapshot.data.documents[0]
                                      ['thrustLBS'],
                                ),
                                new BuildRocketSpecs(
                                  title: 'Mass',
                                  value1: snapshot.data.documents[0]['masskg'],
                                  value2: snapshot.data.documents[0]['pounds'],
                                ),
                                new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      child: new Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: new BuildRocketSpecs(
                                          title: 'Height',
                                          value1: snapshot.data.documents[0]
                                              ['heightM'],
                                          value2: snapshot.data.documents[0]
                                              ['heightFT'],
                                        ),
                                      ),
                                    ),
                                    new Expanded(
                                      child: new Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: new BuildRocketSpecs(
                                          title: 'Width',
                                          value1: snapshot.data.documents[0]
                                              ['widthM'],
                                          value2: snapshot.data.documents[0]
                                              ['widthFT'],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        )),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BuildRocketSpecs extends StatelessWidget {
  const BuildRocketSpecs({
    Key key,
    @required this.title,
    @required this.value1,
    @required this.value2,
  }) : super(key: key);

  final String title;
  final String value1;
  final String value2;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(title,
              style: Theme.of(context).primaryTextTheme.subhead),
          new Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: new Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black,
            ),
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(value1,
                  style: Theme.of(context).primaryTextTheme.subhead),
              new Text("  " + value2,
                  style: Theme.of(context).primaryTextTheme.display2),
            ],
          ),
        ],
      ),
    );
  }
}

class BuildImageContainer extends StatelessWidget {
  const BuildImageContainer({
    Key key,
    @required this.imageAsset,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final String imageAsset;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
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
}

class SecondPage extends StatelessWidget {
  final String image;
  SecondPage({this.image});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new Container(
        color: Colors.grey[850],
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
