import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Landing(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String advice = "Click the button to get advice";
  int number = 0;

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.adviceslip.com/advice'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        advice = data['slip']['advice'];
        number = data['slip']['id'];
      });
    } else {
      throw Exception('Failed to load advice');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff202632),
      body: Stack(children: [
        Center(
          child: Stack(
            children: [
              Container(
                height: 340,
                width: 370,
                decoration: BoxDecoration(
                  color: const Color(0xff313A49),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              Positioned(
                top: -50,
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Updated here
                    children: [
                      Text(
                        "A D V I C E  #$number ",
                        style: const TextStyle(
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding:const  EdgeInsets.all(13.0),
                        child: Text(
                          '"$advice"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 27.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flex(direction: Axis.horizontal, children: [
                        Expanded(
                            child: SvgPicture.asset(
                                "images/pattern-divider-mobile.svg"))
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 560,
          left: 160,
          right: 160,
          bottom: 220,
          child: GestureDetector(
            onTap: () {
              fetchData();
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff53FFAB),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Align(
                    child: SvgPicture.asset("images/icon-dice.svg",
                        width: 25, height: 25))),
          ),
        ),
      ]),
    );
  }
}
