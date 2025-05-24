import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/create_task_page.dart';
import 'providers/task_provider.dart';

// Defina nomes de rota
const String homeRoute = '/';
const String createTaskRoute = '/createTask';
// const String viewTaskRoute = '/viewTask';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(), // Cria a instância do Provider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App de Tarefas',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF202020),
        textTheme: TextTheme(
          headlineMedium: GoogleFonts.interTight(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          labelLarge: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          titleSmall: GoogleFonts.interTight(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          // Estilo padrão para TextFormFields
          labelStyle: GoogleFonts.interTight(
            color: Colors.white70,
            fontSize: 18,
          ),
          hintStyle: GoogleFonts.inter(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF2F2D2D),
          border: OutlineInputBorder(
            // Borda padrão
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            // Borda quando não focado
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            // Borda quando focado
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: homeRoute, // Define a rota inicial
      routes: {
        homeRoute: (context) => const HomePageWidget(),
        createTaskRoute: (context) => const CreateTaskWidget(),
        // viewTaskRoute: (context) => const ViewTaskWidget(),
      },
    );
  }
}
