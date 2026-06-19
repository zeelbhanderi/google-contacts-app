import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/avatar_helper.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_loading.dart';
import 'package:google_contacts_app/core/widgets/app_image_view.dart';
import 'package:google_contacts_app/features/auth/controllers/auth_controller.dart';
import 'package:google_contacts_app/features/contact_detail/views/widgets/info_section_tile.dart';
import 'package:google_contacts_app/features/settings/controllers/settings_controller.dart';
import 'package:google_contacts_app/gen/assets.gen.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.T.settings, style: AppTextStyles.appBarTitle),
      ),
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isProcessing.value) {
      return const AppLoading();
    }

    return ListView(
      padding: EdgeInsets.only(top: Rs.dp(8), bottom: Rs.dp(24)),
      children: [
        const _AccountHeader(),
        DetailSection(
          title: AppStrings.T.display,
          tiles: [
            DetailInfoTile(
              label: AppStrings.T.theme,
              value: controller.themeModeLabel,
              onTap: controller.showThemePicker,
            ),
            DetailInfoTile(
              label: AppStrings.T.defaultCountryCode,
              value: controller.defaultCountryCode.value,
              showDivider: false,
            ),
          ],
        ),
        _SettingsCard(
          title: AppStrings.T.data,
          children: [
            DetailInfoTile(
              label: AppStrings.T.storageInfo,
              value: AppStrings.T.contactCount(controller.contactCount.value),
            ),
            _SettingsActionTile(
              iconPath: Assets.icons.icDelete,
              label: AppStrings.T.deleteAllContacts,
              isDestructive: true,
              onTap: controller.deleteAllContacts,
              showDivider: false,
            ),
          ],
        ),
        _SettingsCard(
          title: AppStrings.T.account,
          children: [
            _SettingsActionTile(
              iconPath: Assets.icons.icLogout,
              label: AppStrings.T.signOut,
              isDestructive: true,
              onTap: controller.signOut,
              showDivider: false,
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: Rs.dp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              Rs.dp(16),
              Rs.dp(8),
              Rs.dp(16),
              Rs.dp(6),
            ),
            child: Text(
              title,
              style: AppTextStyles.sectionHeader.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Rs.dp(16)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Rs.dp(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: Rs.dp(10),
                    offset: Offset(0, Rs.dp(2)),
                  ),
                ],
              ),
              child: Material(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(Rs.dp(12)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AuthController>()) {
      return const SizedBox.shrink();
    }

    final authController = Get.find<AuthController>();

    return Obx(() {
      final user = authController.firebaseUser.value;
      if (user == null) {
        return const SizedBox.shrink();
      }

      final colorScheme = Theme.of(context).colorScheme;
      final displayName = _displayName(user);
      final email = user.email ?? '';

      return Padding(
        padding: EdgeInsets.fromLTRB(Rs.dp(16), Rs.dp(8), Rs.dp(16), Rs.dp(16)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Rs.dp(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: Rs.dp(10),
                offset: Offset(0, Rs.dp(2)),
              ),
            ],
          ),
          child: Material(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(Rs.dp(12)),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: EdgeInsets.all(Rs.dp(16)),
              child: Row(
                children: [
                  _UserAvatar(user: user, displayName: displayName),
                  SizedBox(width: Rs.dp(14)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.contactName.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (email.isNotEmpty) ...[
                          SizedBox(height: Rs.dp(4)),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  String _displayName(User user) {
    final name = user.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    return user.email ?? AppStrings.T.account;
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.user, required this.displayName});

  final User user;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final photoUrl = user.photoURL;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: Rs.dp(28),
        backgroundColor: colorScheme.primaryContainer,
        backgroundImage: NetworkImage(photoUrl),
      );
    }

    final parts = displayName.split(' ');
    final initials = AvatarHelper.initialsFromName(
      parts.first,
      parts.length > 1 ? parts.last : '',
    );

    return CircleAvatar(
      radius: Rs.dp(28),
      backgroundColor: AvatarHelper.pastelBackgroundFromName(displayName),
      child: Text(
        initials,
        style: AppTextStyles.avatarInitials.copyWith(
          color: AvatarHelper.pastelForegroundFromName(displayName),
          fontSize: Rs.sp(18),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.showDivider = true,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = isDestructive ? colorScheme.error : colorScheme.primary;
    final iconBackground = isDestructive
        ? colorScheme.errorContainer.withValues(alpha: 0.55)
        : colorScheme.primaryContainer.withValues(alpha: 0.55);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Rs.dp(16),
                vertical: Rs.dp(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: Rs.dp(40),
                    height: Rs.dp(40),
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(Rs.dp(10)),
                    ),
                    alignment: Alignment.center,
                    child: AppImageView(
                      imagePath: iconPath,
                      width: Rs.dp(20),
                      height: Rs.dp(20),
                      color: accentColor,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: Rs.dp(14)),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: Rs.dp(20),
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: Rs.dp(70),
            endIndent: Rs.dp(16),
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
      ],
    );
  }
}
