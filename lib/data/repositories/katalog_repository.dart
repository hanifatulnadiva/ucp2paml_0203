import 'dart:convert';
import 'package:ucp2paml_0203/data/models/katalog_models.dart';
import 'package:ucp2paml_0203/data/providers/storage_provider.dart';
import 'package:http/http.dart'as http;

class  KatalogRepository {
  final String baseUrl="http://10.0.2.2:3000/api";
  final StorageProvider storage=StorageProvider();

  Future<List<KatalogModel>>getAllKatalog()async{
    final token= await storage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/katalog/'),
      headers:{
        'Accept':'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if(response.statusCode==200){
      final Map<String, dynamic>body=jsonDecode(response.body);
      final List<dynamic>data=body['data'];
      return data.map((item)=> KatalogModel.fromJson(item)).toList();
    }else{
      throw Exception("Gagal mengambil data");
    }
  }

  Future<List<KatalogModel>>getKatalogById(int id, Map<String,dynamic> katalogData)async{
    final token= await storage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/katalog/$id'),
      headers:{
        'Accept':'application/json',
        'Authorization':'Bearer $token',
      },
    );
    if(response.statusCode==200){
      final Map<String, dynamic>body=jsonDecode(response.body);
      final List<dynamic>data=body['data'];
      return data.map((item)=> KatalogModel.fromJson(item)).toList();
    }else{
      throw Exception("Gagal mengambil detail katalog");
    }
  }

  Future<void> createKatalog(Map<String, dynamic> katalogData) async{
    final token=await storage.getToken();
    final response=await http.post(
      Uri.parse('$baseUrl/katalog/'),
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $token', 
        'Accept':'application/json'
        },
        body:jsonEncode(katalogData)
    );
    if(response.statusCode!=201 && response.statusCode!=200){
      final data= jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menambahkan data katalog';
    }
  }
  Future<void> updateKatalog(int id, Map<String,dynamic> katalogData) async{
    final token =await storage.getToken();
    final response=await http.put(
      Uri.parse('$baseUrl/katalog/$id'),
      headers:{
        'Content-Type':'application/json',
        'Accept':'application/json',
        'Authorization':'Bearer $token', 
      },
      body: jsonEncode(katalogData)
    );
    if(response.statusCode!=200){
      final data =jsonDecode(response.body);
      throw data['message']??'Gagal memperbarui data katalog';
    }
  }
  Future<void>deleteKatalog(int id)async{
    final token=await storage.getToken();
    final response=await http.delete(
      Uri.parse('$baseUrl/katalog/$id'),
      headers:{
        'Accept':'application/json',
        'Authorization':'Bearer $token'
      },
    );
    if(response.statusCode!=200 && response.statusCode!=204){
      final data =jsonDecode(response.body);
      throw data ['message']??'Gagal menghapus data katalog';
    }
  }
}
