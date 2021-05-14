// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//import 'bottomnavbar.dart';
import 'convexbottomnavbar_widget.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

/// Entrypoint example for various sign-in flows with Firebase.
class SignInPageNew extends StatefulWidget {
  final FirebaseApp app;

  /// The page title.
  final String title = 'Sign In & Out';

  SignInPageNew(this.app);

  @override
  State<StatefulWidget> createState() => _SignInPageNewState();
}

class _SignInPageNewState extends State<SignInPageNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text(widget.title),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          )),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            _EmailPasswordForm(widget.app),
            //_EmailLinkSignInSection(),
            //_AnonymouslySignInSection(),
            //_PhoneSignInSection(Scaffold.of(context)),
            //_OtherProvidersSignInSection(),
          ],
        );
      }),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  final FirebaseApp app;

  _EmailPasswordForm(this.app);

  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Log in to your account',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                // inputFile(label: "Email",),
                // inputFile(label: "Password", obscureText: true),
                TextFormField(
                  // border: OutlineInputBorder(
                  //   // width: 0.0 produces a thin "hairline" border
                  //   borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  //   borderSide: BorderSide.none,
                  //   //borderSide: const BorderSide(),
                  // ),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    // hintText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white30,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black,
                    )),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) return 'Please enter your email';
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                    fillColor: Colors.white30,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black,
                    )),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) return 'Please enter some text';
                    return null;
                  },
                  obscureText: true,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  alignment: Alignment.center,
                  child: SignInButtonBuilder(
                    icon: Icons.email,
                    backgroundColor: Colors.green,
                    height: 60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    text: 'Sign In',
                    fontSize: 18,
                    // child: Text(
                    //   "Sign up",
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 18),
                    // ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await _signInWithEmailAndPassword();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget inputFile({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]))),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.email} signed in'),
        ),
      );
      //added this to navigate to controlpanel when signed in
      Navigator.of(context).push(
          //MaterialPageRoute(builder: (BuildContext context) => BottomBar(widget.app)));
          MaterialPageRoute(
              builder: (BuildContext context) => ConvexBottomBar(widget.app)));
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
        ),
      );
    }
  }
}

class _EmailLinkSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailLinkSignInSectionState();
}

class _EmailLinkSignInSectionState extends State<_EmailLinkSignInSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String _userEmail = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Test sign in with email and link',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (String value) {
                  if (value.isEmpty) return 'Please enter your email.';
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  icon: Icons.insert_link,
                  text: 'Sign In',
                  backgroundColor: Colors.green,
                  onPressed: () async {
                    await _signInWithEmailAndLink();
                  },
                ),
              ),
            ],
          ),
        )));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndLink() async {
    try {
      _userEmail = _emailController.text;

      await _auth.sendSignInLinkToEmail(
          email: _userEmail,
          actionCodeSettings: ActionCodeSettings(
              url:
                  'https://react-native-firebase-testing.firebaseapp.com/emailSignin',
              handleCodeInApp: true,
              iOSBundleId: 'io.flutter.plugins.firebaseAuthExample',
              androidPackageName: 'io.flutter.plugins.firebaseauthexample'));

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('An email has been sent to $_userEmail'),
        ),
      );
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sending email failed'),
        ),
      );
    }
  }
}

class _AnonymouslySignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnonymouslySignInSectionState();
}

class _AnonymouslySignInSectionState extends State<_AnonymouslySignInSection> {
  bool _success;
  String _userID = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const Text('Test sign in anonymously',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                text: 'Sign In',
                icon: Icons.person_outline,
                backgroundColor: Colors.deepPurple,
                onPressed: _signInAnonymously,
              ),
            ),
            Visibility(
              visible: _success != null,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _success == null
                      ? ''
                      : (_success
                          ? 'Successfully signed in, uid: $_userID'
                          : 'Sign in failed'),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Example code of how to sign in anonymously.
  Future<void> _signInAnonymously() async {
    try {
      final User user = (await _auth.signInAnonymously()).user;

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in Anonymously as user ${user.uid}'),
        ),
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in Anonymously'),
        ),
      );
    }
  }
}

class _PhoneSignInSection extends StatefulWidget {
  _PhoneSignInSection(this._scaffold);

  final ScaffoldState _scaffold;

  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends State<_PhoneSignInSection> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                alignment: Alignment.center,
                child: const Text(
                  'Test sign in with phone number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                'Sign In with Phone Number on Web is currently unsupported',
              )
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Test sign in with phone number',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone number (+x xxx-xxx-xxxx)',
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Phone number (+x xxx-xxx-xxxx)';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                icon: Icons.contact_phone,
                backgroundColor: Colors.deepOrangeAccent[700],
                text: 'Verify Number',
                onPressed: _verifyPhoneNumber,
              ),
            ),
            TextField(
              controller: _smsController,
              decoration: const InputDecoration(labelText: 'Verification code'),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                icon: Icons.phone,
                backgroundColor: Colors.deepOrangeAccent[400],
                onPressed: _signInWithPhoneNumber,
                text: 'Sign In',
              ),
            ),
            Visibility(
              visible: _message != null,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Example code of how to verify phone number
  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      widget._scaffold.showSnackBar(SnackBar(
        content: Text(
            'Phone number automatically verified and user signed in: $phoneAuthCredential'),
      ));
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      widget._scaffold.showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      ));
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      widget._scaffold.showSnackBar(SnackBar(
        content: Text('Failed to Verify Phone Number: $e'),
      ));
    }
  }

  // Example code of how to sign in with phone.
  Future<void> _signInWithPhoneNumber() async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;

      widget._scaffold.showSnackBar(SnackBar(
        content: Text('Successfully signed in UID: ${user.uid}'),
      ));
    } catch (e) {
      print(e);
      widget._scaffold.showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in'),
        ),
      );
    }
  }
}

