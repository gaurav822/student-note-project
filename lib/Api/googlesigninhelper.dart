import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInHelper {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount> login() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();

    return account;
  }

  static Future logout() => _googleSignIn.disconnect();
}
