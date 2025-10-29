
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:funquiz_apps/models/quiz_item.dart';

class QuizService {
  // Fungsi privat untuk memuat semua data dari JSON
  Future<Map<String, dynamic>> _loadAllData() async {
    final String jsonString = await rootBundle.loadString('assets/quizzes.json');
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  // Fungsi publik untuk mendapatkan pertanyaan
  Future<List<QuizItem>> getQuestionsForCategory(String categoryName) async {
    final allData = await _loadAllData();

    if (categoryName == "Random") {
      // --- Logika untuk Kuis Random ---
      List<QuizItem> allQuestions = [];
      
      // Kumpulkan semua pertanyaan dari semua kategori
      allData.forEach((key, value) {
        final List<dynamic> questionsList = value;
        allQuestions.addAll(questionsList.map((q) => QuizItem.fromJson(q)));
      });
      
      // Acak daftarnya
      allQuestions.shuffle();
      
      // Ambil 10 pertanyaan pertama
      return allQuestions.take(10).toList();
    } else {
      // --- Logika untuk Kategori Spesifik ---
      if (allData.containsKey(categoryName)) {
        final List<dynamic> questionsList = allData[categoryName];
        // Ubah list of maps menjadi list of QuizItem
        return questionsList.map((q) => QuizItem.fromJson(q)).toList();
      } else {
        // Jika kategori tidak ditemukan di JSON
        throw Exception("Category '$categoryName' not found in quizzes.json");
      }
    }
  }
}