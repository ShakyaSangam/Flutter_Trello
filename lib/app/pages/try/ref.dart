import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController;

  List<Container> pages = [
    Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        color: Colors.redAccent),
    Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        color: Colors.purpleAccent),
    Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        color: Colors.greenAccent)
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.8,
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: 50.0,
        ),
        child: PageView.builder(
          controller: pageController,
          itemCount: pages.length,
          itemBuilder: (BuildContext context, int index){
            return pages[index];
          },
        ),
      ),
    );
  }
}
