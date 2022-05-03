import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

class PortalError extends StatefulWidget {
  const PortalError({Key? key}) : super(key: key);

  @override
  State<PortalError> createState() => _PortalErrorState();
}

class _PortalErrorState extends State<PortalError> {
  bool _visibility = false;
  @override
  Widget build(BuildContext context) {
    return Modal(
        onClose: () {
          setState(() {
            _visibility = false;
          });
        },
        visible: _visibility,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.question_mark_rounded),
          onPressed: () {
            setState(() {
              _visibility = true;
            });
          },
          label: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select Receiver Information',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        modal: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Container(
            // height: 600.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _searchField(context),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  TextField _searchField(BuildContext ctx) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Sender Name",
        contentPadding: const EdgeInsets.all(20),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: const Padding(
            padding: EdgeInsets.all(10), child: Icon(Icons.search)),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 25,
          // minHeight: 20.h,
        ),
      ),
      onChanged: (text) async {},
    );
  }
}

class Modal extends StatelessWidget {
  const Modal({
    Key? key,
    required this.visible,
    required this.onClose,
    required this.modal,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Widget modal;
  final bool visible;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Barrier(
      visible: visible,
      onClose: onClose,
      child: PortalTarget(
        visible: visible,
        closeDuration: kThemeAnimationDuration,
        portalFollower: TweenAnimationBuilder<double>(
          duration: kThemeAnimationDuration,
          curve: Curves.easeOut,
          tween: Tween(begin: 0, end: visible ? 1 : 0),
          builder: (context, progress, child) {
            return Transform(
              transform: Matrix4.translationValues(0, (1 - progress) * 50, 0),
              child: Opacity(
                opacity: progress,
                child: child,
              ),
            );
          },
          child: Center(child: modal),
        ),
        child: child,
      ),
    );
  }
}

class Barrier extends StatelessWidget {
  const Barrier({
    Key? key,
    required this.onClose,
    required this.visible,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onClose;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      closeDuration: kThemeAnimationDuration,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: onClose,
        child: TweenAnimationBuilder<Color>(
          duration: kThemeAnimationDuration,
          tween: ColorTween(
            begin: Colors.transparent,
            end: visible ? Colors.black54 : Colors.transparent,
          ),
          builder: (context, color, child) {
            return ColoredBox(color: color);
          },
        ),
      ),
      child: child,
    );
  }
}

class ColorTween extends Tween<Color> {
  ColorTween({required Color begin, required Color end})
      : super(begin: begin, end: end);

  @override
  Color lerp(double t) => Color.lerp(begin, end, t)!;
}
