import 'package:advance_employee_management/authentication/sign_in_page.dart';
import 'package:advance_employee_management/locator.dart';

import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  final Future<FirebaseApp> initialization = Firebase.initializeApp();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final storage = const FlutterSecureStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String? user() {
    final User user = auth.currentUser!;
    return user.email!;
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try {
          await auth.signInWithCredential(credential);

          locator<NavigationService>().globalNavigateTo(AdLayOutRoute, context);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await auth.signOut();
    await storage.delete(key: "token");
  }

  validateCurrentPassword(
      String password, String newPassword, BuildContext context) async {
    var authCredentials = EmailAuthProvider.credential(
        email: auth.currentUser!.email!, password: password);

    auth.currentUser!
        .reauthenticateWithCredential(authCredentials)
        .then((value) {
      auth.currentUser!.updatePassword(newPassword).then((_) async {
        await EasyLoading.showSuccess('Change Success!');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const SignInPage()),
            (route) => false);
      }).catchError((error) {
        AuthClass().showSnackBar(context, "Not success");
      });
    }).catchError((error) {
      EasyLoading.showError(
          "Current Password is  incorrect, Please input again!!");
    });
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingtoken]) {
      showSnackBar(context, "Vertification Code send on the phone number");
      setData(verificationId);
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      showSnackBar(context, "Time out");
    };
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signWithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      await auth.signInWithCredential(credential);

      locator<NavigationService>().globalNavigateTo(AdLayOutRoute, context);
      showSnackBar(context, "Logged in ");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signUpWithEmailPass(
      String name, String email, String password, BuildContext context) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        locator<NavigationService>().globalNavigateTo(AdLayOutRoute, context);
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackbar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
