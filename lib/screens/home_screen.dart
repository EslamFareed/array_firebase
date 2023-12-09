import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auth"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController),
            TextField(controller: passwordController),
            ElevatedButton(
              onPressed: () async {
                try {
                  var crendtial = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  if (crendtial.user != null) {
                    print(crendtial.user!.email);
                  } else {
                    print("error");
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              child: const Text("Create Account"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  var crendtial =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  if (crendtial.user != null) {
                    print(crendtial.user!.email);
                  } else {
                    print("error");
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              child: const Text("Login"),
            ),
            TextField(controller: phoneController),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  verificationCompleted:
                      (PhoneAuthCredential credential) async {
                    await FirebaseAuth.instance
                        .signInWithCredential(credential);
                  },
                  verificationFailed: (error) {
                    print(error.message);
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return Dialog(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Column(
                                children: [
                                  TextField(controller: codeController),
                                  ElevatedButton(
                                    onPressed: () async {
                                      PhoneAuthCredential credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: verificationId,
                                              smsCode: codeController.text);

                                      // Sign the user in (or link) with the credential
                                      var user = await FirebaseAuth.instance
                                          .signInWithCredential(credential);

                                      if (user.user != null) {
                                        print(user.user!.phoneNumber);
                                      }
                                    },
                                    child: const Text("verify code"),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  codeAutoRetrievalTimeout: (text) {},
                  timeout: const Duration(minutes: 2),
                );
              },
              child: const Text("sign in with phone"),
            ),
            ElevatedButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: const Text("Google"),
            )
          ],
        ),
      ),
    );
  }
}
