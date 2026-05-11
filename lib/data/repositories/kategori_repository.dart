import 'dart:convert';

import 'package:ucp2paml_0203/data/models/kategori_model.dart';
import 'package:ucp2paml_0203/data/providers/storage_provider.dart';
import 'package:http/http.dart'as http;

class  KategoriRepository {
  final String baseUrl="http://10.0.2.2:3000/api";
  final StorageProvider storage=StorageProvider();

  Future<List<KategoriModel>>getAllKategori()async{
    final token= await storage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/kategori/'),
      headers:{
        'Accept':'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if(response.statusCode==200){
      final Map<String, dynamic>body=jsonDecode(response.body);
      final List<dynamic>data=body['data'];
      return data.map((item)=> KategoriModel.fromJson(item)).toList();
    }else{
      throw Exception("Gagal mengambil data");
    }
  }

  Future<void> createKategori(Map<String, dynamic> kategoriData) async{
    final token=await storage.getToken();
    final response=await http.post(
      Uri.parse('$baseUrl/kategori/'),
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $token', 
        'Accept':'application/json'
        },
        body:jsonEncode(kategoriData)
    );
    if(response.statusCode!=201 && response.statusCode!=200){
      final data= jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menambahkan data kategori';
    }
  }
  Future<void> updateKategori(int id, Map<String,dynamic> kategoriData) async{
    final token =await storage.getToken();
    final response=await http.put(
      Uri.parse('$baseUrl/kategori/$id'),
      headers:{
        'Content-Type':'application/json',
        'Accept':'application/json',
        'Authorization':'Bearer $token', 
      },
      body: jsonEncode(kategoriData)
    );
    if(response.statusCode!=200){
      final data =jsonDecode(response.body);
      throw data['message']??'Gagal memperbarui data kategori';
    }
  }
  Future<void>deleteKategori(int id)async{
    final token=await storage.getToken();
    final response=await http.delete(
      Uri.parse('$baseUrl/kategori/$id'),
      headers:{
        'Accept':'application/json',
        'Authorization':'Bearer $token'
      },
    );
    if(response.statusCode!=200 && response.statusCode!=204){
      final data =jsonDecode(response.body);
      throw data ['message']??'Gagal menghapus data kategori';
    }
  }
}
