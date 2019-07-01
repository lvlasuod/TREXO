import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flame/position.dart';
import 'package:flame/anchor.dart';
import 'package:flutter/material.dart';
import 'package:run_trex/game/score/config.dart';

class ScoreComponent extends PositionComponent with Resizable, ComposedComponent{
  int secondsRun=0;
  bool isRunning=false;
  //ScoreText scoreText;

  ScoreComponent() : super() {
   // scoreText=ScoreText(sImage);
   // components..add(scoreText);
  }

  @override
  void render(Canvas c){
// get center of screen x , y
    double screenCenterX = 300;
    double screenCenterY = 400;

    writeText(c, "$secondsRun"+"M",
        Position(screenCenterX +350, screenCenterY -380), Colors.black54);
  }

  void update(double t) {
    if(isRunning){
      secondsRun++;
    }
  }

  void startScore(){
    isRunning=true;
  }
  void stopScore(){
    isRunning=false;
  }

  void writeText(Canvas canvas, String text, Position position, Color color) {
    TextConfig config = TextConfig(
        fontSize: 25.0,
        fontFamily: 'oldHey',
        textAlign: TextAlign.center,
        color: color);
    config.render(canvas, text, position, anchor: Anchor.topCenter);
  }
}
//class ScoreText extends SpriteComponent with Resizable {
//  ScoreText(Image sImage)
//      : super.fromSprite(
//      ScoreConfig.textWidth,
//      ScoreConfig.textHeight,
//      Sprite.fromImage(
//        sImage,
//        x: 400.0,
//        y: 29.0,
//        width: ScoreConfig.textWidth,
//        height: ScoreConfig.textHeight,
//      ));
//
//  @override
//  resize(Size size) {
//    if (width > size.width * 0.8) {
//      width = size.width * 0.8;
//    }
//    y = size.height * .25;
//    x = (size.width / 2) - width / 2;
//  }
//}
