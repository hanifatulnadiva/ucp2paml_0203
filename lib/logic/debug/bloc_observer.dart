import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer'as developer;

class AppBlocObserver extends BlocObserver{
  @override 
  void onEvent(bloc, Object? event){
    super.onEvent(bloc, event);
    developer.log('Event:${event.runtimeType}', name:'BLoC');
  }
  @override
  void onChange(BlocBase bloc, Change change){
    super.onChange(bloc, change);
    developer.log('Change:${change.currentState.runtimeType}-> ${change.nextState.runtimeType}',
    name:'BLoC');
  }
  @override
  void onError(BlocBase bloc, Object error, StackTrace StackTrace){
    developer.log(
      'Error:$error',
      name:'BLoC',
      error: error,
      stackTrace:StackTrace,
    );
    super.onError(bloc, error, StackTrace);
  }
}