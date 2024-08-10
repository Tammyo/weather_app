import 'package:flutter/material.dart';
import 'package:weather_app/api/weatherapi.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController cityController = new TextEditingController();

  AnimationController controller;
  bool isSearching = false;
  bool expanded = true;

  String city;

  String weatherImage = 'assets/images/sun.png';
  Map weather;
  List features;
  String defaultCity = 'Lagos';
  String cityEntered;

  Future<Map> weatherFuture;

  Future<Map> getWeather() async {
    if(city == null){
      weatherFuture = WeatherAPI().getWeatherData(defaultCity);
    }else if(city != null){
      weatherFuture = WeatherAPI().getWeatherData(city);
    }
    return await weatherFuture;
  }

  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
        reverseDuration: Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text(
                'Weather',
                style: new TextStyle(
                    color: Colors.blueGrey, fontSize: 20, fontFamily: 'PTsans'),
              )
            : TextFormField(
                controller: cityController,
                style: new TextStyle(
                    color: Colors.blueGrey, fontSize: 20, fontFamily: 'PTsans'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Search City Here',
                  hintStyle: new TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      fontFamily: 'PTsans'),
                ),
              ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: new IconButton(
          onPressed: () {
            setState(() {
              expanded ? controller.forward() : controller.reverse();
              expanded = !expanded;
            });
          },
          icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close, progress: controller),
          color: Colors.blueGrey,
        ),
        actions: <Widget>[
          isSearching
              ? new IconButton(
                  onPressed: () {

                    setState(() {
                      city = cityController.text;
//                      getWeather();
//                      WeatherCardState().getWeather(city);
                      this.isSearching = false;
                    });
                  },
                  icon: Icon(Icons.check_circle),
                  color: Colors.blueGrey,
                )
              : new IconButton(
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search),
                  color: Colors.blueGrey,
                )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[],
        ),
      ),
      body: Stack(
        children: <Widget>[
          new Center(
            child: Image.asset(
              'assets/images/umbrella.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: SizedBox(
              width: 250,
              height: 300,
              child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.white,
                  child: updateTemp()),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder updateTemp() {
    return FutureBuilder<Map>(
        future: getWeather(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            if (content['weather'][0]['main'].toString() == 'Haze' ||
                content['weather'][0]['main'].toString() == 'Clear' ||
                content['weather'][0]['main'].toString() == 'Sunny') {
              weatherImage = 'assets/images/sun.png';
            } else if (content['weather'][0]['main'].toString() == 'Clouds') {
              weatherImage = 'assets/images/cloud.png';
            } else if (content['weather'][0]['main'].toString() == 'Rain') {
              weatherImage = 'assets/images/rain.png';
            } else if (content['weather'][0]['main'].toString() == 'Snow') {
              weatherImage = 'assets/images/snow.png';
            } else if (content['weather'][0]['main'].toString() == 'Thunder') {
              weatherImage = 'assets/images/thunder.png';
            }
            return Column(
              children: [
                SizedBox(
                  width: 249,
                  height: 200,
                  child: new Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 15),
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                '$weatherImage',
                                height: 60,
                                width: 60,
                              ),
                              Container(
                                  margin:
                                  const EdgeInsets.only(top: 14, left: 10),
                                  child: RichText(
                                    text: TextSpan(text: '', children: [
                                      new TextSpan(children: [
                                        TextSpan(
                                            text:
                                            '${content['weather'][0]['main']}\n',
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 15,
                                                fontFamily: 'PTsans',
                                                height: 0.1,
                                                fontWeight: FontWeight.w500)),
                                        TextSpan(
                                            text:
                                            '${content['main']['temp']
                                                .toString()}C',
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 35,
                                                fontFamily: 'Abel',
                                                fontWeight: FontWeight.w500)),
                                      ])
                                    ]),
                                  )),
                            ],
                          ),
                        ),
                        new Divider(
                          color: Colors.blueGrey.withOpacity(0.3),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(top: 40),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(text: '', children: [
                                        new TextSpan(children: [
                                          TextSpan(
                                              text: 'Humidity\n',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15,
                                                  fontFamily: 'PTsans',
                                                  height: 0.1,
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(
                                              text:
                                              '${content['main']['humidity']
                                                  .toString()}C',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 35,
                                                  fontFamily: 'Abel',
                                                  fontWeight: FontWeight.w500)),
                                        ])
                                      ]),
                                    ),
                                    RichText(
                                      text: TextSpan(text: '', children: [
                                        new TextSpan(children: [
                                          TextSpan(
                                              text: 'Pressure\n',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15,
                                                  fontFamily: 'PTsans',
                                                  height: 0.1,
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(
                                              text:
                                              '${content['main']['pressure']
                                                  .toString()}P',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 35,
                                                  fontFamily: 'Abel',
                                                  fontWeight: FontWeight.w500)),
                                        ])
                                      ]),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Divider(
                  color: Colors.blueGrey.withOpacity(0.3),
                ),
                ListTile(
                  title: Text('${content['name']}',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 21,
                          fontFamily: 'PTsans',
                          fontWeight: FontWeight.w500)),
                  subtitle: Text(
                      '${content['weather'][0]['description']
                          .toString()
                          .toUpperCase()}',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15,
                          fontFamily: 'PTsans',
                          fontWeight: FontWeight.w100)),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.location_on,
                    ),
                    color: Colors.blueGrey,
                    iconSize: 34,
                  ),
                ),
              ],
            );
          } else {
            return Center(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/wifi.png',
                        height: 90,
                        width: 90,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('Check your Internet',
                            style: TextStyle(
                                color: Color(0xFF4CAEFE),
                                fontSize: 21,
                                fontFamily: 'PTsans',
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ));
          }
        });
  }
}
