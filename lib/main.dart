import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2paml_0203/data/repositories/katalog_repository.dart';
import 'package:ucp2paml_0203/data/repositories/kategori_repository.dart';
import 'package:ucp2paml_0203/data/repositories/user_repository.dart';
import 'package:ucp2paml_0203/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2paml_0203/logic/bloc/kategori/kategori_bloc.dart';
import 'package:ucp2paml_0203/ui/pages/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(repository: AuthRepository()),
        ),
        BlocProvider(
          create: (context) => KategoriBloc(repository: KategoriRepository()),
        ),
        BlocProvider(
          create: (context) => KatalogBloc(repository: KatalogRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
      ),
    );
  }
}
