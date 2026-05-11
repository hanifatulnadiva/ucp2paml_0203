import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2paml_0203/data/repositories/user_repository.dart';
import 'package:ucp2paml_0203/logic/bloc/auth/auth_event.dart';
import 'package:ucp2paml_0203/logic/bloc/auth/auth_state.dart';
import 'dart:developer' as developer;

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  final AuthRepository repository;
  AuthBloc({required this.repository}): super(AuthInitial()){
    on<AppStarted>((event, emit)async{
      final user=await repository.getSavedUser();
      final token=await repository.getToken();
      if(token!= null && user != null){
        emit(Authenticated(user));
      }else{
        emit (Unauthenticated());
      }
    });

    on<LoginRequested>((event,emit)async{
      emit(AuthLoading());
      developer.log('Attempting login for:${event.email}', name:'AuthBloc');
      try{
        final user = await repository.login(event.email, event.password);
        emit(Authenticated(user));
        developer.log('Status: Authenticated sebagai ${user.role}', name: 'AuthBloc');
      }catch(e){
        emit(AuthError(e.toString()));
        developer.log('Status:AuthError-$e', name:'AuthBloc');
      }
    });

    on<RegisterRequested>((event,emit)async{
      emit(AuthLoading());
      try{
        await repository.register(event.nama, event.email, event.password, event.role);
        emit(Unauthenticated());
        developer.log('Register sukses', name:'AuthBloc');
      }catch(e){
        emit(AuthError(e.toString()));
        developer.log('Register Error:$e', name:'AuthBloc');
      }
    });

    on<LogoutRequested>((event, emit) async{
      await repository.deleteToken();
      emit(Unauthenticated());
      developer.log('Logged Out', name:'AuthBloc');
    });
  }
}