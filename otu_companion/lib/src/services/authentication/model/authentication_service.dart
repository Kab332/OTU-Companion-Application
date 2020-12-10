import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:otu_companion/src/services/firebase_database_service.dart';

//import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  /*final GoogleSignIn _googleSignIn = GoogleSignIn();*/

  User getCurrentUser()
  {
    _firebaseAuth.currentUser.reload();
    return _firebaseAuth.currentUser;
  }

  Future<String> signInWithEmailAndPassword({String email, String password}) async
  {
    try
    {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

  Future<String> signUpWithEmailAndPassword({
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
          if (user != null)
          {
            user.user.updateProfile(
              displayName: firstName + " " + lastName,
              photoURL: "",
            );

            FirebaseDatabaseService.createNewUserProfile(
              name: firstName + " " + lastName,
              id: user.user.uid,
            );
          }
        }
      );
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

  // TODO: Implement Google Authentication System (with Account Management-Registration) and enable SHA fingerprint
  /*
  Future<String> signInWithGoogle() async
  {
    try
    {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }
  */

  Future<String> updateProfile({String name, String imageURL, BuildContext context}) async
  {
    try
    {
      await _firebaseAuth.currentUser.updateProfile(displayName: name, photoURL: imageURL);
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

  Future<String> updateImageURL(String imageURL) async
  {
    try
    {
      _firebaseAuth.currentUser.updateProfile(photoURL: imageURL);
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

  Future<String> updateName(String name) async
  {
    try
    {
      _firebaseAuth.currentUser.updateProfile(displayName: name);
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

  Future<String> updateEmailAddress(String email) async
  {
    try
    {
      await _firebaseAuth.currentUser.verifyBeforeUpdateEmail(email);
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

  Future<String> updatePassword() async
  {
    try
    {
      await _firebaseAuth.sendPasswordResetEmail(email: _firebaseAuth.currentUser.email);
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

  Future<String> signOut() async
  {
    try
    {
      await _firebaseAuth.signOut();
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }
}