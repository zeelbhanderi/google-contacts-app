import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/date_utils.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_avatar.dart';
import 'package:google_contacts_app/core/widgets/app_loading.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/features/contact_detail/controllers/contact_detail_controller.dart';
import 'package:google_contacts_app/features/contact_detail/views/widgets/action_button_row.dart';
import 'package:google_contacts_app/features/contact_detail/views/widgets/info_section_tile.dart';

class ContactDetailView extends GetView<ContactDetailController> {
  const ContactDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Scaffold(body: AppLoading())
          : const _ContactDetailBody(),
    );
  }
}

class _ContactDetailBody extends GetView<ContactDetailController> {
  const _ContactDetailBody();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final contact = controller.contact.value;
      final colorScheme = Theme.of(context).colorScheme;

      return Scaffold(
        appBar: AppBar(
          title: Text(controller.displayName, style: AppTextStyles.appBarTitle),
          actions: [
            IconButton(
              tooltip: AppStrings.T.favorite,
              icon: Icon(
                contact.isFavorite ? Icons.star : Icons.star_border,
                color: contact.isFavorite ? colorScheme.primary : null,
              ),
              onPressed: controller.onToggleFavorite,
            ),
            IconButton(
              tooltip: AppStrings.T.editContact,
              icon: const Icon(Icons.edit_outlined),
              onPressed: controller.onEdit,
            ),
            IconButton(
              tooltip: AppStrings.T.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: controller.onConfirmDelete,
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(bottom: Rs.dp(24)),
            children: [
              _ProfileHeader(
                contact: contact,
                displayName: controller.displayName,
                subtitle: _profileSubtitle(contact),
              ),
              ActionButtonRow(
                onCall: controller.onCall,
                onSms: controller.onSms,
                onEmail: controller.onEmail,
              ),
              DetailSection(
                tiles: [
                  if (contact.phone != null)
                    DetailInfoTile(
                      label: AppStrings.T.phone,
                      value: contact.phone!,
                      onTap: controller.onCall,
                      onLongPress: () => controller.copyPhone(contact.phone!),
                      showDivider: _hasMoreContactTiles(contact, afterPhone: true),
                    ),
                  if (contact.email != null)
                    DetailInfoTile(
                      label: AppStrings.T.email,
                      value: contact.email!,
                      onTap: controller.onEmail,
                      onLongPress: () => controller.copyEmail(contact.email!),
                      showDivider: contact.nickname != null,
                    ),
                  if (contact.nickname != null)
                    DetailInfoTile(
                      label: AppStrings.T.nickname,
                      value: contact.nickname!,
                      showDivider: false,
                    ),
                ],
              ),
              DetailSection(
                title: AppStrings.T.work,
                tiles: [
                  if (contact.company != null)
                    DetailInfoTile(
                      label: AppStrings.T.company,
                      value: contact.company!,
                      showDivider: contact.jobTitle != null || contact.department != null,
                    ),
                  if (contact.jobTitle != null)
                    DetailInfoTile(
                      label: AppStrings.T.jobTitle,
                      value: contact.jobTitle!,
                      showDivider: contact.department != null,
                    ),
                  if (contact.department != null)
                    DetailInfoTile(
                      label: AppStrings.T.department,
                      value: contact.department!,
                      showDivider: false,
                    ),
                ],
              ),
              DetailSection(
                tiles: [
                  if (contact.birthday != null)
                    DetailInfoTile(
                      label: AppStrings.T.birthday,
                      value: _birthdayText(contact),
                      showDivider: contact.notes != null || contact.websiteUrls.isNotEmpty,
                    ),
                  if (contact.notes != null)
                    DetailInfoTile(
                      label: AppStrings.T.notes,
                      value: contact.notes!,
                      showDivider: contact.websiteUrls.isNotEmpty,
                    ),
                  ...contact.websiteUrls.map(
                    (url) => DetailInfoTile(
                      label: AppStrings.T.website,
                      value: url,
                      onTap: () => controller.openWebsite(url),
                      showDivider: url != contact.websiteUrls.last,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  String? _profileSubtitle(ContactEntity contact) {
    if (contact.company != null && contact.company!.isNotEmpty) {
      return contact.company;
    }
    if (contact.phone != null && contact.phone!.isNotEmpty) {
      return contact.phone;
    }
    if (contact.email != null && contact.email!.isNotEmpty) {
      return contact.email;
    }
    return null;
  }

  bool _hasMoreContactTiles(ContactEntity contact, {required bool afterPhone}) {
    if (!afterPhone) {
      return false;
    }
    return contact.email != null || contact.nickname != null;
  }

  String _birthdayText(ContactEntity contact) {
    return DateUtilsX.formatBirthday(contact.birthday);
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.contact,
    required this.displayName,
    this.subtitle,
  });

  final ContactEntity contact;
  final String displayName;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(Rs.dp(16), Rs.dp(8), Rs.dp(16), Rs.dp(4)),
      child: Column(
        children: [
          AppAvatar(
            contact: contact,
            size: Rs.dp(88),
            style: AppAvatarStyle.pastel,
            heroTag: contact.id,
          ),
          SizedBox(height: Rs.dp(16)),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: AppTextStyles.contactName.copyWith(
              fontSize: Rs.sp(22),
              color: colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: Rs.dp(6)),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
