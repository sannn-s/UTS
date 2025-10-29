import 'package:flutter/material.dart';
import 'package:funquiz_apps/main.dart'; // Impor untuk mengakses warna

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: kAccentColor, // Ikon pakai warna aksen
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
