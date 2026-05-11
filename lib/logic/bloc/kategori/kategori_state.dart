import 'package:equatable/equatable.dart';
import 'package:ucp2paml_0203/data/models/kategori_model.dart';

abstract class KategoriState extends Equatable{
  @override
  List<Object> get props=>[];
}

class KategoriInitial extends KategoriState{}
class KategoriLoading extends KategoriState{}

class KategoriLoaded extends KategoriState{
  final List<KategoriModel> kategoriList;
  KategoriLoaded(this.kategoriList);
  @override
  List<Object> get props =>[kategoriList];
}

class KategoriError extends KategoriState{
  final String message;
  KategoriError(this.message);
}

class KategoriCreatedSuccess extends KategoriState{}