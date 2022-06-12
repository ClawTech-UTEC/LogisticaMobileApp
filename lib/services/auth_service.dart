import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = new AuthService.internal();
  factory AuthService() => _instance;
  AuthService.internal();

  Future<int> getIdUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idUsuario')!;
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token')!;
  }
}
