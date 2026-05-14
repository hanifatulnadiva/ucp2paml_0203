import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_event.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_state.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_event.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_state.dart';
import 'package:ucp2paml_0203/ui/pages/camera_page.dart';
import 'package:ucp2paml_0203/ui/widget/customPage.dart';
import 'package:ucp2paml_0203/ui/widget/custom_dropdown.dart';
import 'package:ucp2paml_0203/ui/widget/glass_textfield.dart';

class AddKatalogPage extends StatefulWidget {
  final dynamic katalog;
  const AddKatalogPage({super.key, this.katalog});
  

  @override
  State<AddKatalogPage> createState() => _AddKatalogPageState();
}

class _AddKatalogPageState extends State<AddKatalogPage> {
  final TextEditingController namamobilController = TextEditingController();
  final TextEditingController tahunmobilController = TextEditingController();
  final TextEditingController kapasitaspenumpangController = TextEditingController();
  final TextEditingController kapasitasmesinController = TextEditingController();
  final TextEditingController hargamobilController = TextEditingController();
  final TextEditingController warnamobilController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? _selectedTransmisi; 
  String? _bahanBakar;        
  String? _selectedMerk;
  int? _selectedKategoriId;   
  String? _selectedKategoriNama; 

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _capturedImages = [];

  @override
  void initState() {
    super.initState();
    context.read<KategoriBloc>().add(FetchKategori());
    context.read<KatalogBloc>().add(FetchKatalog());

    if(widget.katalog != null){
      namamobilController.text = widget.katalog.nama_mobil;
      tahunmobilController.text = widget.katalog.tahun_mobil.toString();
      kapasitaspenumpangController.text = widget.katalog.kapasitas_penumpang.toString();
      kapasitasmesinController.text = widget.katalog.kapasitas_mesin.toString();
      hargamobilController.text = widget.katalog.harga_mobil.toString();
      warnamobilController.text = widget.katalog.warna_mobil;

      _selectedMerk = widget.katalog.merk;
      _selectedTransmisi = widget.katalog.transmisi;
      _bahanBakar = widget.katalog.bahan_bakar;
      _selectedKategoriId = widget.katalog.kategoriId;
      _selectedKategoriNama = widget.katalog.kategori?.jenis_mobil;
    }
  }

