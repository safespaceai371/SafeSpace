// import 'package:flutter/material.dart';
// import 'package:safe_space/screens/login_screen/login_screen.dart';
// void main(){
//     runApp(
//         MaterialApp(
//             home: Scaffold(
//                 body: LoginScreen(),
//             ),
//         )
//     );
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen/login_screen.dart';
import 'screens/quiz/quiz.dart';
import 'screens/chatbot/chat_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Space',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}