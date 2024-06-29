import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String getcurrentuser() 
  {
    return auth.currentUser!.uid;
  }
  Future<UserCredential> register(
      String newemail, String newpassword, String Username) async {
    try {
      UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: newemail, password: newpassword);
      _firestore.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email':cred.user!.email,
        'username':Username,
        'password':newpassword,
      });
      return cred;
    } on FirebaseAuthException catch (e) {
      throw (Exception(e.code),);
    }
  }

  Future<UserCredential> SignIn(String newemail, String newpassword) async {
    try {
      UserCredential cred = await auth.signInWithEmailAndPassword(
          email: newemail, password: newpassword);
      return cred;
    } on FirebaseAuthException catch (e) {
      throw (Exception(e.code),);
    }
  }
  Future<void> signout() async
  {
    await auth.signOut();
  }
}
