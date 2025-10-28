import 'package:flutter/material.dart';

class FoodDescription extends StatefulWidget {
  final String description;
  final int maxLinesCollapsed;

  const FoodDescription({
    super.key,
    required this.description,
    this.maxLinesCollapsed = 3, // Default 3 baris
  });

  @override
  State<FoodDescription> createState() => _FoodDescriptionState();
}

class _FoodDescriptionState extends State<FoodDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AnimatedSize untuk animasi buka/tutup
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Text(
            widget.description,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.4),
            // Tampilkan semua baris jika expanded, jika tidak batasi
            maxLines: _isExpanded ? null : widget.maxLinesCollapsed,
            // Tambahkan ellipsis jika tidak expanded
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        // Tampilkan tombol hanya jika teksnya bisa diperluas/diringkas
        // Perlu cara untuk mendeteksi apakah teksnya memang lebih panjang
        // (Ini cara sederhana, mungkin perlu TextPainter untuk akurasi tinggi)
        if (widget.description.length > 100) // Asumsi sederhana panjang teks
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft, // Rata kiri
            ),
            child: Text(
              _isExpanded ? 'Baca lebih sedikit...' : 'Baca Selengkapnya...',
              style: const TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}