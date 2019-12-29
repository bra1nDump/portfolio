import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirill Dubovitskiy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: HanoiTowers()
        )
      ),
    );
  }
}

class HanoiTowers extends StatefulWidget {
  @override
  _HanoiTowersState createState() => _HanoiTowersState();
}

enum DiskMovementState { popping, movingToTargetTower, pushing }

class _HanoiTowersState extends State<HanoiTowers> {
  List<List<int>> _towers = [[1, 2, 3], [], []];

  int _diskInMotion;
  DiskMovementState _diskMovementState;
  int _fromTower;
  int _toTower;

  final _spacing = 10.0;
  final _diskHeight = 40.0;
  final _diskWidth = 100.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1)).then((_) {
      _nextMove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4 * _spacing + 3 * _diskWidth,
      height: 4 * _diskHeight + 2 * _spacing,
      child: Stack(
        children: _towersBuild().toList()
      )
    );
  }

  void _nextMove() {
    setState(() {
      _diskInMotion = 3;
      _diskMovementState = DiskMovementState.popping;
      _fromTower = 0;
      _toTower = 2;
    });
  }

  void _motionStageCompleted() {
    setState(() {
      switch (_diskMovementState) {
        case DiskMovementState.popping:
          _diskMovementState = DiskMovementState.movingToTargetTower;
          break;
        case DiskMovementState.movingToTargetTower:
          _diskMovementState = DiskMovementState.pushing;
          break;
        case DiskMovementState.pushing:
          _towers[_toTower].add(_towers[_fromTower].removeLast());

          _diskInMotion = null;
          _diskMovementState = null;
          _fromTower = null;
          _toTower = null;
      }
    });
  }

  Iterable<Widget> _towersBuild() sync* {
    // add poles
    for (final pole in [0, 1, 2]) {
      yield Positioned(
        width: _spacing,
        height: 3 * _diskHeight + _spacing,
        left: _spacing / 2 + _diskWidth / 2 + pole * (_diskWidth + _spacing),
        bottom: 0,
        child: Container(
          color: Colors.black
        )
      );
    }

    // add disks
    for (final towerIndex in Iterable.generate(_towers.length)) {
      yield* _towerBuild(towerIndex);
    }
  }

  Iterable<Widget> _towerBuild(int towerIndex) sync* {
    var disks = _towers[towerIndex];
    for (final diskIndex in Iterable.generate(disks.length)) {
      yield _animatedDiskBuild(towerIndex, diskIndex);
    }
  }

  Widget _animatedDiskBuild(int towerIndex, int diskIndex) {
    final diskId = _towers[towerIndex][diskIndex];

    double left;
    double bottom;

    if (diskId != _diskInMotion) {
      left = _spacing + towerIndex * (_diskWidth + _spacing);
      bottom = diskIndex * _diskHeight;
    } else {
      switch (_diskMovementState) {
        case DiskMovementState.popping:
          left = _spacing + towerIndex * (_diskWidth + _spacing);
          bottom = 3 * _diskHeight + 2 * _spacing;
          break;
        case DiskMovementState.movingToTargetTower:
          left = _spacing + _toTower * (_diskWidth + _spacing);
          bottom = 3 * _diskHeight + 2 * _spacing;
          break;
        case DiskMovementState.pushing:
          left = _spacing + _toTower * (_diskWidth + _spacing);
          bottom = _towers[_toTower].length * _diskHeight + 2 * _spacing;
      }
    }

    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      onEnd: _motionStageCompleted,
      width: _diskWidth,
      height: _diskHeight,
      left: left,
      bottom: bottom,
      child: _diskBuild(diskId),
    );
  }

  Widget _diskBuild(int disk) {
    var color;
    switch (disk) {
      case 1: color = Colors.amber; break;
      case 2: color = Colors.red; break;
      case 3: color = Colors.green; break;
    }

    return Center(
      child: Container(
        width: _diskWidth / disk,
        height: _diskHeight,
        color: color,
        child: Center(
          child: Text('$disk')
        )
      )
    );
  }
}
