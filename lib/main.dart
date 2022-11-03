import 'package:flutter/material.dart';
import 'package:number_trivia_app/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme()
      ),
      home: const NumberTriviaPage(),
    );
  }
}