library animated_rotation;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' show pi;


class AnimatedRotatableContainer extends ImplicitlyAnimatedWidget {
  const AnimatedRotatableContainer({
    Key? key,
    required this.angle,
    required this.child,
    Curve curve = Curves.linear,
    Duration duration = const Duration(seconds: 1),
  }) : super(key: key, curve: curve, duration: duration);

  final num angle;
  final Widget child;

  @override
  _AnimatedRotationState createState() => _AnimatedRotationState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<num>('angle', angle));
  }
}

class _AnimatedRotationState extends AnimatedWidgetBaseState<AnimatedRotatableContainer> {
  Tween<num>? _angle;

  num _degToRad(num deg) => deg * (pi / 180.0);

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _angle = visitor(_angle, widget.angle,
            (dynamic value) => Tween<num>(begin: value as num)) as Tween<num>?;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _degToRad(_angle!.evaluate(animation)).toDouble(),
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(
      DiagnosticsProperty<Tween<num>?>(
        'angle',
        _angle,
        defaultValue: null,
      ),
    );
  }
}