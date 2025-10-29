import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:funquiz_apps/main.dart'; // Impor untuk mengakses warna
import 'package:funquiz_apps/widgets/stat_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, int>> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    int cardsRevealed = prefs.getInt('cardsRevealed') ?? 0;
    List<String> favorites = prefs.getStringList('favoriteQuestions') ?? [];
    int favoritesCount = favorites.length;
    
    return {
      'cards': cardsRevealed,
      'favorites': favoritesCount,
    };
  }

  @override
  Widget build(BuildContext context) {
    const String userName = 'Ahsan Azhari';
    const String userEmail = 'aanahsan46@gamil.com';
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- Info Profil ---
            CircleAvatar(
              radius: 50,
              backgroundColor: kPrimaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person_rounded,
                size: 60,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),

            // --- KARTU STATISTIK DINAMIS ---
            FutureBuilder<Map<String, int>>(
              future: _loadProfileData(),
              builder: (context, snapshot) {
                // ... (Logika FutureBuilder tetap sama) ...
                final int cards = snapshot.data?['cards'] ?? 0;
                final int favs = snapshot.data?['favorites'] ?? 0;
                
                String cardsValue = snapshot.connectionState == ConnectionState.waiting ? '...' : cards.toString();
                String favsValue = snapshot.connectionState == ConnectionState.waiting ? '...' : favs.toString();

                return Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Cards Revealed',
                        value: cardsValue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Favorites',
                        value: favsValue,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // --- Menu Favorit (Desain Ulang) ---
            _buildProfileMenuItem(
              context,
              icon: Icons.favorite_rounded,
              color: Colors.red.shade300,
              title: 'Favorite Cards',
              onTap: () {
                // Aksi ke halaman favorit
              },
            ),
            const SizedBox(height: 12),
            _buildProfileMenuItem(
              context,
              icon: Icons.settings,
              color: Colors.grey.shade500,
              title: 'Settings',
              onTap: () {},
            ),
            
            const Spacer(),

            // --- Tombol Logout (Desain Ulang) ---
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                },
                icon: Icon(Icons.logout_rounded, color: Colors.red.shade700),
                label: Text(
                  'Logout',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  backgroundColor: Colors.red.withOpacity(0.05)
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk item menu profil
  Widget _buildProfileMenuItem(BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
