//? crear state

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final String nombre;
  final Email email;
  final Password password;
  final Password verifpassword;
  final String errorText;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.nombre = '',
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.verifpassword = const Password.pure(),
      this.errorText = ''});

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    String? nombre,
    Email? email,
    Password? password,
    Password? verifpassword,
    String? errorText,
  }) =>
      RegisterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          nombre: nombre ?? this.nombre,
          email: email ?? this.email,
          password: password ?? this.password,
          verifpassword: verifpassword ?? this.verifpassword,
          errorText: errorText ?? this.errorText);

  @override
  String toString() {
    return '''
    RegisterFormState:
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      nombre: $nombre
      email: $email,
      password: $password,
      verifpassword: $verifpassword
      errorText: $errorText
  ''';
  }
}
//? implementar notifier

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(RegisterFormState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;
    print(state);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final nombre = state.nombre;
    //Validar si las password coinciden, sino enviar un mensaje
    final passwordsMatch = state.password == state.verifpassword;
    final isNombreValid = state.nombre.isNotEmpty;
    if (!passwordsMatch) {
      state = state.copyWith(errorText: 'Las contraseñas no coinciden');
      return Text(state.errorText);
    }
    if (!isNombreValid) {
      state = state.copyWith(errorText: 'El nombre es invalido');
      return Text(state.errorText);
    }
    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        nombre: nombre,
        isValid: Formz.validate([email, password]));
  }
}

//?3 consumir StateNotifierProvider

final registerFormProvider =
//el autodispose en el login es importante para borrar info una vez se cierra la pantalla.
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  return RegisterFormNotifier();
});
