import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthSignInRequested>(_signIn);
    on<AuthSignUpRequested>(_signUp);
    on<AuthSignOutRequested>(_signOut);
  }

  Future<void> _signIn(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _signUp(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _signOut(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _firebaseAuth.signOut();
    emit(AuthInitial());
  }
}
