import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ucp2paml_0203/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/auth/auth_event.dart';
import 'package:ucp2paml_0203/logic/bloc/auth/auth_state.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_state.dart';
import 'package:ucp2paml_0203/ui/pages/auth/login_page.dart';
import 'package:ucp2paml_0203/ui/pages/katalog/detail_katalog.dart';
import 'package:ucp2paml_0203/ui/pages/katalog/home_katalog_page.dart';
import 'package:ucp2paml_0203/ui/pages/kategori/home_kategori_page.dart';
import 'package:ucp2paml_0203/ui/widget/customPage.dart';
import 'package:ucp2paml_0203/ui/widget/dialog_helper.dart';
import 'package:ucp2paml_0203/ui/widget/search_bar.dart';

const Map<String, Color> _merkColors = {
  'Toyota': Color(0xFF378ADD),
  'Honda': Color(0xFFD85A30),
  'Mitsubishi': Color(0xFF7F77DD),
  'Daihatsu': Color(0xFF1D9E75),
  'Suzuki': Color(0xFFBA7517),
  'Nissan': Color(0xFF639922),
  'Mazda': Color(0xFFD4537E),
  'Isuzu': Color(0xFF5F5E5A),
  'Subaru': Color(0xFF185FA5),
};

Color _colorFor(String? merk) =>
    _merkColors[merk ?? ''] ?? const Color(0xFF888888);

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedMerk = 'Semua';
  final PageController _pageCtrl = PageController(viewportFraction: 0.85);
  int _currentCarousel = 0;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    String role = 'user';

    if (authState is Authenticated) {
      role = (authState.user.role ?? 'user')
          .toString()
          .toLowerCase();
    }
    final bool isAdmin = role.contains('admin');

    return BlocBuilder<KatalogBloc, KatalogState>(
      builder: (context, state) {
        final List allKatalog = state is KatalogLoaded ? state.katalogList : [];
        final List carouselItems = allKatalog.take(4).toList();
        final List filtered = allKatalog.where((k) {
          final matchMerk = _selectedMerk == 'Semua' || k.merk == _selectedMerk;
          final matchSearch =
              _searchQuery.isEmpty ||
              (k.nama_mobil ?? '').toLowerCase().contains(_searchQuery) ||
              (k.merk ?? '').toLowerCase().contains(_searchQuery);
          return matchMerk && matchSearch;
        }).toList();

        return Mainlayout(
          showAppBar: false,
          currentIndex: 0,
          showBottomNavigationBar: isAdmin,
          onBottomNavTap: (index) {
            if (!isAdmin) return;
            if (index == 0) return;
            if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeKatalogPage()),
              );
            }
            if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeKategoriPage()),
              );
            }
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                       CircleAvatar(
                        radius: 25,
                        backgroundColor: isAdmin
                            ? const Color(0xFF378ADD)
                            : Colors.green,
                        child: Text(
                          isAdmin ? 'A' : 'C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selamat Datang',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            isAdmin ? 'Admin' : 'Customer',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showLogoutDialog(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: GlassSearchBar(
                    controller: _searchCtrl,
                    hintText: 'Cari nama atau merk mobil...',
                    onChanged: (v) =>
                        setState(() => _searchQuery = v.toLowerCase().trim()),
                    onClear: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
                ),

                _buildSectionHeader(
                  'Merk',
                  '',
                ),

                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      _buildFilterItem(
                        'Semua',
                        Icons.apps_rounded,
                        const Color(0xFF5F5E5A),
                      ),
                      ..._merkColors.entries.map(
                        (e) => _buildFilterItem(
                          e.key,
                          Icons.directions_car_filled,
                          e.value,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildSectionHeader(
                  'Mobil Terbaru',
                  '${carouselItems.length} unit',
                ),
                state is KatalogLoading
                    ? _buildLoadingState()
                    : carouselItems.isEmpty
                    ? _buildEmptyState('Belum ada katalog')
                    : _buildCarousel(context, carouselItems),

                if (carouselItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildDotIndicator(carouselItems.length),
                  ),

                _buildSectionHeader(
                  'Semua Katalog',
                  '${filtered.length} mobil',
                ),
                state is KatalogLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                    ? _buildEmptyState('Data tidak ditemukan')
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.78,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemBuilder: (ctx, i) =>
                              _buildKatalogCard(ctx, filtered[i]),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterItem(String label, IconData icon, Color color) {
    bool isSelected = _selectedMerk == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedMerk = label),
      child: Container(
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : color.withOpacity(0.1),
                border: Border.all(
                  color: isSelected ? Colors.white24 : Colors.transparent,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white38,
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(count, style: const TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 200,
      child: Center(child: Lottie.asset('assets/loading.json', width: 80)),
    );
  }

  Widget _buildEmptyState(String msg) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(msg, style: const TextStyle(color: Colors.white38)),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, List items) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageCtrl,
        itemCount: items.length,
        onPageChanged: (i) => setState(() => _currentCarousel = i),
        itemBuilder: (_, i) {
          final k = items[i];
          final color = _colorFor(k.merk);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailKatalog(katalog: k)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Container(color: color.withOpacity(0.2)),
                    if (k.gambar != null && k.gambar != '')
                      Positioned.fill(
                        child: Image.file(File(k.gambar), fit: BoxFit.cover),
                      ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              k.merk ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            k.nama_mobil ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp ${((k.harga_mobil ?? 0) / 1e6).round()}jt · ${k.tahun_mobil ?? ''}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDotIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == _currentCarousel;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _buildKatalogCard(BuildContext context, dynamic k) {
    final color = _colorFor(k.merk);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailKatalog(katalog: k)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: k.gambar != null && k.gambar != ''
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Image.file(File(k.gambar), fit: BoxFit.cover),
                      )
                    : Icon(Icons.directions_car_filled, color: color, size: 40),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      k.merk ?? '',
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      k.nama_mobil ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      k.kategori?.jenis_mobil ?? "Sedan",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Rp ${((k.harga_mobil ?? 0) / 1e6).round()}jt',
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    bool? keluar = await DialogHelper.showDeleteDialog(
      context: context,
      title: "Keluar Aplikasi",
      content: "Yakin mau keluar?",
      isDelete: false,
    );
    if (keluar == true) {
    context.read<AuthBloc>().add(LogoutRequested());

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
  }
}
