import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/contact_list_tile.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/features/contacts/controllers/contacts_controller.dart';

class ContactSlidableTile extends GetView<ContactsController> {
  const ContactSlidableTile({super.key, required this.contact, required this.listIndex});

  final ContactEntity contact;
  final int listIndex;

  @override
  Widget build(BuildContext context) {
    final isLastInSection = controller.isLastContactInSection(listIndex);

    return Padding(
      padding: EdgeInsets.fromLTRB(Rs.dp(16), 0, Rs.dp(16), isLastInSection ? Rs.dp(10) : 0),
      child: DecoratedBox(
        decoration: isLastInSection
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: Rs.dp(10),
                    offset: Offset(0, Rs.dp(2)),
                  ),
                ],
              )
            : const BoxDecoration(),
        child: Slidable(
          key: ValueKey(contact.id),
          groupTag: 'contacts',
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (_) => controller.onSwipeDelete(contact.id),
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                icon: Icons.delete_outline,
                label: AppStrings.T.delete,
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (_) => controller.onToggleFavorite(contact.id),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                icon: contact.isFavorite ? Icons.star : Icons.star_border,
                label: AppStrings.T.favorite,
              ),
            ],
          ),
          child: ContactListTile(
            contact: contact,
            onTap: () => controller.onContactTap(contact),
            showDivider: !isLastInSection,
            borderRadius: controller.contactTileBorderRadius(listIndex),
          ),
        ),
      ),
    );
  }
}
