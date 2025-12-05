import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({super.key, required this.onChanged, this.dense = false});
  final ValueChanged<String> onChanged;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'جستجوی رمزها، سایت‌ها یا نام کاربری...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: dense ? 10 : 16, vertical: 16),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
