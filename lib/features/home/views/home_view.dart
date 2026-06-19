import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/constants/app_constants.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/features/contacts/views/contacts_view.dart';
import 'package:google_contacts_app/features/favorites/views/favorites_view.dart';
import 'package:google_contacts_app/features/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.currentTab.value == HomeTabIndex.contacts
                ? AppStrings.T.contacts
                : AppStrings.T.favorites,
            style: AppTextStyles.appBarTitle,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: controller.openSettings),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.currentTab.value,
            children: const [ContactsView(), FavoritesView()],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => NavigationBar(
            selectedIndex: controller.currentTab.value,
            onDestinationSelected: controller.changeTab,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: AppStrings.T.contacts,
              ),
              NavigationDestination(
                icon: const Icon(Icons.star_border),
                selectedIcon: const Icon(Icons.star),
                label: AppStrings.T.favorites,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.openAddContact,
        elevation: 2,
        highlightElevation: 4,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rs.dp(16))),
        child: const Icon(Icons.add),
      ),
    );
  }
}
