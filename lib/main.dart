import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Impor Google Fonts
import 'package:funquiz_apps/pages/home_page.dart';
import 'package:funquiz_apps/pages/login_page.dart';
import 'package:funquiz_apps/pages/profile_page.dart';
import 'package:funquiz_apps/pages/quiz_page.dart';

const Color kPrimaryColor = Color(0xFF4A148C); // Ungu Tua
const Color kAccentColor = Color(0xFF00ACC1); // Teal Cerah
const Color kBackgroundColor = Color(0xFFF5F5F5); // Abu-abu Sangat Muda
const Color kTextColor = Color(0xFF333333); // Abu-abu Tua (untuk teks)

void main() {
  runApp(const FunQuizApp());
}

class FunQuizApp extends StatelessWidget {
  const FunQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Quiz',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: kBackgroundColor,
        
        // Atur font default ke Poppins
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: kTextColor),
        
        // Atur skema warna baru
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kAccentColor,
          background: kBackgroundColor,
          onBackground: kTextColor,
          surface: Colors.white,
          onSurface: kTextColor,
        ),

        // Tema untuk AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: kPrimaryColor), // Ikon AppBar
          titleTextStyle: GoogleFonts.poppins( // Judul AppBar
            color: kPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),

        // Tema untuk Tombol
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentColor, // Warna aksen
            foregroundColor: Colors.white, // Teks putih
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),

        // Tema untuk Input Text
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIconColor: kPrimaryColor,
        ),

        // Tema untuk Kartu
        cardTheme: CardThemeData(
          elevation: 0, // Kita akan gunakan custom shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      // --- AKHIR TEMA BARU ---
      
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/quiz': (context) => const QuizPage(),
      },
    );
  }
}
