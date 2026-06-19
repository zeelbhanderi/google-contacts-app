import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_empty_state.dart';
import 'package:google_contacts_app/core/widgets/app_loading.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/features/contacts/controllers/contacts_controller.dart';
import 'package:google_contacts_app/features/contacts/views/widgets/alphabet_scroll_bar.dart';
import 'package:google_contacts_app/features/contacts/views/widgets/contact_slidable_tile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.T.searchContacts,
                hintStyle: AppTextStyles.bodyMedium,
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
              ),
              style: AppTextStyles.bodyMedium,
              onChanged: controller.onSearchChanged,
            ),
          ),
        ),
        SliverFillRemaining(child: Obx(_buildBody)),
      ],
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const AppLoading();
    }

    if (controller.contacts.isEmpty) {
      return AppEmptyState(
        icon: Icons.contacts_outlined,
        title: AppStrings.T.noContactsYet,
        subtitle: AppStrings.T.noContactsYetSubtitle,
      );
    }

    return Stack(
      children: [
        SlidableAutoCloseBehavior(
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: ScrollablePositionedList.builder(
              padding: EdgeInsets.only(top: Rs.dp(8), bottom: Rs.dp(88)),
              itemCount: controller.flatItemCount,
              itemScrollController: controller.itemScrollController,
              itemPositionsListener: controller.itemPositionsListener,
              itemBuilder: _buildItem,
            ),
          ),
        ),
        const AlphabetScrollBar(),
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = controller.itemAt(index);
    if (item is String) {
      return _SectionHeader(letter: item);
    }
    if (item is ContactEntity) {
      return ContactSlidableTile(contact: item, listIndex: index);
    }
    return const SizedBox.shrink();
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(Rs.dp(16), Rs.dp(16), Rs.dp(16), Rs.dp(6)),
      child: Text(
        letter,
        style: AppTextStyles.sectionHeader.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
