// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/login/model/usermodel.dart';
import 'package:ecommerce_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Sign-in process was canceled
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      UserModel user = UserModel(
        email: userCredential.user!.email!,
        uid: userCredential.user!.uid,
        username: userCredential.user!.displayName!,
        age: "",
        phoneNumber: "",
        selectedAddressIndex: 0,
        address: [],
        profileUrl: "",
        accountType: "User",
      );

      await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(user.toJson());
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    box1.put('isLogedIn', false);
    await _googleSignIn.signOut();
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = "Some error ocurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        // register user in authentication part
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        UserModel user = UserModel(
            email: email,
            uid: cred.user!.uid,
            username: username,
            age: "",
            phoneNumber: "",
            selectedAddressIndex: 0,
            address: [],
            profileUrl: "",
            accountType: "User");

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error ocurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> logOutUser() async {
    String res = "Some error ocurred";

    try {
      await _auth.signOut();

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<DocumentSnapshot> getUserDetail() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return snap;
  }

  Future<DocumentSnapshot> getUserDetailWithUid(String uid) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    return snap;
  }

  Future<DocumentSnapshot> getDiffUserDetail(String uid) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    return snap;
  }
}

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<User?> signInWithGoogle() async {
//     try {
//       // Ensure the user is signed out from GoogleSignIn
//       await _googleSignIn.signOut();

//       // Initiate the sign-in process
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return null; // The user canceled the sign-in
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       final User? user = userCredential.user;

//       if (user != null) {
//         // final userDoc =
//         //     await _firestore.collection('users').doc(user.uid).get();

//         // await _firestore.collection('users').doc(user.uid).set({
//         //   'name': user.displayName,
//         //   'email': user.email,
//         //   'photoURL': user.photoURL,
//         // });

//         UserModel users = UserModel(
//             email: user.email!,
//             uid: user.uid,
//             username: user.displayName!,
//             age: "",
//             martialStatus: "",
//             bio: "",
//             profileUrl: "");

//         await _firestore.collection("users").doc(user.uid).set(users.toJson());
//       }

//       return user;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
// }
