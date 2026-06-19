import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/features/contacts/controllers/contacts_controller.dart';

class AlphabetScrollBar extends GetView<ContactsController> {
  const AlphabetScrollBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final letters = controller.availableLetters;
        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: Rs.dp(4)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ContactsController.alphabet
                  .where(letters.contains)
                  .map(
                    (letter) => GestureDetector(
                      onTap: () => controller.scrollToLetter(letter),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Rs.dp(1)),
                        child: Text(
                          letter,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
