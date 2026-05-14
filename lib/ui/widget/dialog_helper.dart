import 'package:flutter/material.dart';
import 'package:ucp2paml_0203/ui/widget/customPage.dart';

class DialogHelper {
  static Future<bool?> showDeleteDialog({
    required BuildContext context,
    required String title,
    required String content,
    bool isDelete = true,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Mainlayout.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(content, style: TextStyle(color: Colors.white60)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(isDelete?"Hapus": "Keluar"),
          ),
        ],
      ),
    );
  }
}