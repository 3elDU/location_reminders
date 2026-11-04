import 'package:flutter/material.dart';
import 'package:location_reminders/main.dart';
import 'package:location_reminders/pages/permissions.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static Future<bool?> show() {
    return navigatorGlobalKey.currentState!.push<bool>(
      MaterialPageRoute(builder: (_) => WelcomePage()),
    );
  }

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _grantPermissions() async {
    GrantPermissionsPage.show().then((allGranted) {
      navigatorGlobalKey.currentState!.pop(allGranted);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: .center,
            spacing: 16,
            children: [
              Text(
                'Welcome!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                'This app sends reminders when you\'re close to a chosen location or area.\n'
                'To start, you\'ll have to grant a few permissions, necessary for the app to function.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: .center,
              ),
              FilledButton.icon(
                icon: Icon(Icons.open_in_new),
                label: Text('Grant Permissions'),
                onPressed: _grantPermissions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
