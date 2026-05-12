import 'package:equatable/equatable.dart';
import 'package:ucp2paml_0203/data/models/katalog_models.dart';

abstract class KatalogState extends Equatable{
  @override
  List<Object> get props=>[];
}

class KatalogInitial extends KatalogState{}
class KatalogLoading extends KatalogState{}

class KatalogLoaded extends KatalogState{
  final List<KatalogModel> katalogList;
  KatalogLoaded(this.katalogList);
  @override
  List<Object> get props =>[katalogList];
}

class KatalogError extends KatalogState{
  final String message;
  KatalogError(this.message);
}

class KatalogCreatedSuccess extends KatalogState{}