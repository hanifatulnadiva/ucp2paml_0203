class KategoriModel{
  final int id;
  final String jenis_mobil;

  KategoriModel({
    required this.id,
    required this.jenis_mobil,
  });

  factory KategoriModel.fromJson(Map<String,dynamic> json){
    return KategoriModel(
      id: json['id'], 
      jenis_mobil: json['jenis_mobil']
    );
  }
}