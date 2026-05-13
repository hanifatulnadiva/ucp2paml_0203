import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_event.dart';
import 'package:ucp2paml_0203/ui/widget/customPage.dart';
import 'package:ucp2paml_0203/ui/widget/glass_textfield.dart';

class AddKategoriSheet extends StatelessWidget {
  const AddKategoriSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController kategoriController = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Mainlayout.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Tambah Kategori",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Jenis Mobil",
                  style: TextStyle(
                    color: Colors.blueGrey[100],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GlassTextField(
                textCapitalization: TextCapitalization.characters,
                controller: kategoriController,
                hint: "Jenis Mobil",
                icon: Icons.car_repair,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Mainlayout.backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    if (kategoriController.text.isNotEmpty) {
                      context.read<KategoriBloc>().add(
                        CreateKategori({
                          "jenis_mobil": kategoriController.text.toUpperCase(),
                        }),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Simpan Kategori",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Mainlayout.textSubtitleColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
