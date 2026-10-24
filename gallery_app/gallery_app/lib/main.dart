import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/home_shell.dart';

void main() {
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PermissionGate(child: HomeShell()),
    );
  }
}

class PermissionGate extends StatefulWidget {
  final Widget child;
  const PermissionGate({super.key, required this.child});

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.photos.request();
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Asks for media permission, then shows the main shell.
class PermissionGate extends StatefulWidget {
  const PermissionGate({super.key});

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> {
  PermissionState? _state;

  @override
  void initState() {
    super.initState();
    _request();
  }

  Future<void> _request() async {
    final state = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: RequestType.common,
          mediaLocation: true,
        ),
      ),
    );
    if (!mounted) return;
    setState(() => _state = state);
    if (state.hasAccess) {
      GalleryScope.of(context, listen: false).load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    if (state != null && state.hasAccess) return const HomeShell();

    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: state == null
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.photo_library_outlined, size: 72),
                      const SizedBox(height: 20),
                      Text('Allow access to your photos',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      const Text(
                        'Gallery needs permission to show the photos and videos on this phone. Nothing leaves your device.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _request,
                        child: const Text('Allow access'),
                      ),
                      TextButton(
                        onPressed: PhotoManager.openSetting,
                        child: const Text('Open settings'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
