import 'package:teslo_shop/features/auth/domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

//recibo DataSource opcional, si lo tengo lo uso, sino lo creo.
  AuthRepositoryImpl({AuthDataSource? dataSource})
      : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullname) {
    return dataSource.register(email, password, fullname);
  }
}
