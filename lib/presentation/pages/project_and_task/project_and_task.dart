import 'package:flutter/material.dart';
import 'dart:ui';

class ProjectAndTaskPage extends StatefulWidget {
  @override
  _ProjectAndTaskState createState() => _ProjectAndTaskState();
}

class _ProjectAndTaskState extends State<ProjectAndTaskPage> {
  final List<int> _items = List<int>.generate(5, (int index) => index);

  @override
  Widget build(BuildContext context) {
    final Color oddItemColor = Colors.lime.shade100;
    final Color evenItemColor = Colors.deepPurple.shade100;

    final List<Container> containers = <Container>[
      for (int index = 0; index < _items.length; index += 1)
        Container(
          key: Key('$index'),
          color: _items[index].isOdd ? oddItemColor : evenItemColor,
          child: SizedBox(
            height: 80,
            child: Center(
              child: Text('Card ${_items[index]}'),
            ),
          ),
        ),
    ];

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(1, 6, animValue)!;
          final double scale = lerpDouble(1, 1.02, animValue)!;
          return Transform.scale(
            scale: scale,
            // Create a Card based on the color and the content of the dragged one
            // and set its elevation to the animated value.
            child: Card(
              elevation: elevation,
              color: containers[index].color,
              child: containers[index].child,
            ),
          );
        },
        child: child,
      );
    }

    return ReorderableListView( 
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      proxyDecorator: proxyDecorator,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final int item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
      children: containers,
    );
  }


}
