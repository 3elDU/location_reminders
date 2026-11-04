import 'package:flutter/material.dart';
import 'package:location_reminders/main.dart';
import 'package:location_reminders/services/permission.dart';

class GrantPermissionsPage extends StatefulWidget {
  const GrantPermissionsPage({super.key});

  /// Returns true when all permissions were granted
  static Future<bool?> show() {
    return navigatorGlobalKey.currentState!.push<bool>(
      MaterialPageRoute(builder: (_) => GrantPermissionsPage()),
    );
  }

  @override
  State<GrantPermissionsPage> createState() => _GrantPermissionsPageState();
}

class _GrantPermissionsPageState extends State<GrantPermissionsPage> {
  late Future<List<PermissionDescription>> _missingPermissions;

  @override
  void initState() {
    super.initState();

    _loadMissingPermissions();
  }

  void _loadMissingPermissions() {
    setState(() {
      _missingPermissions = PermissionService.missingPermissions;
    });

    _missingPermissions.then((missing) {
      if (missing.isEmpty) {
        navigatorGlobalKey.currentState!.pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grant Permissions')),
      body: FutureBuilder(
        future: _missingPermissions,
        builder: (_, snapshot) {
          if (!snapshot.hasData) return SizedBox.expand();

          return ListView(
            children: snapshot.data!
                .map(
                  (permission) => ListTile(
                    title: Text(permission.name),
                    subtitle: Text(
                      '${permission.description}\n${permission.reasonForUse}',
                    ),
                    onTap: () async {
                      await permission.request();
                      _loadMissingPermissions();
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
