import 'dart:ui';

import 'package:flame/game.dart';
import 'package:run_trex/game/horizon/horizon.dart';
import 'package:run_trex/game/collision/collision_utils.dart';
import 'package:run_trex/game/game_config.dart';
import 'package:run_trex/game/game_over/game_over.dart';
import 'package:run_trex/game/score/score_c.dart';
import 'package:run_trex/game/t_rex/config.dart';
import 'package:run_trex/game/t_rex/t_rex.dart';

enum TRexGameStatus { playing, waiting, gameOver }

class TRexGame extends BaseGame {
  TRex tRex;
  Horizon horizon;
  GameOverPanel gameOverPanel;
  ScoreComponent scoreComponent;
  TRexGameStatus status = TRexGameStatus.waiting;

  double currentSpeed = GameConfig.speed;
  double timePlaying = 0.0;

  TRexGame({Image spriteImage}) {
    tRex = new TRex(spriteImage);
    horizon = new Horizon(spriteImage);
    gameOverPanel = new GameOverPanel(spriteImage);
    scoreComponent=ScoreComponent();

    this..add(horizon)..add(tRex)..add(gameOverPanel)..add(scoreComponent);
  }

  void onTap() {
    if (gameOver) {
      restart();
      return;
    }
    tRex.startJump(this.currentSpeed);
  }

  @override
  void update(double t) {
    tRex.update(t);
   // print("Second ${scoreComponent.secondsRun}");

    scoreComponent.update(t);
    horizon.updateWithSpeed(0.0, this.currentSpeed);

    if (gameOver) return;

    if (tRex.playingIntro && tRex.x >= TRexConfig.startXPos) {
      startGame();
    } else if (tRex.playingIntro) {
      horizon.updateWithSpeed(0.0, this.currentSpeed);
    }

    if (this.playing) {
      timePlaying += t;
      horizon.updateWithSpeed(t, this.currentSpeed);

      var obstacles = horizon.horizonLine.obstacleManager.components;
      bool collision =
          obstacles.length > 0 && checkForCollision(obstacles.first, tRex);
      if (!collision) {
        if (this.currentSpeed < GameConfig.maxSpeed) {
          this.currentSpeed += GameConfig.acceleration;
        }
      } else {
        doGameOver();
      }
    }
  }

  void startGame() {
    scoreComponent.startScore();
    tRex.status = TRexStatus.running;
    status = TRexGameStatus.playing;
    tRex.hasPlayedIntro = true;
  }

  bool get playing => status == TRexGameStatus.playing;
  bool get gameOver => status == TRexGameStatus.gameOver;

  void doGameOver() {
    this.gameOverPanel.visible = true;
    scoreComponent.stopScore();
    stop();
    tRex.status = TRexStatus.crashed;
  }

  void stop() {
    this.status = TRexGameStatus.gameOver;
  }

  void restart() {
    status = TRexGameStatus.playing;
    tRex.reset();
    horizon.reset();
    scoreComponent.secondsRun=0;
    scoreComponent.startScore();
    currentSpeed = GameConfig.speed;
    gameOverPanel.visible = false;
    timePlaying = 0.0;
  }
}
