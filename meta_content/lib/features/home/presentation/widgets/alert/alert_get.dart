import 'package:flutter/material.dart';
import 'package:meta_content/features/home/presentation/widgets/buttons/primary_button.dart';
import 'package:meta_content/features/home/presentation/widgets/custom_input.dart';
import 'package:nav_service/nav_service.dart';

class AlertGet extends StatelessWidget {
  const AlertGet({super.key, required this.onPressed, required this.text});
  final Function(String) onPressed;
  final TextEditingController text;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Ingresa Id'),
      content: SizedBox(
        height: 80,
        child: CustomInputField(
          controller: text,
        ),
      ),
      actions: [
        PrimaryButton(
          borderRadius: 59,
          backgroundColor: colors.secondaryContainer,
          ischarge: true,
          onPressed: () async {
            await onPressed(text.text);
            NavService.pop();
          },
          title: 'Ok',
          textColor: Colors.black87,
        )
      ],
    );
  }
}
