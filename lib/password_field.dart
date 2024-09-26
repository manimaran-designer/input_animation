import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key});

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput>
    with SingleTickerProviderStateMixin {
  bool isPasswordVisible = false;
  late AnimationController animCtrl;
  late Animation<double> tween;
  late Animation<Color?> lockColor;
  String passValue = "";
  final purple = Colors.deepPurpleAccent[100];

  @override
  void initState() {
    super.initState();
    animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    lockColor = ColorTween(begin: Colors.white, end: Colors.black).animate(
        CurvedAnimation(curve: const Interval(.8, 1), parent: animCtrl));
    tween = Tween(begin: 1.0, end: 0.0).animate(animCtrl);
  }

  @override
  void dispose() {
    animCtrl.dispose();
    super.dispose();
  }

  void onPressVisibility() {
    if (isPasswordVisible) {
      animCtrl.reverse();
    } else {
      animCtrl.forward();
    }
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  onChangeText(String value) {
    setState(() {
      passValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(minHeight: 55),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey[900],
          ),
        ),
        TextField(
          onChanged: onChangeText,
          obscureText: true,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintText: "Password",
            hintStyle: TextStyle(color: purple),
            prefixIcon: const SizedBox(width: 48),
          ),
          style: TextStyle(color: purple),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: animCtrl,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 20,
              ),
              color: Colors.white,
              child: Text(
                passValue,
                style: TextStyle(
                  fontSize: 15,
                  color: purple,
                ),
              ),
            ),
            builder: (_, child) => ClipPath(
              clipper: RevelClip(tween.value),
              child: child,
            ),
          ),
        ),
        Positioned(
          left: 11,
          child: AnimatedBuilder(
            animation: animCtrl,
            builder: (_, __) => Icon(
              Icons.lock,
              color: lockColor.value,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: onPressVisibility,
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: purple,
            ),
          ),
        )
      ],
    );
  }
}

class RevelClip extends CustomClipper<Path> {
  final double animValue;

  RevelClip(this.animValue);
  @override
  Path getClip(Size size) {
    Path path = Path();
    final left = (size.width - 39) * animValue;
    final top = 14 * animValue;
    final reveseAnim = (1 - animValue);
    final width = ((size.width - 30) * reveseAnim) + 30;
    final height = ((size.height - 30) * reveseAnim) + 30;
    final radius = ((15 - 10) * animValue) + 10;
    final rect = Rect.fromLTWH(left, top, width, height);

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    path.addRRect(rrect);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(RevelClip oldClipper) {
    return oldClipper.animValue != animValue;
  }
}