  @override
  void dispose() {
    namamobilController.dispose();
    tahunmobilController.dispose();
    kapasitaspenumpangController.dispose();
    kapasitasmesinController.dispose();
    hargamobilController.dispose();
    warnamobilController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: const Text('Kamera', style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.white),
                  title: const Text('Pilih dari Galeri', style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      if (source == ImageSource.camera && Platform.isWindows) {
        final XFile? photo = await Navigator.push<XFile?>(
          context,
          MaterialPageRoute(builder: (context) => const WindowsCameraScreen()),
        );
        if (photo != null) setState(() => _capturedImages.add(photo));
      } else {
        final XFile? photo = await _picker.pickImage(
          source: source,
          imageQuality: 50,
        );
        if (photo != null) setState(() => _capturedImages.add(photo));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() => _capturedImages.removeAt(index));
  }

  String? _validateBeforeSubmit() {
    if (_selectedMerk == null) return 'Pilih merk mobil';
    if (_selectedKategoriId == null) return 'Pilih kategori mobil';
    if (_selectedTransmisi == null) return 'Pilih transmisi';
    if (_bahanBakar == null) return 'Pilih bahan bakar';
    if (_capturedImages.isEmpty) return 'Tambahkan gambar mobil';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdate = widget.katalog != null;
    return Mainlayout(
      showAppBar: true,
      title: isUpdate ? "Update Katalog":"Tambah Katalog" ,
      showBottomNavigationBar: false,
      child: Container(
        decoration: const BoxDecoration(color: Mainlayout.primaryColor),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "FORM KATALOG",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _label("Merk Mobil"),
                          const SizedBox(height: 8),
                          CustomDropdown(
                            label: "Pilih Merk",
                            value: _selectedMerk,
                            items: const [
                              'Toyota', 'Honda', 'Mitsubishi', 'Daihatsu',
                              'Suzuki', 'Nissan', 'Mazda', 'Isuzu', 'Subaru',
                            ],
                            onChanged: (val) => setState(() => _selectedMerk = val),
                          ),
                          const SizedBox(height: 15),

                          _label("Kategori Mobil"),
                          const SizedBox(height: 8),
                          BlocBuilder<KategoriBloc, KategoriState>(
                            builder: (context, state) {
                              if (state is KategoriLoading) {
                                return const SizedBox(
                                  height: 48,
                                  child: Center(
                                    child: SizedBox(
                                      width: 20, height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (state is KategoriLoaded && state.kategoriList.isNotEmpty) {
                                return CustomDropdown(
                                  label: "Pilih Kategori",
                                  value: _selectedKategoriNama,
                                  items: state.kategoriList
                                      .map((e) => e.jenis_mobil)
                                      .toList(),
                                  onChanged: (val) {
                                    final selected = state.kategoriList
                                        .firstWhere((e) => e.jenis_mobil == val);
                                    setState(() {
                                      _selectedKategoriNama = val;
                                      _selectedKategoriId = selected.id; 
                                    });
                                  },
                                );
                              }

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.warning_amber,
                                        color: Colors.orange, size: 18),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Kategori belum tersedia',
                                      style: TextStyle(color: Colors.white70, fontSize: 13),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => context
                                          .read<KategoriBloc>()
                                          .add(FetchKategori()),
                                      child: const Icon(Icons.refresh,
                                          color: Colors.white, size: 18),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),

                          _label("Nama Mobil"),
                          const SizedBox(height: 8),
                          GlassTextField(
                            controller: namamobilController,
                            keyboardType: TextInputType.name,
                            hint: "Contoh: Avanza G",
                            validator: (value) => (value == null || value.isEmpty)
                                ? 'Nama mobil tidak boleh kosong'
                                : null,
                          ),
                          const SizedBox(height: 15),

                          _label("Tahun Mobil"),
                          const SizedBox(height: 8),
                          GlassTextField(
                            controller: tahunmobilController,
                            hint: "Contoh: 2023",
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tahun tidak boleh kosong';
                              }
                              final tahun = int.tryParse(value);
                              if (tahun == null || tahun < 1990 || tahun > 2026) {
                                return 'Tahun tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          
                          _label("Transmisi"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildTransmisiButton('otomatis', 'Matic', const Color(0xFF4CAF50)),
                              const SizedBox(width: 10),
                              _buildTransmisiButton('manual', 'Manual', const Color(0xFF9C4D82)),
                            ],
                          ),
                          const SizedBox(height: 15),

                          _label("Bahan Bakar"),
                          const SizedBox(height: 8),
                          CustomDropdown(
                            label: "Pilih Bahan Bakar",
                            value: _bahanBakar,
                            items: const ['bensin', 'diesel', 'listrik'],
                            onChanged: (val) => setState(() => _bahanBakar = val),
                          ),
                          const SizedBox(height: 15),

                          _label("Kapasitas"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: GlassTextField(
                                  controller: kapasitaspenumpangController,
                                  hint: "Penumpang",
                                  keyboardType: TextInputType.number,
                                  validator: (value){
                                    if (value == null || value.trim().isEmpty) {
                                        return 'Jumlah penumpang wajib diisi';
                                      }
                                      final penumpang = int.tryParse(value);
                                      if (penumpang == null) {
                                        return 'Harus berupa angka';
                                      }
                                      if (penumpang < 1 || penumpang > 100) {
                                        return 'Jumlah penumpang tidak valid';
                                      }
                                      return null;
                                  }
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GlassTextField(
                                  controller: kapasitasmesinController,
                                  hint: "Mesin (cc)",
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Kapasitas mesin wajib diisi';
                                    }
                                    final cc = int.tryParse(value);
                                    if (cc == null) {
                                      return 'Harus berupa angka';
                                    }
                                    if (cc < 50 || cc > 10000) {
                                      return 'CC mesin tidak masuk akal';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          _label("Harga Mobil"),
                          const SizedBox(height: 8),
                          GlassTextField(
                            controller: hargamobilController,
                            hint: "Contoh: 250000000",
                            keyboardType: TextInputType.number,
                            validator: (value) => (value == null || value.isEmpty)
                                ? 'Harga tidak boleh kosong'
                                : null,
                          ),
                          const SizedBox(height: 15),

                          _label("Warna Mobil"),
                          const SizedBox(height: 8),
                          GlassTextField(
                            controller: warnamobilController,
                            keyboardType: TextInputType.text,
                            hint: "Contoh: Putih",
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Warna wajib diisi';
                              }
                              final regex = RegExp(r'^[a-zA-Z\s]+$');
                              if (!regex.hasMatch(value)) {
                                return 'Warna hanya boleh huruf';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          _label("Gambar Mobil"),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ..._capturedImages.asMap().entries.map((entry) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(entry.value.path),
                                        width: 70, height: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0, top: 0,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(entry.key),
                                        child: const CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.close, size: 12, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  width: 70, height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                                  ),
                                  child: const Icon(Icons.add_a_photo, color: Colors.white),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          BlocConsumer<KatalogBloc, KatalogState>(
                            listener: (context, state) {
                              if (state is KatalogCreatedSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text( "Katalog berhasil disimpan!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              } else if (state is KatalogError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is KatalogLoading) {
                                return Center(
                                  child: Lottie.asset('assets/loading.json', width: 80, height: 80),
                                );
                              }

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final errMsg = _validateBeforeSubmit();
                                    if (errMsg != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(errMsg),
                                          backgroundColor: const Color.fromARGB(178, 255, 153, 0),
                                        ),
                                      );
                                      return;
                                    }

                                    if (!formKey.currentState!.validate()) return;

                                    final Map<String, dynamic> dataKatalog = {
                                      'kategoriId': _selectedKategoriId,   
                                      'merk': _selectedMerk,
                                      'nama_mobil': namamobilController.text,
                                      'tahun_mobil': int.parse(tahunmobilController.text),
                                      'transmisi': _selectedTransmisi,
                                      'bahan_bakar': _bahanBakar,  
                                      'kapasitas_penumpang': int.parse(kapasitaspenumpangController.text),
                                      'kapasitas_mesin': int.parse(kapasitasmesinController.text),
                                      'harga_mobil': int.parse(hargamobilController.text), 
                                      'warna_mobil': warnamobilController.text,            
                                      'gambar': _capturedImages.isNotEmpty 
                                        ? _capturedImages.first.path 
                                        : (isUpdate ? widget.katalog.gambar : null),
                                    };

                                    if (isUpdate) {
                                      context.read<KatalogBloc>().add(
                                        UpdateKatalog(
                                          widget.katalog.id,
                                          dataKatalog,
                                        ),
                                      );
                                      } else {
                                      context.read<KatalogBloc>().add(
                                        CreateKatalog(dataKatalog),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Mainlayout.backgroundColor.withOpacity(0.7),
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text( isUpdate ?
                                    "Simpan Perubahan":"Simpan Data" ,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                  
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  Widget _buildTransmisiButton(String value, String label, Color selectedColor) {
    bool isSelected = _selectedTransmisi == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTransmisi = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.2),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}