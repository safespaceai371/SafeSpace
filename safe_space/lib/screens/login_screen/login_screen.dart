



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<User?> _signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         // User canceled the sign-in
//         return null;
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Once signed in, return the UserCredential
//       final UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       return userCredential.user;
//     } catch (e) {
//       print('Error signing in with Google: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to sign in with Google')),
//       );
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Safe Space'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Welcome to Safe Space!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton.icon(
//               onPressed: () async {
//                 final user = await _signInWithGoogle();
//                 if (user != null) {
//                   // Navigate to home screen
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomeScreen()),
//                   );
//                 }
//               },
//               icon: Image.asset(
//                 'assets/images/google_logo.png', // You'll need to add this asset
//                 height: 24,
//                 width: 24,
//               ),
//               label: Text('Sign in with Google'),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  Future<User?> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔵 Starting Google Sign-In process...');
      
      // Check if Google Play Services is available
      print('🔵 Checking Google Sign-In availability...');
      final bool isAvailable = await _googleSignIn.isSignedIn();
      print('🔵 Previously signed in: $isAvailable');

      // Sign out first to ensure clean state
      await _googleSignIn.signOut();
      print('🔵 Signed out from previous session');
      
      // Trigger the authentication flow
      print('🔵 Triggering Google Sign-In...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('🔴 User canceled sign-in');
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      print('🟢 Google user signed in: ${googleUser.email}');
      print('🔵 Display name: ${googleUser.displayName}');

      // Obtain the auth details from the request
      print('🔵 Getting authentication details...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      print('🔵 Access token exists: ${googleAuth.accessToken != null}');
      print('🔵 ID token exists: ${googleAuth.idToken != null}');

      // Create a new credential
      print('🔵 Creating Firebase credential...');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      print('🔵 Signing in to Firebase...');
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      print('🟢 Firebase sign-in successful!');
      print('🟢 User: ${userCredential.user?.email}');
      
      setState(() {
        _isLoading = false;
      });
      
      return userCredential.user;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      print('🔴 DETAILED ERROR: $e');
      print('🔴 Error type: ${e.runtimeType}');
      print('🔴 Stack trace: ${StackTrace.current}');
      
      String errorMessage = 'Failed to sign in with Google';
      
      if (e.toString().contains('network_error')) {
        errorMessage = 'Network error. Check internet connection.';
      } else if (e.toString().contains('sign_in_canceled')) {
        errorMessage = 'Sign-in was canceled.';
      } else if (e.toString().contains('sign_in_failed')) {
        errorMessage = 'Google Sign-In failed. Check configuration.';
      } else if (e.toString().contains('PlatformException')) {
        errorMessage = 'Platform error. Check SHA-1 fingerprint.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$errorMessage\n\nDetailed: ${e.toString()}'),
          duration: Duration(seconds: 5),
        ),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe Space'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Safe Space!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            if (_isLoading)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Signing in...'),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: () async {
                  final user = await _signInWithGoogle();
                  if (user != null) {
                    // Navigate to home screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                },
                icon: Icon(Icons.login), // Temporarily using icon instead of image
                label: Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}