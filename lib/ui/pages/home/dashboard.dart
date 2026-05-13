import 'package:flutter/material.dart';
import 'package:ucp2paml_0203/data/models/katalog_models.dart';
import 'package:ucp2paml_0203/data/repositories/katalog_repository.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_bloc.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final KatalogRepository _repository = KatalogRepository();
  final TextEditingController _searchCtrl = TextEditingController();

  List<KatalogModel> _allKatalogs = [];
  String _selectedMerk = 'Semua';
  String _searchQuery = '';
  bool _isLoading = true;

  // Merk sesuai ENUM di database
  final List<String> _merks = [
    'Semua', 'Toyota', 'Honda', 'Mitsubishi',
    'Daihatsu', 'Suzuki', 'Nissan', 'Mazda', 'Isuzu', 'Subaru',
  ];

  // Warna per merk
  final Map<String, Color> _merkColors = {
    'Toyota':    Color(0xFF378ADD),
    'Honda':     Color(0xFFD85A30),
    'Mitsubishi':Color(0xFF7F77DD),
    'Daihatsu':  Color(0xFF1D9E75),
    'Suzuki':    Color(0xFFBA7517),
    'Nissan':    Color(0xFF639922),
    'Mazda':     Color(0xFFD4537E),
    'Isuzu':     Color(0xFF5F5E5A),
    'Subaru':    Color(0xFF185FA5),
  };

  @override
  void initState() {
    super.initState();
    _loadKatalog();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadKatalog() async {
    setState(() => _isLoading = true);
    try {
      final data = await _repository.getAllKatalog();
      setState(() => _allKatalogs = data);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<KatalogModel> get _filtered => _allKatalogs.where((k) {
    final matchMerk = _selectedMerk == 'Semua' || k.merk == _selectedMerk;
    final matchSearch = _searchQuery.isEmpty ||
        k.nama_mobil.toLowerCase().contains(_searchQuery) ||
        k.merk.toLowerCase().contains(_searchQuery);
    return matchMerk && matchSearch;
  }).toList();

  int _countByMerk(String merk) => merk == 'Semua'
      ? _allKatalogs.length
      : _allKatalogs.where((k) => k.merk == merk).length;

  Color _colorFor(String merk) =>
      _merkColors[merk] ?? Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Katalog Mobil'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadKatalog,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) =>
                            setState(() => _searchQuery = v.toLowerCase().trim()),
                        decoration: InputDecoration(
                          hintText: 'Cari nama mobil...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: _merks.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final merk = _merks[i];
                          final isActive = _selectedMerk == merk;
                          final color = merk == 'Semua'
                              ? Colors.grey.shade600
                              : _colorFor(merk);
                          final count = _countByMerk(merk);

                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedMerk = merk),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? color.withOpacity(0.12)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                  color: isActive ? color : Colors.grey.shade300,
                                  width: isActive ? 1.5 : 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Dot warna merk
                                  Container(
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    merk,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isActive ? color : Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      '$count',
                                      style: TextStyle(
                                          fontSize: 10, color: color,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Text(
                        _selectedMerk == 'Semua'
                            ? 'Menampilkan ${_filtered.length} mobil'
                            : '${_filtered.length} mobil $_selectedMerk',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ),
                  ),

                  _filtered.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text('Tidak ada mobil ditemukan',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (ctx, i) => _KatalogCard(
                                mobil: _filtered[i],
                                color: _colorFor(_filtered[i].merk),
                              ),
                              childCount: _filtered.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}

class _KatalogCard extends StatelessWidget {
  final KatalogModel mobil;
  final Color color;
  const _KatalogCard({required this.mobil, required this.color});

  String _fmt(int harga) =>
      'Rp ${(harga / 1e6).round()}jt';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: mobil.gambar.isNotEmpty
                ? ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(mobil.gambar,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                            Icons.directions_car_rounded,
                            size: 40, color: color)),
                  )
                : Icon(Icons.directions_car_rounded, size: 40, color: color),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(mobil.merk,
                      style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 4),
                Text(mobil.nama_mobil,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('${mobil.tahun_mobil} · ${mobil.kategori?.jenis_mobil ?? ''}',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500)),
                const SizedBox(height: 6),
                Text(_fmt(mobil.harga_mobil),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color)),
                const SizedBox(height: 4),
                Wrap(spacing: 4, children: [
                  _tag(mobil.transmisi),
                  _tag(mobil.bahan_bakar),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 10, color: Colors.grey.shade600)),
      );
}