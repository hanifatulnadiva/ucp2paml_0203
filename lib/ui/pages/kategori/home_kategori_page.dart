import 'dart:ui';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_event.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_state.dart';
import 'package:ucp2paml_0203/ui/pages/kategori/add_kategori_page.dart';
import 'package:ucp2paml_0203/ui/pages/kategori/update_kategori_page.dart';
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
    // Panggil data kategori di sini!
    context.read<KategoriBloc>().add(FetchKategori());
  }

  @override
  Widget build(BuildContext context) {
    return Mainlayout(
      title: 'KATEGORI',
      showAppBar: true,
      showBottomNavigationBar: true,
      actions: [
        IconButton(icon:const Icon(Icons.add_box_outlined), 
        onPressed:(){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context)=> const AddKategoriPage()
            ));
        })],
      floatingActionButton: FloatingActionButton(onPressed: 
        (){
          Navigator.push(context,
          MaterialPageRoute(builder: (content)=> BlocProvider.value(
            value: context.read<KategoriBloc>(),
              child: const AddKategoriPage()
          )));
        }
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A237E), Color(0xFF4D1457)],
              ),
            ),
          ),
          BlocListener<KategoriBloc, KategoriState>(
            listener: (context,state){
              if(state is KategoriCreatedSuccess){
                _showSnackBar(context, 'Operasi berhasil', Colors.green);
              }
              else if(state is KategoriError){
                _showSnackBar (context, state.message, Colors.red);
              }
            },
            child: BlocBuilder<KategoriBloc, KategoriState>(
              builder: (context, state){
                if(state is KategoriLoading){
                  return Center(
                    child: Lottie.asset('assets/loading.json', width: 200),);
                }else if(state is KategoriLoaded){
                  if(state.kategoriList.isEmpty){
                    return const Center(
                      child: Text('Belum Ada Kategori mobil',
                      style: TextStyle(color:Colors.blueGrey),),
                    );
                  }
                  return CustomRefreshIndicator(
                  onRefresh: () async {
                    context.read<KategoriBloc>().add(FetchKategori());
                    await Future.delayed(const Duration(seconds: 2));
                  },
                  builder: (context, child, controller) {
                    return AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) {
                        return Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            if (!controller.isIdle)
                              Positioned(
                                top: 50 * controller.value,
                                child: Image.asset(
                                  'assets/loading.json',
                                  height: 80,
                                ),
                              ),
                            Transform.translate(
                              offset: Offset(0, 100 * controller.value),
                              child: child,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 100, 16, 100),
                    itemCount: state.kategoriList.length,
                      itemBuilder: (context,index) {
                        final kategori = state.kategoriList[index];
                        return _buildGlassCard(context, kategori);
                      },
                    ),
                  );
                }
              return const Center(child:Text("Gagal memuat data"));
              }  
            )
          )
        ],
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
              onTap: () {
                // final bloc = context.read<KategoriBloc>();
                // Navigator.push(context, 
                //   MaterialPageRoute(
                //     builder: (innerContext)=>BlocProvider.value(
                //       value:bloc,
                //       child: EditKategoriPage(Kategori : kategori),
                //     )
                //   )
                // );
              },
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
        content: "Apakah kamu yakin ingin menghapus layanan '$jenis_mobil'?",
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
}