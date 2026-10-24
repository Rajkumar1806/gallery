import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../data/media_repository.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final MediaRepository _repository = MediaRepository();
  List<AssetEntity> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final images = await _repository.getRecentImages();
    if (mounted) {
      setState(() {
        _images = images;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: _images.isEmpty 
        ? const Center(child: Text('No images found or permission denied.'))
        : GridView.builder(
            padding: const EdgeInsets.all(2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Uint8List?>(
                future: _images[index].thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Image.memory(snapshot.data!, fit: BoxFit.cover);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),
    );
  }
}