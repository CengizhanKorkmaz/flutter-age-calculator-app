import 'dart:ffi';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Age Calculator",
      theme: ThemeData(primarySwatch: Colors.brown),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  double age = 0.0;
  var selectedYear;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    animation = animationController;
  }

  void showPicker() {
    showDatePicker(
            context: context,
            firstDate: DateTime(1950),
            initialDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((DateTime dt) {
      setState(() {
        selectedYear = dt.year;
        calculateAge();
      });
    });
  }

  void calculateAge() {
    setState(() {
      age = (2020 - selectedYear).toDouble();
      animation = Tween<double>(begin: animation.value, end: age).animate(
          CurvedAnimation(
              parent: animationController, curve: Curves.fastOutSlowIn));
    });
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Age Calculator App"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                child: Text(selectedYear != null
                    ? selectedYear.toString()
                    : "Select your of birth"),
                borderSide: BorderSide(color: Colors.black, width: 3.0),
                onPressed: showPicker,
              ),
              Padding(padding: EdgeInsets.all(20)),
              Text(
                "Your age is ${age.toStringAsFixed(0)}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )
            ],
          ),
        ),
      ),
    );
  }
}
