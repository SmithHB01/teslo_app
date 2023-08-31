import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(
    authRepository: authRepository
  );
});


class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;

  AuthNotifier({
    required this.authRepository
  }): super( AuthState() );
  
  Future<void> loginUser( String email, String password ) async {  
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = await authRepository.login(email, password);
      _setloggedUser( user );

    } on CustomError catch (e) {
      logout( e.message );
    } catch (e){
      logout( 'Error no controlado' );
    }

  }

  void registerUser( String email, String password ) async { 

  }

  void checkAuthStatus() async { 

  }

  void _setloggedUser( User user) {
    // Todo:
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.auhetnticated,
    );

  }

  Future<void> logout( String? errorMessage) async {
    // Todo:
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage
    );


  }

}

enum AuthStatus { checking, auhetnticated, notAuthenticated}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage

  }) => AuthState(
    authStatus: authStatus = this.authStatus,
    user: user = this.user,
    errorMessage: errorMessage ?? this.errorMessage 
  );

}