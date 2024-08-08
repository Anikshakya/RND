/*

Add in Pubspec
local_auth:


Add the following permissions and metadata to your Android and iOS project files to enable biometric authentication.

For Android:
1. Add these permissions to the AndroidManifest.xml file:
   <uses-permission android:name="android.permission.USE_BIOMETRIC" />
   <uses-permission android:name="android.permission.USE_FINGERPRINT" />

2. Inside the <application> tag, add the following metadata:
   <application>
       <meta-data android:name="flutterEmbedding" android:value="2" />
       <!-- Add the following lines inside the <application> tag -->
       <uses-permission android:name="android.permission.USE_BIOMETRIC" />
   </application>

Note: The plugin will build and run on SDK 16+, but isDeviceSupported() will always return false before SDK 23 (Android 6.0).

Activity Changes:
Note that local_auth requires the use of a FragmentActivity instead of an Activity. To update your application:

If you are using FlutterActivity directly, change it to FlutterFragmentActivity in your AndroidManifest.xml.

If you are using a custom activity, update your MainActivity.java:
import io.flutter.embedding.android.FlutterFragmentActivity;

public class MainActivity extends FlutterFragmentActivity {
    // ...
}

or MainActivity.kt:
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    // ...
}

For iOS:
1. Add the following key-value pair to the Info.plist file to request Face ID usage:
   <key>NSFaceIDUsageDescription</key>
   <string>We need to access Face ID for authentication</string>

These configurations allow the app to use biometric authentication methods like fingerprint and Face ID.
*/

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricsPage extends StatefulWidget {
  const BiometricsPage({super.key});

  @override
  State<BiometricsPage> createState() => _BiometricsPageState();
}

class _BiometricsPageState extends State<BiometricsPage> {
  static LocalAuthentication auth = LocalAuthentication();
  String _authorizedStatusText = 'Not Authorized';

  bool canAuthinticate = false;

  @override
  void initState() {
    super.initState();
    canUseBiometric();
  }


  canUseBiometric() async {
    final bool canAuthenticateWithBiometrics  = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  // Return Athentication Status
  authenticate({context, isPIN}) async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
          biometricOnly: isPIN == true ? false : true,
        ),
      );
      if(didAuthenticate) {
        return didAuthenticate;
        // var data = box.read('loginInfo');
        // await _authCon.logIn(data['official_email'], data['password'], data['organization_code'], context);
      }
    } catch (e) {
      debugPrint(e.toString());
      _authorizedStatusText = 'Error - ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            if (canAuthinticate)
              const Text('This device supports biometrics'),
            const SizedBox(height: 20),
            Text('Current State: $_authorizedStatusText'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async{
                setState(() {
                  _authorizedStatusText = 'Authenticating';
                });
                var isAuthenticated = await authenticate(context: context, isPIN: false);
                if (isAuthenticated == true){
                  setState(() {
                    _authorizedStatusText = 'Authenticated';
                  });
                } else {
                  setState(() {
                    _authorizedStatusText = 'Not Authenticated';
                  });
                }
              },
              child: const Text('Authenticate with Biometrics'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async{
                setState(() {
                  _authorizedStatusText = 'Authenticating';
                });
                var isAuthenticated = await authenticate(context: context, isPIN: true);
                if (isAuthenticated == true){
                  setState(() {
                    _authorizedStatusText = 'Authenticated';
                  });
                } else {
                  setState(() {
                    _authorizedStatusText = 'Not Authenticated';
                  });
                }
              },
              child: const Text('Authenticate with PIN'),
            ),
          ],
        ),
      ),
    );
  }
}