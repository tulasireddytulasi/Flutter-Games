import 'package:flame/game.dart';
import 'package:flame_examples/examples/bouncing_ball_example.dart';
import 'package:flame_examples/examples/camera_component_example.dart';
import 'package:flame_examples/examples/raycast_light_example.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<FlameGame> _games = [CameraComponentExample(), BouncingBallExample(), RaycastLightExample()];
  final List<String> _names = ["CameraComponentExample", "BouncingBallExample", "RaycastLightExample"];

  int gameIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Games"),
      ),
      drawer: Drawer(
        backgroundColor: Colors.lightBlueAccent,
        child: Column(
          children: [
            Container(
              color: Colors.purple,
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Flutter Game Examples"),
              ),
            ),
            Expanded(
              child: ListView(
                children: List.generate(
                  _names.length,
                  (index) {
                    return ListTile(
                      key: ValueKey(index),
                      leading: const Icon(Icons.home),
                      title: Text(_names[index]),
                      onTap: () {
                        try {
                          print("Index: $index");
                          gameIndex = index;
                          Navigator.pop(context); // Close the drawer
                          setState(() {});
                        } catch (e) {
                          print("Error: $e");
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        margin: const EdgeInsets.all(0),
        child: ClipRect(
          child: GameWidget(
            game: _games[gameIndex],
            loadingBuilder: (_) => const Center(
              child: Text('Loading'),
            ),
          ),
        ),
      ),
    );
  }
}
