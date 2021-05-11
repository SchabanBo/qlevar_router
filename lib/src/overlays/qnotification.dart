import 'package:flutter/material.dart';
import '../../qlevar_router.dart';

import 'qoverlay.dart';

/// Show a notification in any router you have in your project
class QNotification extends StatefulWidget with QOverlay {
  /// The Position where the notification should displayed
  /// LeftTop___________Top____________RightTop
  /// |                                        |
  /// |                                        |
  /// LeftCenter       Center       RightCenter
  /// |                                        |
  /// |                                        |
  /// LeftBottom_______Bottom________RightBottom
  final QNotificationPosition position;

  /// The offset from the Notification position With this offset, you can move
  /// the notification position for example for up or down left or right
  final Offset offset;

  /// The Notification width
  final double? width;

  /// The notification height
  final double height;

  /// the animation Duration in Milliseconds when the notification opens
  final int animationDurationMilliseconds;

  /// the reverse animation Duration in Milliseconds when the
  /// notification closes
  final int? animationReverseDurationMilliseconds;

  /// The animation curve for the notification when opens
  final Curve animationCurve;

  /// The animation curve for the notification when closes
  final Curve? animationReverseCurve;

  /// The context of your notification
  final Widget child;

  /// The duration to keep the notification open
  /// if this value was null the notification will not close, you have to call
  /// `remove` to close it.
  final Duration? duration;

  /// A work to do when the notification is open
  final VoidCallback? onOpened;

  /// A work to do when the notification is closed
  final VoidCallback? onClosed;

  /// The notification color
  final Color? color;

  QNotification({
    required this.child,
    this.position = QNotificationPosition.Top,
    this.offset = Offset.zero,
    this.height = 100,
    this.animationDurationMilliseconds = 800,
    this.animationReverseDurationMilliseconds,
    this.animationCurve = Curves.fastLinearToSlowEaseIn,
    this.animationReverseCurve,
    this.width,
    this.duration = const Duration(seconds: 2),
    this.onClosed,
    this.onOpened,
    this.color,
  });

  _NotificationState? _state;

  @override
  _NotificationState createState() {
    final state = _NotificationState();
    _state = state;
    return state;
  }

  OverlayEntry? _overlay;

  @override
  Future<T?> show<T>(
      {String? name, NavigatorState? state, BuildContext? context}) async {
    if (state == null || context == null) {
      if (name == null) {
        return await QR.rootNavigator.show(this);
      } else {
        return await QR.navigatorOf(name).show(this);
      }
    }

    if (_overlay == null) {
      final p = _calcPosition(context);
      _overlay = OverlayEntry(
        builder: (context) => Positioned(
          width: width,
          left: p.dx,
          top: p.dy,
          height: height,
          child: this,
        ),
      );
    }
    state.overlay!.insert(_overlay!);
    if (duration != null) {
      Future.delayed(duration!, remove);
    }
  }

  void remove() => _state!.remove().then((_) {
        if (onClosed != null) {
          onClosed!();
        }
        _overlay!.remove();
      });

  Offset _calcPosition(BuildContext context) {
    Offset result;
    switch (position) {
      case QNotificationPosition.LeftTop:
        result = Offset(0, 0);
        break;
      case QNotificationPosition.Top:
        result = Offset(context.size!.width / 2, 0);
        break;
      case QNotificationPosition.RightTop:
        result = Offset(context.size!.width, 0);
        break;
      case QNotificationPosition.LeftCenter:
        result = Offset(0, (context.size!.height - height) / 2);
        break;
      case QNotificationPosition.Center:
        result = Offset(
            context.size!.width / 2, (context.size!.height - height) / 2);
        break;
      case QNotificationPosition.RightCenter:
        result =
            Offset(context.size!.width, (context.size!.height - height) / 2);
        break;
      case QNotificationPosition.LeftBottom:
        result = Offset(0, context.size!.height - height);
        break;
      case QNotificationPosition.Bottom:
        result = Offset(context.size!.width / 2, context.size!.height - height);
        break;
      case QNotificationPosition.RightBottom:
        result = Offset(context.size!.width, context.size!.height - height);
        break;
      default:
        result = Offset.zero;
    }
    return Offset(result.dx + offset.dx, result.dy + offset.dy);
  }
}

class _NotificationState extends State<QNotification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.animationDurationMilliseconds),
    reverseDuration: widget.animationReverseDurationMilliseconds == null
        ? null
        : Duration(milliseconds: widget.animationDurationMilliseconds),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: _clacBeginOffset(),
    end: _clacEndOffset(),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: widget.animationCurve,
    reverseCurve: widget.animationReverseCurve,
  ));

  @override
  void initState() {
    super.initState();
    _controller.forward().then((value) {
      if (widget.onOpened != null) {
        widget.onOpened!();
      }
    });
  }

  Offset _clacBeginOffset() {
    switch (widget.position) {
      case QNotificationPosition.LeftTop:
      case QNotificationPosition.LeftCenter:
      case QNotificationPosition.LeftBottom:
        return const Offset(-1, 0);
      case QNotificationPosition.Top:
        return const Offset(0, -1);
      case QNotificationPosition.Bottom:
        return const Offset(0, 1);
      case QNotificationPosition.RightTop:
      case QNotificationPosition.RightCenter:
      case QNotificationPosition.RightBottom:
      default:
        return const Offset(0, 0);
    }
  }

  Offset _clacEndOffset() {
    switch (widget.position) {
      case QNotificationPosition.RightTop:
      case QNotificationPosition.RightCenter:
      case QNotificationPosition.RightBottom:
        return const Offset(-1, 0);
      case QNotificationPosition.Top:
      case QNotificationPosition.Bottom:
      case QNotificationPosition.LeftTop:
      case QNotificationPosition.LeftCenter:
      case QNotificationPosition.LeftBottom:
      default:
        return const Offset(0, 0);
    }
  }

  TickerFuture remove() => _controller.reverse();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Card(color: widget.color, child: widget.child),
    );
  }
}

/// The Position of QNotification
enum QNotificationPosition {
  LeftTop,
  Top,
  RightTop,
  LeftCenter,
  Center,
  RightCenter,
  LeftBottom,
  Bottom,
  RightBottom,
}
