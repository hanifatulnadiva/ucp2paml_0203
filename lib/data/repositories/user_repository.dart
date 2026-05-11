import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart'as http;
import 'dart:developer' as developer;
import 'package:ucp2paml_0203/data/models/user_model.dart';

class AuthRepository {
  final String baseUrl ="http://10.0.2.2:3000/api";
  final _storage= const FlutterSecureStorage();

  Future<void> persistToken(UserModel user, String token) async{
    await _storage.write(key: 'jwt_token', value: token);
    await _storage.write(key: 'user_data', value: jsonEncode({
    'id': user.id,
    'nama': user.nama,
    'role': user.role.value, 
  }));
  }

  Future<UserModel?> getSavedUser() async {
    String? userData = await _storage.read(key: 'user_data');
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }
  Future<void> deleteToken()async{
    await _storage.delete(key: 'jwt_token');
  }
 
  Future<UserModel> login(String email, String password)async{
    try{
      final response =await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers:{
          'Content-Type':'application/json',
          'Accept':'application/json',
        },
        body:jsonEncode({'email':email,'password':password}),
      );
      final data =jsonDecode(response.body);
      developer.log('Reponse Login:${response.body}', name:'API');
      if (response.statusCode==200){
        final responseData= jsonDecode(response.body);
        final token = responseData['token'];
        final user = UserModel.fromJson(responseData['data']);
        await persistToken(user, token);
        return user;
      }else{
        throw data['message'] ?? 'Gagal Login';
      }
    }
    catch(e){
      developer.log('Error pada Login:$e', name:'API');
      rethrow;
    }
  }

  Future<void> register(String nama, String email, String password, String role )async{
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type':'application/json',
        'Accept':'application/json'
      },
      body: jsonEncode({
        'nama':nama,
        'email':email,
        'password':password,
        'role': role
      }),
    );
    if(response.statusCode!=201 && response.statusCode!=200){
      final data =jsonDecode(response.body);
      throw data['message'] ??'Gagal register';
    }
  }
}