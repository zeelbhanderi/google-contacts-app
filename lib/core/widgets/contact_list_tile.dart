import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_avatar.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';

class ContactListTile extends StatelessWidget {
  const ContactListTile({
    super.key,
    required this.contact,
    required this.onTap,
    this.showDivider = true,
    this.borderRadius = BorderRadius.zero,
  });

  final ContactEntity contact;
  final VoidCallback onTap;
  final bool showDivider;
  final BorderRadius borderRadius;

  static const double _avatarSize = 40;
  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 12;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = _displayName;

    return Material(
      color: colorScheme.surface,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Rs.dp(_horizontalPadding),
                vertical: Rs.dp(_verticalPadding),
              ),
              child: Row(
                children: [
                  AppAvatar(
                    contact: contact,
                    size: Rs.dp(_avatarSize),
                    style: AppAvatarStyle.pastel,
                    heroTag: contact.id,
                  ),
                  SizedBox(width: Rs.dp(12)),
                  Expanded(
                    child: Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.contactName.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showDivider)
              Divider(
                height: 1,
                thickness: 1,
                indent: Rs.dp(_horizontalPadding + _avatarSize + 12),
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
          ],
        ),
      ),
    );
  }

  String get _displayName {
    final name = '${contact.firstName} ${contact.lastName}'.trim();
    if (contact.nickname != null && contact.nickname!.isNotEmpty) {
      return '$name (${contact.nickname})';
    }
    return name;
  }
}
