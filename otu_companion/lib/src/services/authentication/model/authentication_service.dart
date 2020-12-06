import 'package:firebase_auth/firebase_auth.dart';
import 'package:otu_companion/src/services/firebase_database_service.dart';

class AuthenticationService
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signInWithEmailAndPassword({String email, String password}) async
  {
    try
    {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }
    on FirebaseAuthException catch(e)
    {
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword({
    String email,
    String password,
    String firstName,
    String lastName,
  }) async
  {
    try
    {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then(
        (user){
          user.user.updateProfile(
            displayName: firstName + " " + lastName,
            photoURL: "",
          );
          FirebaseDatabaseService.createNewUserProfile(
            name: firstName + " " + lastName,
            id: user.user.uid,
          );
        }
      );
      return true;
    }
    on FirebaseAuthException catch(e)
    {
      return false;
    }
  }

  Future<void> updateImageURL(String imageURL) async
  {
    _firebaseAuth.currentUser.updateProfile(photoURL: imageURL);
  }

  Future<void> updateName(String name) async
  {
    _firebaseAuth.currentUser.updateProfile(displayName: name);
  }

  Future<void> updateEmailAddress(String email) async
  {
    _firebaseAuth.currentUser.updateEmail(email);
  }

  Future<void> updatePassword(String password) async
  {
    _firebaseAuth.currentUser.updatePassword(password);
  }

  Future<void> signOut() async
  {
    await _firebaseAuth.signOut();
  }
}