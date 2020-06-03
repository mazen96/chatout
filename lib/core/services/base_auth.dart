abstract class BaseAuth {
  Future<void> signIn({String uEmail, String uPassword});
  Future<String> signUp({String uEmail, String uPassword});
  Future signOut();
}