class _OtherProvidersSignInSection extends StatefulWidget {
  _OtherProvidersSignInSection();

  @override
  State<StatefulWidget> createState() => _OtherProvidersSignInSectionState();
}

class _OtherProvidersSignInSectionState
    extends State<_OtherProvidersSignInSection> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _tokenSecretController = TextEditingController();

  int _selection = 0;
  bool _showAuthSecretTextField = false;
  bool _showProviderTokenField = true;
  String _provider = 'GitHub';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: const Text('Social Authentication',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: kIsWeb
                    ? const Text(
                        'When using Flutter Web, API keys are configured through the Firebase Console. The below providers demonstrate how this works')
                    : const Text(
                        'We do not provide an API to obtain the token for below providers apart from Google '
                        'Please use a third party service to obtain token for other providers.'),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: const Text('GitHub'),
                      leading: Radio<int>(
                        value: 0,
                        groupValue: _selection,
                        onChanged: _handleRadioButtonSelected,
                      ),
                    ),
                    Visibility(
                      visible: !kIsWeb,
                      child: ListTile(
                        title: const Text('Facebook'),
                        leading: Radio<int>(
                          value: 1,
                          groupValue: _selection,
                          onChanged: _handleRadioButtonSelected,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Twitter'),
                      leading: Radio<int>(
                        value: 2,
                        groupValue: _selection,
                        onChanged: _handleRadioButtonSelected,
                      ),
                    ),
                    ListTile(
                      title: const Text('Google'),
                      leading: Radio<int>(
                        value: 3,
                        groupValue: _selection,
                        onChanged: _handleRadioButtonSelected,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _showProviderTokenField && !kIsWeb,
                child: TextField(
                  controller: _tokenController,
                  decoration: const InputDecoration(
                      labelText: "Enter provider's token"),
                ),
              ),
              Visibility(
                visible: _showAuthSecretTextField && !kIsWeb,
                child: TextField(
                  controller: _tokenSecretController,
                  decoration: const InputDecoration(
                      labelText: "Enter provider's authTokenSecret"),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: SignInButton(
                  _provider == 'GitHub'
                      ? Buttons.GitHub
                      : (_provider == 'Facebook'
                          ? Buttons.Facebook
                          : (_provider == 'Twitter'
                              ? Buttons.Twitter
                              : Buttons.GoogleDark)),
                  text: 'Sign In',
                  onPressed: () async {
                    _signInWithOtherProvider();
                  },
                ),
              ),
            ],
          )),
    );
  }

  void _handleRadioButtonSelected(int value) {
    setState(() {
      _selection = value;

      switch (_selection) {
        case 0:
          {
            _provider = 'GitHub';
            _showAuthSecretTextField = false;
            _showProviderTokenField = true;
          }
          break;

        case 1:
          {
            _provider = 'Facebook';
            _showAuthSecretTextField = false;
            _showProviderTokenField = true;
          }
          break;

        case 2:
          {
            _provider = 'Twitter';
            _showAuthSecretTextField = true;
            _showProviderTokenField = true;
          }
          break;

        default:
          {
            _provider = 'Google';
            _showAuthSecretTextField = false;
            _showProviderTokenField = false;
          }
      }
    });
  }

  void _signInWithOtherProvider() {
    switch (_selection) {
      case 0:
        _signInWithGithub();
        break;
      case 1:
        _signInWithFacebook();
        break;
      case 2:
        _signInWithTwitter();
        break;
      default:
        _signInWithGoogle();
    }
  }

  // Example code of how to sign in with Github.
  Future<void> _signInWithGithub() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GithubAuthProvider githubProvider = GithubAuthProvider();
        userCredential = await _auth.signInWithPopup(githubProvider);
      } else {
        final AuthCredential credential = GithubAuthProvider.credential(
          _tokenController.text,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }

      final user = userCredential.user;

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Sign In ${user.uid} with GitHub'),
      ));
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with GitHub: $e'),
        ),
      );
    }
  }

  // Example code of how to sign in with Facebook.
  Future<void> _signInWithFacebook() async {
    try {
      final AuthCredential credential = FacebookAuthProvider.credential(
        _tokenController.text,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign In ${user.uid} with Facebook'),
        ),
      );
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Facebook: $e'),
        ),
      );
    }
  }

  // Example code of how to sign in with Twitter.
  Future<void> _signInWithTwitter() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();
        await _auth.signInWithPopup(twitterProvider);
      } else {
        final AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: _tokenController.text,
            secret: _tokenSecretController.text);
        userCredential = await _auth.signInWithCredential(credential);
      }

      final user = userCredential.user;

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Sign In ${user.uid} with Twitter'),
      ));
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Twitter: $e'),
        ),
      );
    }
  }

  //Example code of how to sign in with Google.
  Future<void> _signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Sign In ${user.uid} with Google'),
      ));
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google: $e'),
        ),
      );
    }
  }
}
