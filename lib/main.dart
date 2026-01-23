import 'dart:ui';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() => runApp(const LumiaLauncherApp());

const MethodChannel _launcherChannel = MethodChannel('lumia_launcher/apps');

class LumiaLauncherApp extends StatelessWidget {
  const LumiaLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Header(), Expanded(child: TileGrid())],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${now.day}/${now.month}/${now.year}",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class TileData {
  final String title;
  final Color color;
  final TileSize size;
  final String package;

  TileData(this.title, this.color, this.size, this.package);
}

final tiles = [
  TileData('Phone', Colors.teal, TileSize.small, 'com.android.dialer'),
  TileData('Messages', Colors.blue, TileSize.wide,
      'com.google.android.apps.messaging'),
  TileData('Camera', Colors.deepPurple, TileSize.small, 'com.android.camera'),
  TileData('Settings', Colors.orange, TileSize.small, 'com.android.settings'),
];

class TileGrid extends StatelessWidget {
  const TileGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: tiles.map((tile) {
            return StaggeredGridTile.count(
              crossAxisCellCount:
                  tile.size == TileSize.wide ? 2 : 1, // 👈 REAL WIDE
              mainAxisCellCount: 1,
              child: Tile(
                title: tile.title,
                color: tile.color,
                size: tile.size,
                packageName: tile.package,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

enum TileSize { small, wide }

class Tile extends StatelessWidget {
  final String title;
  final Color color;
  final TileSize size;
  final String? packageName;

  const Tile({
    super.key,
    required this.title,
    required this.color,
    required this.size,
    this.packageName,
  });

  Future<void> _launchApp() async {
    if (packageName == null) return;

    try {
      await _launcherChannel.invokeMethod(
        'launchApp',
        {'package': packageName},
      );
    } catch (e) {
      debugPrint('Launch failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchApp,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
