import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ucp2paml_0203/ui/widget/customPage.dart';

class DetailKatalog extends StatelessWidget {
  final dynamic katalog;

  const DetailKatalog({super.key, required this.katalog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mainlayout.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  child: Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      color: Colors.white.withOpacity(0.08),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        katalog.gambar != null && katalog.gambar.isNotEmpty
                            ? Image.file(
                                File(katalog.gambar),
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.directions_car,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),

                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.35),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Mainlayout.backgroundColor.withOpacity(0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        katalog.merk ?? "Merk",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        katalog.nama_mobil ?? "Nama Mobil",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Tahun Produksi: ${katalog.tahun_mobil?.toString() ?? "-"}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Mainlayout.backgroundColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "OVERVIEW",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Mobil ${katalog.nama_mobil} dengan merk ${katalog.merk} merupakan pilihan terbaik untuk kenyamanan berkendara Anda di tahun ${katalog.tahun_mobil}.",
                    style: const TextStyle(
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "SPECIFICATIONS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    children: [
                      _buildSpecItem( Icons.category,katalog.kategori?.jenis_mobil ?? "Tanpa Jenis" ),
                      _buildSpecItem(Icons.calendar_today,"Tahun ${katalog.tahun_mobil}",),
                      _buildSpecItem(Icons.airline_seat_recline_normal,"${katalog.kapasitas_penumpang} Seats",),
                      _buildSpecItem(Icons.speed,"${katalog.kapasitas_mesin} cc",),
                      _buildSpecItem(Icons.settings,katalog.transmisi ?? "-",),
                      _buildSpecItem(Icons.local_gas_station,katalog.bahan_bakar ?? "-",),
                      _buildSpecItem(Icons.color_lens,katalog.warna_mobil ?? "-",),
                      _buildSpecItem(Icons.payments,katalog.harga_mobil != null
                            ? "Rp ${(katalog.harga_mobil / 1e6).toStringAsFixed(0)}jt"
                            : "",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.maybePop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Mainlayout.backgroundColor.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "kembali",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon,color: Mainlayout.backgroundColor,size: 20,),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}