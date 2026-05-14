import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSearchBar extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const GlassSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Cari...',
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),

        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),

            borderRadius:
                BorderRadius.circular(16),

            border: Border.all(
              color:
                  Colors.white.withOpacity(0.12),
            ),
          ),

          child: Row(
            children: [

              const Icon(
                Icons.search_rounded,
                color: Colors.white38,
                size: 20,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: TextField(
                  controller: controller,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),

                  onChanged: onChanged,

                  decoration: InputDecoration(
                    hintText: hintText,

                    hintStyle: const TextStyle(
                      color: Colors.white30,
                      fontSize: 14,
                    ),

                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.zero,
                  ),
                ),
              ),

              if (controller.text.isNotEmpty)
                GestureDetector(
                  onTap: onClear,

                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white38,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}