import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackify_project/pages/register_page.dart';
import 'package:trackify_project/pages/sign_in_page.dart';
import 'pages/home_page.dart';
import 'pages/add_habit_page.dart';
import 'pages/habit_detail_page.dart';
import 'models/habit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackify',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: FutureBuilder<User?>(
        future: _getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            // User is signed in
            return const HomePage();
          } else {
            // User is not signed in
            return const SignInPage();
          }
        },
      ),
      routes: {
        '/add': (context) => const AddHabitPage(),
        '/habit_detail': (context) {
          final habit = ModalRoute.of(context)!.settings.arguments as Habit;
          return HabitDetailPage(
            habit: habit,
            onHabitUpdated: (updatedHabit) {
              (context as Element).markNeedsBuild();
            },
          );
        },
        '/sign_in': (context) => const SignInPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }
}
