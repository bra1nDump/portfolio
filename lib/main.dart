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

class _HanoiTowersState extends State<HanoiTowers>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  List<List<int>> _towers = [[1, 2, 3], [], []];

  final _spacing = 10.0;
  final _diskHeight = 40.0;
  final _diskWidth = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4 * _spacing + 3 * _diskWidth,
      height: _spacing + 4 * _diskHeight,
      child: Stack(
        children: _towersBuild().toList()
      )
    );
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
      yield _diskBuild(towerIndex, diskIndex);
    }
  }

  Widget _diskBuild(int towerIndex, int diskIndex) {
    final towerId = _towers[towerIndex][diskIndex];
    var color;
    switch (towerId) {
      case 1: color = Colors.amber; break;
      case 2: color = Colors.red; break;
      case 3: color = Colors.green; break;
    }
    return Positioned(
      width: _diskWidth,
      height: _diskHeight,
      left: _spacing + towerIndex * (_diskWidth + _spacing),
      bottom: diskIndex * _diskHeight,
      child: Center(
        child: Container(
          width: _diskWidth / towerId,
          height: _diskHeight,
          color: color,
          child: Center(
            child: Text('$towerId')
          )
        ),
      ),
    );
  }
}
