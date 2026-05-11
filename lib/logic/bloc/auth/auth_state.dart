import 'package:equatable/equatable.dart';
import 'package:ucp2paml_0203/data/models/user_model.dart';

abstract class AuthState extends Equatable{
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState{}
class AuthLoading extends AuthState{}
class Authenticated extends AuthState{
  final UserModel user;
  Authenticated(this.user);
}
class Unauthenticated extends AuthState{}
class AuthError extends AuthState{
  final String message;
  AuthError(this.message);
}