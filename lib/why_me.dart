import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class WhyMe extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HanoiTowers();
  }
}

class HanoiTowers extends StatefulWidget {
  @override
  _HanoiTowersState createState() => _HanoiTowersState();
}

enum MoveAnimationState { popping, movingToTargetTower, pushing }
class Move {
  final int from;
  final int to;
  Move(this.from, this.to);
}

class _HanoiTowersState extends State<HanoiTowers> {
  List<List<int>> _towers = [[1, 2, 3], [], []];

  Move _move;
  MoveAnimationState _moveAnimationState;
  Completer _moveController;

  final _spacing = 10.0;
  final _diskHeight = 60.0;
  final _diskWidth = 200.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), _solve);
  }

  Iterable<Move> _solution() sync* {
    final moves = 
      [
        [0, 2],
        [0, 1],
        [2, 1],
        [0, 2],
        [1, 0],
        [1, 2],
        [0, 2],
      ];
    for (var move in moves) {
      yield Move(move[0], move[1]);
    }
  }
 
  void _solve() async {
    for (final move in _solution()) {
      await _startMove(move);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Container(
          width: 4 * _spacing + 3 * _diskWidth,
          height: 4 * _diskHeight + 2 * _spacing,
          child: Stack(children: _towersBuild(context).toList())
        ),
        Container(
          height: 2 * _spacing,
          width: 4 * _spacing + 3 * _diskWidth,
          padding: EdgeInsets.symmetric(horizontal: _spacing * 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Current company'),
              Text('Interview'),
              Text('Your company'),
            ],
          ),
          decoration: BoxDecoration(
            color: theme.primaryColorLight,
            borderRadius: BorderRadius.circular(_spacing)
          ),
        )
      ]
    );
  }

  Future _startMove(Move move) {
    var controller = Completer();
    setState(() {
      _moveAnimationState = MoveAnimationState.popping;
      _move = move;
      _moveController = controller;
    });

    return controller.future;
  }

  void _motionStageCompleted() {
    setState(() {
      switch (_moveAnimationState) {
        case MoveAnimationState.popping:
          _moveAnimationState = MoveAnimationState.movingToTargetTower;
          break;
        case MoveAnimationState.movingToTargetTower:
          _moveAnimationState = MoveAnimationState.pushing;
          break;
        case MoveAnimationState.pushing:
          _towers[_move.to].add(_towers[_move.from].removeLast());

          _moveAnimationState = null;
          _move = null;
          _moveController.complete();
          break;
      }
    });
  }

  Iterable<Widget> _towersBuild(BuildContext context) sync* {
    // add poles
    for (final pole in [0, 1, 2]) {
      yield Positioned(
        width: _spacing,
        height: 3 * _diskHeight + _spacing,
        left: _spacing / 2 + _diskWidth / 2 + pole * (_diskWidth + _spacing),
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(_spacing / 2))
          ),
        )
      );
    }

    // add disks
    for (final towerIndex in Iterable.generate(_towers.length)) {
      yield* _towerBuild(context, towerIndex);
    }
  }

  Iterable<Widget> _towerBuild(BuildContext context, int towerIndex) sync* {
    var disks = _towers[towerIndex];
    for (final diskIndex in Iterable.generate(disks.length)) {
      yield _animatedDiskBuild(context, towerIndex, diskIndex);
    }
  }

  Widget _animatedDiskBuild(BuildContext context, int towerIndex, int diskIndex) {
    final diskId = _towers[towerIndex][diskIndex];

    double left;
    double bottom;

    if (_move == null || diskId != _towers[_move.from].last) {
      left = _spacing + towerIndex * (_diskWidth + _spacing);
      bottom = diskIndex * _diskHeight;
    } else {
      switch (_moveAnimationState) {
        case MoveAnimationState.popping:
          left = _spacing + towerIndex * (_diskWidth + _spacing);
          bottom = 3 * _diskHeight + 2 * _spacing;
          break;
        case MoveAnimationState.movingToTargetTower:
          left = _spacing + _move.to * (_diskWidth + _spacing);
          bottom = 3 * _diskHeight + 2 * _spacing;
          break;
        case MoveAnimationState.pushing:
          left = _spacing + _move.to * (_diskWidth + _spacing);
          bottom = _towers[_move.to].length * _diskHeight + 2 * _spacing;
      }
    }

    return AnimatedPositioned(
      key: Key(diskId.toString()),
      duration: Duration(milliseconds: 500),
      onEnd: _motionStageCompleted,
      width: _diskWidth,
      height: _diskHeight,
      left: left,
      bottom: bottom,
      child: _diskBuild(context, diskId),
    );
  }

  Widget _diskBuild(BuildContext context, int disk) {
    var theme = Theme.of(context);
    var color;
    var text;
    switch (disk) {
      case 1:
        color = theme.primaryColorLight;
        text = 'problem driven';
        break;
      case 2:
        color = theme.primaryColorLight; 
        text = 'solution oriented';
        break;
      case 3:
        color = theme.primaryColorLight;
        text = 'go home in a box';
        break;
    }

    return Center(
      child: Container(
        width: _diskWidth * pow(1.4, -disk),
        height: _diskHeight - _spacing / 2,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(_diskHeight / 2))
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              text,
              textAlign: TextAlign.center,
            )
          )
        )
      )
    );
  }
}
