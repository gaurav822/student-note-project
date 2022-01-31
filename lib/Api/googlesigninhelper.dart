import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInHelper {
  static final _googleSignIn = GoogleSignIn();
  // scopes: [
  //   'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  // ],
  // clientId:
  //     "696907137561-i6effp8d84jpfntjudm0jq9rb6n4vetr.apps.googleusercontent.com");

  static Future<GoogleSignInAccount> login() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();

    return account;
  }

  static Future logout() => _googleSignIn.disconnect();
}
