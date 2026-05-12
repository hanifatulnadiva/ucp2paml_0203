class KatalogModel{
  final int id;
  final String merk;
  final String nama_mobil;
  final int tahun_mobil;
  final String transmisi;
  final String bahan_bakar;
  final String warna_mobil;
  final String gambar;
  final int kapasitas_penumpang;
  final int harga_mobil;
  final int kapasitas_mesin;
  final int kategoriId;




  KatalogModel({
    required this.id,
    required this.merk,
    required this.nama_mobil,
    required this.tahun_mobil,
    required this.transmisi,
    required this.bahan_bakar,
    required this.warna_mobil,
    required this.gambar,
    required this.kapasitas_penumpang,
    required this.harga_mobil,
    required this.kapasitas_mesin,
    required this.kategoriId

  });

  factory KatalogModel.fromJson(Map<String,dynamic> json){
    return KatalogModel(
      id: json['id'], 
      merk:json['merk'],
      nama_mobil: json['nama_mobil'],
      tahun_mobil:json['tahun_mobil'],
      transmisi: json['transmisi'],
      bahan_bakar:json['bahan_bakar'],
      warna_mobil:json['warna_mobil'],
      gambar:json['gambar'],
      kapasitas_penumpang: json['kapasitas_penumpang'],
      harga_mobil: json['harga_mobil'],
      kapasitas_mesin: json['kapasitas_mesin'],
      kategoriId: json['kategoriId']
    );
  }
}