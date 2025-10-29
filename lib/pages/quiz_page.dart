import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:funquiz_apps/models/quiz_item.dart';
import 'package:funquiz_apps/services/quiz_service.dart';
import 'package:funquiz_apps/main.dart'; // Impor untuk mengakses warna

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizService _quizService = QuizService();
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  late Future<List<QuizItem>> _questionsFuture;
  
  String _categoryName = "Quiz";
  List<QuizItem> _questions = [];
  int _currentIndex = 0;
  bool _isFavorite = false;
  bool _isLoading = true;
  bool _isFavoriteStatusChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _loadQuizData();
    }
  }

  void _loadQuizData() {
    final categoryName = ModalRoute.of(context)!.settings.arguments as String;
    setState(() {
      _categoryName = categoryName;
      _questionsFuture = _quizService.getQuestionsForCategory(categoryName);
      _isLoading = false; 
    });
  }

  // --- Fungsi Data (Shared Preferences) ---
  void _incrementCardsRevealed() async {
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt('cardsRevealed') ?? 0;
    await prefs.setInt('cardsRevealed', currentCount + 1);
  }

  void _checkFavoriteStatus(String questionText) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favoriteQuestions') ?? [];
    setState(() {
      _isFavorite = favorites.contains(questionText);
    });
  }

  void _toggleFavorite(String questionText) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favoriteQuestions') ?? [];
    setState(() {
      if (_isFavorite) {
        favorites.remove(questionText);
        _isFavorite = false;
      } else {
        favorites.add(questionText);
        _isFavorite = true;
      }
    });
    await prefs.setStringList('favoriteQuestions', favorites);
  }
  // --- Akhir Fungsi Data ---

  // --- Fungsi Navigasi Kartu ---
  void _goToNext() {
    if (_currentIndex < _questions.length - 1) {
      if (!_cardKey.currentState!.isFront) {
        _cardKey.currentState!.toggleCard();
      }
      _checkFavoriteStatus(_questions[_currentIndex + 1].question);
      setState(() { _currentIndex++; });
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      if (!_cardKey.currentState!.isFront) {
        _cardKey.currentState!.toggleCard();
      }
      _checkFavoriteStatus(_questions[_currentIndex - 1].question);
      setState(() { _currentIndex--; });
    }
  }
  // --- Akhir Fungsi Navigasi ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_categoryName),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? Colors.red : kPrimaryColor,
            ),
            onPressed: () {
              if (_questions.isNotEmpty) {
                _toggleFavorite(_questions[_currentIndex].question);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<QuizItem>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
            return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error memuat data: ${snapshot.error}"));
          }
          if (snapshot.hasData) {
            _questions = snapshot.data!;
            if (_questions.isEmpty) return const Center(child: Text("Tidak ada pertanyaan."));

            if (!_isFavoriteStatusChecked) {
              _checkFavoriteStatus(_questions[0].question);
              _isFavoriteStatusChecked = true;
            }

            final currentQuestion = _questions[_currentIndex];
            final progress = (_currentIndex + 1) / _questions.length;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // --- Progress Bar ---
                  Text(
                    'Question ${_currentIndex + 1}/${_questions.length}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(kAccentColor), // Warna aksen
                    borderRadius: BorderRadius.circular(10),
                  ),
                  
                  Expanded(
                    child: Center(
                      child: FlipCard(
                        key: _cardKey,
                        flipOnTouch: true,
                        direction: FlipDirection.HORIZONTAL,
                        onFlip: () {
                          if (!_cardKey.currentState!.isFront) {
                            _incrementCardsRevealed();
                          }
                        },
                        // --- SISI DEPAN (PERTANYAAN) ---
                        front: _buildCardContent(
                          text: currentQuestion.question,
                          isQuestion: true,
                          bgColor: Colors.white, // Latar belakang putih
                          textColor: kTextColor, // Teks gelap
                        ),
                        // --- SISI BELAKANG (JAWABAN) ---
                        back: _buildCardContent(
                          text: currentQuestion.answer,
                          isQuestion: false,
                          bgColor: kPrimaryColor, // Latar belakang ungu
                          textColor: Colors.white, // Teks putih
                        ),
                      ),
                    ),
                  ),
                  // --- AKHIR KARTU FLIP ---

                  // --- Tombol Navigasi ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _currentIndex > 0 ? _goToPrevious : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: kPrimaryColor, // Warna primer
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _currentIndex < _questions.length - 1 ? _goToNext : null,
                          child: const Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Sesuatu yang aneh terjadi."));
        },
      ),
    );
  }

  // Widget helper baru dengan parameter warna
  Widget _buildCardContent({
    required String text,
    required bool isQuestion,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      height: 350, // Tinggi konsisten
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            spreadRadius: 4,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
          if (isQuestion)
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                'Tap to reveal',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ),
        ],
      ),
    );
  }
}
