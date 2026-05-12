import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2paml_0203/data/repositories/katalog_repository.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_event.dart';
import 'package:ucp2paml_0203/logic/bloc/katalog/katalog_state.dart';

class KatalogBloc extends Bloc<KatalogEvent,KatalogState>{
  final KatalogRepository repository;
  KatalogBloc({required this.repository}): super(KatalogInitial()){
    on<FetchKatalog>((event, emit)async{
      emit(KatalogLoading());
      try{
        final list =await repository.getAllKatalog();
        emit(KatalogLoaded(list));
      }catch(e){
        emit (KatalogError(e.toString()));
      }
    });
    on<CreateKatalog>((event,emit)async{
      emit(KatalogLoading());
      try{
        await repository.createKatalog(event.data);
        emit(KatalogCreatedSuccess());
        add(FetchKatalog());
      }catch(e){
        emit(KatalogError(e.toString()));
      }
    });
    on<UpdateKatalog>((event, emit)async{
      emit(KatalogLoading());
      try{
        await repository.updateKatalog(event.id, event.data);
        emit(KatalogCreatedSuccess());
        add(FetchKatalog());
      }catch(e){
        emit(KatalogError(e.toString()));
      }
    });
    on<DeleteKatalog>((event, emit)async{
      emit(KatalogLoading());
      try{
        await repository.deleteKatalog(event.id);
        emit(KatalogCreatedSuccess());
        add(FetchKatalog());
      }catch(e){
        emit(KatalogError(e.toString()));
      }
    });
  }
}