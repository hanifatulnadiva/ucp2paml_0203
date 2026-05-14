import 'dart:ui';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_event.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_state.dart';
import 'package:ucp2paml_0203/ui/pages/home/Dashboard_admin.dart';
import 'package:ucp2paml_0203/ui/pages/katalog/home_katalog_page.dart';
import 'package:ucp2paml_0203/ui/pages/kategori/add_kategori.dart';
import 'package:ucp2paml_0203/ui/widget/customPage.dart';
import 'package:ucp2paml_0203/ui/widget/dialog_helper.dart';

class HomeKategoriPage extends StatefulWidget {
  const HomeKategoriPage({super.key});

  @override
  State<HomeKategoriPage> createState() => _HomeKategoriPageState();
}



class _HomeKategoriPageState extends State<HomeKategoriPage> {

  @override
  void initState() {
    super.initState();
    context.read<KategoriBloc>().add(FetchKategori());
  }

  @override
  Widget build(BuildContext context) {
    return Mainlayout(
      title: 'Kategori Mobil',
      showBackButton: false,
      currentIndex: 2,
      onBottomNavTap: (index){
        if(index==0){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_)=> const DashboardAdmin())
          );
        }if(index == 1){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_)=> const HomeKatalogPage())
          );
        }if(index==2){
          return;
        }
      },
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            radius: 25, 
            backgroundColor: Colors.white.withOpacity(0.2), 
            child: IconButton(
              iconSize: 20, 
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _showAddBottomSheet,
            ),
          ),
        ),
      ],
      
      floatingActionButton: FloatingActionButton(    
        backgroundColor: Mainlayout.accentorange,    
        onPressed:_showAddBottomSheet,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Mainlayout.primaryColor
        ),

        child: BlocListener<KategoriBloc, KategoriState>(
          listener: (context, state) {
            if (state is KategoriCreatedSuccess) {
              _showSnackBar(context, 'Operasi berhasil', Colors.green);
              context.read<KategoriBloc>().add(FetchKategori());
            } else if (state is KategoriError) {
              _showSnackBar(context, state.message, Colors.red);
              context.read<KategoriBloc>().add(FetchKategori());
            }
          },

          child: BlocBuilder<KategoriBloc, KategoriState>(
            builder: (context, state) {

              if (state is KategoriLoading) {
                return Center(
                  child: Lottie.asset('assets/loading.json', width: 200),
                );
              }

              if (state is KategoriLoaded) {
                if (state.kategoriList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum Ada Kategori mobil',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return CustomRefreshIndicator(
                  onRefresh: () async {
                    context.read<KategoriBloc>().add(FetchKategori());
                    await Future.delayed(const Duration(seconds: 2));
                  },

                  builder: (context, child, controller) {
                    return Transform.translate(
                      offset: Offset(0, 80 * controller.value),
                      child: child,
                    );
                  },

                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),

                    itemCount: state.kategoriList.length,

                    itemBuilder: (context, index) {
                      final kategori =
                          state.kategoriList[index];

                      return _buildGlassCard(context, kategori);
                    },
                  ),
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Gagal memuat data",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<KategoriBloc>().add(FetchKategori());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  Widget _buildGlassCard(BuildContext context, dynamic kategori) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius:BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 101),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.car_rental, color: Colors.white, ),
              ),
              title: Text(
                kategori.jenis_mobil,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _handleDelete(kategori.id, kategori.jenis_mobil),
              ),
            )
          ),
        ),
      ),
    );
  }

  void _handleDelete(int id, String jenis_mobil) async {
    bool? confirm = await DialogHelper.showDeleteDialog(
      context: context,
      title: "Konfirmasi Hapus",
      content: "Apakah kamu yakin ingin menghapus jenis mobil '$jenis_mobil'?",
    );

    if (confirm == true) {
      print("Menghapus data dengan ID: $id");
      
      context.read<KategoriBloc>().add(DeleteKategori(id));

      context.read<KategoriBloc>().add(FetchKategori());
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kategori berhasil dihapus"), backgroundColor: Colors.green),
      );
    }
  }

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
      ),
    );
  }

  void _showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent, 
      builder: (context) => BlocProvider.value(
        value: this.context.read<KategoriBloc>(), 
        child: const AddKategoriSheet(),
      ),
    );
  }
}