import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import 'dart:async';

String appname = "Fastella";

enum Status { Red, Green, Blue }

void main(List<String> args) {
  // timer.cancel() ;

  runApp(AppCore());
}

var arr = [
  FontAwesomeIcons.circleExclamation, // warning
  FontAwesomeIcons.ellipsis,
  FontAwesomeIcons.clock,
];

class AppCore extends StatelessWidget {
  const AppCore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(appname),
          ),
        ),
        body: HomePageWidget(),
      ),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  static const BlueLight = Color(0xff2b87d1);
  static const RedLight = Color(0xffce2636);
  static const GreenLight = Color(0xff4bdb6a);
  Color back_color = BlueLight;

  String main_text = "Reaction Time Test";
  String additional_text =
      "When the red box turns green, click as quickly as you can.";

  Status status = Status.Blue;
  IconData icon = FontAwesomeIcons.boltLightning;

  late DateTime start;
  late DateTime end;
  late Timer timer;

  Color icon_color = Colors.white70;
  var generator = Random();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (status == Status.Blue) {
          setState(() {
            back_color = RedLight;
            main_text = "Tap when you see green color";
            additional_text = "  ";
            icon = FontAwesomeIcons.ellipsis;
            icon_color = Colors.white;
            status = Status.Red;
          });

          timer = Timer(
              Duration(
                  seconds: 2 + generator.nextInt(3),
                  milliseconds: generator.nextInt(10) * 100), () {
            setState(() {
              start = DateTime.now();
              back_color = GreenLight;
              main_text = "  ";
              additional_text = "Its time to click";
              icon = FontAwesomeIcons.boltLightning;
              icon_color = Colors.white;
              status = Status.Green;
            });
          });
        } else if (status == Status.Red) {
          // BlueL Too soon, kill Green Future

          timer.cancel();
          setState(() {
            back_color = BlueLight;
            main_text = "Too soon";
            icon = FontAwesomeIcons.circleExclamation;
            additional_text = "Dont hurry up. click it when u c green";
            status = Status.Blue;
          });
        } else if (status == Status.Green) {
          end = DateTime.now();
          setState(() {
            back_color = BlueLight;
            icon = FontAwesomeIcons.clock;
            main_text = "${end.difference(start).inMilliseconds} ms";
            additional_text = "Tap again to start test again";
            status = Status.Blue;
          });
        }
      },
      child: Container(
          padding: const EdgeInsets.only(top: 100),
          width: double.infinity,
          height: double.infinity,
          color: back_color,
          child: Center(
              child: Column(
            children: [
              Icon(
                icon,
                color: icon_color,
                size: 150,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: FittedBox(
                  child: Text(
                    main_text,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 30, fontFamily: ""),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FittedBox(
                  child: Text(
                    additional_text,
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
              ),
            ],
          ))),
    );
  }
}

