import 'package:flutter/material.dart';

class ButtonStatus extends StatelessWidget {
  const ButtonStatus({
    super.key,  this.title, required this.icon, this.onPressed,  this.heightWidth = 70, this.color
  });
final String? title;
final IconData icon;
final Function()? onPressed;
final double heightWidth;
final Color? color;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Positioned(
      bottom: 5,
      right: 5,
      child: Container(
        height: heightWidth,
        width: heightWidth,
        decoration: BoxDecoration(
            color:color?? colors.tertiaryContainer,
            borderRadius: BorderRadius.circular(50)),
        child: IconButton(
            onPressed: onPressed,
            icon: (title!= null) ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
               Text(title??'')
              ],
            ):Icon(icon)
            ),
      ),
    );
  }
}
