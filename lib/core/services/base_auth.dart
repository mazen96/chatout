abstract class BaseAuth {
  Future<String> signIn({String uEmail, String uPassword});
  Future<String> signUp({String uEmail, String uPassword});
}
