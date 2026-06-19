import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_action_button.dart';
import 'package:google_contacts_app/core/widgets/app_avatar.dart';
import 'package:google_contacts_app/core/widgets/app_empty_state.dart';
import 'package:google_contacts_app/core/widgets/app_loading.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/features/favorites/controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value) {
      return const AppLoading();
    }

    if (controller.contacts.isEmpty) {
      return AppEmptyState(
        icon: Icons.star_border,
        title: AppStrings.T.noFavorites,
        subtitle: AppStrings.T.noFavoritesSubtitle,
      );
    }

    return RefreshIndicator(
      onRefresh: controller.loadFavorites,
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(Rs.dp(16), Rs.dp(8), Rs.dp(16), Rs.dp(88)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Rs.dp(12),
          mainAxisSpacing: Rs.dp(12),
          childAspectRatio: 0.82,
        ),
        itemCount: controller.contacts.length,
        itemBuilder: (context, index) {
          final contact = controller.contacts[index];
          return _FavoriteCard(contact: contact);
        },
      ),
    );
  }
}

class _FavoriteCard extends GetView<FavoritesController> {
  const _FavoriteCard({required this.contact});

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = '${contact.firstName} ${contact.lastName}'.trim();
    final subtitle = _subtitle(contact);
    final hasPhone = contact.phone != null && contact.phone!.isNotEmpty;

    return DecoratedBox(
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
        child: InkWell(
          onTap: () => controller.onContactTap(contact),
          onLongPress: () => controller.onRemoveFavorite(contact.id),
          child: Padding(
            padding: EdgeInsets.all(Rs.dp(14)),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppAvatar(
                      contact: contact,
                      size: Rs.dp(56),
                      style: AppAvatarStyle.pastel,
                    ),
                    Positioned(
                      top: -Rs.dp(2),
                      right: -Rs.dp(2),
                      child: Container(
                        padding: EdgeInsets.all(Rs.dp(4)),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: Rs.dp(4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.star_rounded,
                          size: Rs.dp(14),
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Rs.dp(12)),
                Text(
                  displayName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.contactName.copyWith(
                    fontSize: Rs.sp(15),
                    color: colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: Rs.dp(4)),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const Spacer(),
                if (hasPhone)
                  AppActionButton(
                    icon: Icons.call_outlined,
                    label: AppStrings.T.call,
                    layout: AppActionButtonLayout.row,
                    onTap: () => controller.onCall(contact),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _subtitle(ContactEntity contact) {
    if (contact.phone != null && contact.phone!.isNotEmpty) {
      return contact.phone;
    }
    if (contact.email != null && contact.email!.isNotEmpty) {
      return contact.email;
    }
    if (contact.company != null && contact.company!.isNotEmpty) {
      return contact.company;
    }
    return null;
  }
}
