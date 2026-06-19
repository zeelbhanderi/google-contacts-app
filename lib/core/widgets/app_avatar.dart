import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_colors.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/utils/avatar_helper.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';

enum AppAvatarStyle { filled, pastel }

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.contact,
    required this.size,
    this.style = AppAvatarStyle.filled,
    this.heroTag,
  });

  final ContactEntity contact;
  final double size;
  final AppAvatarStyle style;

  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final fullName = '${contact.firstName}${contact.lastName}';
    final initials = AvatarHelper.initialsFromName(contact.firstName, contact.lastName);

    final isPastel = style == AppAvatarStyle.pastel;
    final backgroundColor = isPastel
        ? AvatarHelper.pastelBackgroundFromName(fullName)
        : AvatarHelper.filledBackgroundFromName(fullName);
    final foregroundColor = isPastel
        ? AvatarHelper.pastelForegroundFromName(fullName)
        : AppColors.onPrimary;

    final avatar = CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor,
      child: Text(
        initials,
        style: AppTextStyles.avatarInitials.copyWith(
          color: foregroundColor,
          fontSize: Rs.sp(size * 0.38),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (heroTag == null) {
      return avatar;
    }

    return Hero(tag: heroTag!, child: avatar);
  }
}
