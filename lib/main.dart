import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:splashscreen/splashscreen.dart';

import 'models/todo.dart';
import 'view/todo/my_home_page.dart';

const String TODO_BOX = 'todo_box';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //local directory
  final document = await getApplicationSupportDirectory();
  //path
  Hive.init(document.path);
  //auto generated file
  Hive.registerAdapter(TodoAdapter());
  //open hive box
  await Hive.openBox<Todo>(TODO_BOX);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //load the page to redirect after splash screen
  Future<Widget> loadFromFuture() async {
     return Future.value(new MyHomePage());
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0XFF1C2834),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: SplashScreen(
        //redirect to page after splash screen
        //navigateAfterFuture: loadFromFuture(),

        //time it take before redirection
        seconds: 5,
        //redirect to page after splash screen
        navigateAfterSeconds: new MyHomePage(),
        //image displayed on splash
        image: Image.asset(
          "assets/IB_logo.png",
          fit: BoxFit.cover,
          color: Colors.white,
        ),
        backgroundColor: Color(0XFF1C2834),
        loaderColor: Colors.white,
        photoSize: 50.0,
      )
    );
  }
}
