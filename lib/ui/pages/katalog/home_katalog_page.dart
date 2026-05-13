import 'dart:ui';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_event.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_state.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_event.dart';
import 'package:ucp2paml_0203/ui/pages/home/dashboard.dart';
import 'package:ucp2paml_0203/ui/pages/katalog/add_katalog_page.dart';
import 'package:ucp2paml_0203/ui/pages/katalog/detail_katalog.dart';
import 'package:ucp2paml_0203/ui/pages/kategori/home_kategori_page.dart';
import 'package:ucp2paml_0203/ui/widget/customPage.dart';
import 'package:ucp2paml_0203/ui/widget/dialog_helper.dart';

class HomeKatalogPage extends StatefulWidget {
  const HomeKatalogPage({super.key});

  @override
  State<HomeKatalogPage> createState() => _HomeKatalogPageState();
}

class _HomeKatalogPageState extends State<HomeKatalogPage> {
  final ScrollController _scrollController = ScrollController();

  // Filter merk sesuai ENUM di database
  final List<String> _merkList = [
    'Semua', 'Toyota', 'Honda', 'Mitsubishi',
    'Daihatsu', 'Suzuki', 'Nissan', 'Mazda', 'Isuzu', 'Subaru',
  ];
  String _selectedMerk = 'Semua';

  // Warna per merk
  final Map<String, Color> _merkColors = {
    'Toyota':     Color(0xFF378ADD),
    'Honda':      Color(0xFFD85A30),
    'Mitsubishi': Color(0xFF7F77DD),
    'Daihatsu':   Color(0xFF1D9E75),
    'Suzuki':     Color(0xFFBA7517),
    'Nissan':     Color(0xFF639922),
    'Mazda':      Color(0xFFD4537E),
    'Isuzu':      Color(0xFF5F5E5A),
    'Subaru':     Color(0xFF185FA5),
  };

  Color _colorFor(String merk) => _merkColors[merk] ?? Colors.white54;

  @override
  void initState() {
    super.initState();
    context.read<KatalogBloc>().add(FetchKatalog());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Mainlayout(
      showAppBar: true,
      title: "Katalog Mobil",
      currentIndex: 1,
      onBottomNavTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          );
        }else if (index == 1) {
          return;
        }
        else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeKategoriPage()),
          );
        }
      },
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _navigateToTambah(),
            ),
          ),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTambah(),
        backgroundColor: Mainlayout.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      child: Container(
        decoration: const BoxDecoration(color: Mainlayout.primaryColor),
        child: BlocListener<KatalogBloc, KatalogState>(
          listener: (context, state) {
            if (state is KatalogCreatedSuccess) {
              _showSnackBar(context, 'Berhasil menambahkan katalog', Colors.green);
              context.read<KatalogBloc>().add(FetchKatalog());
            }
            if (state is DeleteKatalog) {
              _showSnackBar(context, 'Katalog berhasil dihapus', Colors.orange);
              context.read<KatalogBloc>().add(FetchKatalog());
            }
          },
          child: BlocBuilder<KatalogBloc, KatalogState>(
            builder: (context, state) {
              if (state is KatalogLoading) {
                return Center(
                  child: Lottie.asset('assets/loading.json', width: 200),
                );
              }

              if (state is KatalogLoaded) {
                final filtered = _selectedMerk == 'Semua'
                    ? state.katalogList
                    : state.katalogList
                        .where((k) => k.merk == _selectedMerk)
                        .toList();

                return Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: _merkList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final merk = _merkList[i];
                          final isActive = _selectedMerk == merk;
                          final color = merk == 'Semua'
                              ? Colors.white
                              : _colorFor(merk);

                          // Hitung jumlah per merk
                          final count = merk == 'Semua'
                              ? state.katalogList.length
                              : state.katalogList
                                  .where((k) => k.merk == merk)
                                  .length;

                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedMerk = merk),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.07),
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  width: isActive ? 1.5 : 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (merk != 'Semua') ...[
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                  Text(
                                    merk,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isActive
                                          ? Colors.white
                                          : Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      '$count',
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.white70),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // ── Grid Katalog ──
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.directions_car_outlined,
                                      color: Colors.white38, size: 60),
                                  const SizedBox(height: 12),
                                  Text(
                                    _selectedMerk == 'Semua'
                                        ? 'Belum ada katalog'
                                        : 'Tidak ada mobil $_selectedMerk',
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          : CustomRefreshIndicator(
                              onRefresh: () async {
                                context.read<KatalogBloc>().add(FetchKatalog());
                                await Future.delayed(
                                    const Duration(seconds: 2));
                              },
                              builder: (context, child, controller) =>
                                  Transform.translate(
                                    offset: Offset(0, 80 * controller.value),
                                    child: child,
                                  ),
                              child: GridView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.fromLTRB(
                                    16, 12, 16, 100),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.72,
                                ),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final katalog = filtered[index];
                                  return _buildGridGlassCard(context, katalog);
                                },
                              ),
                            ),
                    ),
                  ],
                );
              }

              if (state is KatalogError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.white54, size: 50),
                      const SizedBox(height: 12),
                      Text(state.message,
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<KatalogBloc>().add(FetchKatalog()),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: Text('Gagal memuat data',
                    style: TextStyle(color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGridGlassCard(BuildContext context, dynamic katalog) {
    final color = _colorFor(katalog.merk ?? '');

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<KatalogBloc>(),
                  child: DetailKatalog(katalog: katalog),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Gambar Mobil ──
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20)),
                    ),
                    child: katalog.gambar != null && katalog.gambar != ''
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                            child: Image.network(
                              "http://10.0.2.2:3000/api/${katalog.gambar}",
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.directions_car_rounded,
                                color: color,
                                size: 45,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.directions_car_rounded,
                            color: color,
                            size: 45,
                          ),
                  ),
                ),

                // ── Info Mobil ──
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge merk
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            katalog.merk ?? '',
                            style: TextStyle(
                                fontSize: 9,
                                color: color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          katalog.nama_mobil ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          katalog.Kategori?.jenis_mobil ?? 'Kategori',
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 11),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rp ${((katalog.harga_mobil ?? 0) / 1e6).round()}jt',
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _handleDelete(
                                  katalog.id, katalog.nama_mobil ?? ''),
                              child: const Icon(Icons.delete_outline,
                                  color: Colors.redAccent, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTambah() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<KatalogBloc>()),
            // Sediakan KategoriBloc dan langsung fetch
            BlocProvider(
              create: (_) => context.read<KategoriBloc>()
                ..add(FetchKategori()),
            ),
          ],
          child: const AddKatalogPage(),
        ),
      ),
    );
  }

  void _handleDelete(int id, String nama_mobil) async {
    bool? confirm = await DialogHelper.showDeleteDialog(
      context: context,
      title: "Hapus Katalog",
      content: "Yakin ingin menghapus '$nama_mobil'?",
    );
    if (confirm == true) {
      context.read<KatalogBloc>().add(DeleteKatalog(id));
    }
  }

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}