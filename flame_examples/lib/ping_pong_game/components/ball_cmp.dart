import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_examples/ping_pong_game/components/border_cmp.dart';
import 'package:flame_examples/ping_pong_game/components/paddle_cmp.dart';
import 'package:flutter/material.dart';

class Ball extends CircleComponent with HasGameReference<FlameGame>, CollisionCallbacks {
  late Vector2 velocity;

  Ball() {
    paint = Paint()..color = Colors.white;
    radius = 10;
  }

  static const double speed = 350;
  static const degree = math.pi / 180;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _resetBall;
    final hitBox = CircleHitbox(
      radius: radius,
    );

    addAll([
      hitBox,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  void get _resetBall {
    position = game.size / 2;
    final spawnAngle = getSpawnAngle;

    final vx = math.cos(spawnAngle * degree) * speed;
    final vy = math.sin(spawnAngle * degree) * speed;
    velocity = Vector2(
      vx,
      vy,
    );
  }

  double get getSpawnAngle {
    final random = math.Random().nextDouble();
    final spawnAngle = lerpDouble(30, 150, random)!; // Ensures ball moves in an upward direction
    return spawnAngle;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is ScreenHitbox) {
      final collisionPoint = intersectionPoints.first;

      // Left Side Collision
      if (collisionPoint.x == 0) {
        velocity.x = -velocity.x;
        velocity.y = velocity.y;
      }
      // Right Side Collision
      if (collisionPoint.x == game.size.x) {
        velocity.x = -velocity.x;
        velocity.y = velocity.y;
      }
      // Top Side Collision
      if (collisionPoint.y == 0) {
        velocity.x = velocity.x;
        velocity.y = -velocity.y;
      }
      // Bottom Side Collision
      if (collisionPoint.y == game.size.y) {
        velocity.x = velocity.x;
        velocity.y = -velocity.y;
      }
    }
    // If the collision is with the border or screen edges, bounce off in opposite direction
    else if (other is BorderWall) {
      final collisionPoint = intersectionPoints.first;
      final paddleLeft = other.position.x;
      final paddleRight = paddleLeft + other.size.x;
      final paddleTop = other.position.y;
      final paddleBottom = paddleTop + other.size.y;

      // Ball's center position
      final ballCenterX = position.x + radius;
      final ballCenterY = position.y + radius;

      // Check if the ball hits the left or right side of the paddle
      if (ballCenterX > paddleLeft && ballCenterX < paddleRight) {
        if (collisionPoint.y >= paddleTop && collisionPoint.y <= paddleBottom) {
          velocity.y = -velocity.y; // Reverse Y-direction when hitting top/bottom of the paddle
        }
      }

      // Check if the ball hits the top or bottom side of the paddle
      if (ballCenterY > paddleTop && ballCenterY < paddleBottom) {
        if (collisionPoint.x >= paddleLeft && collisionPoint.x <= paddleRight) {
          velocity.x = -velocity.x; // Reverse X-direction when hitting left/right of the paddle
        }
      }
    } else if (other is Paddle) {
      velocity.y = -velocity.y; // Reverse Y-direction when hitting the paddle
    }
  }
}
