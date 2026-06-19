import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/data/datasources/local/contact_local_datasource.dart';
import 'package:google_contacts_app/data/datasources/remote/contact_remote_datasource.dart';
import 'package:google_contacts_app/data/repositories/contact_repository_impl.dart';
import 'package:google_contacts_app/domain/repositories/i_contact_repository.dart';
import 'package:google_contacts_app/domain/usecases/add_contact.dart';
import 'package:google_contacts_app/domain/usecases/delete_contact.dart';
import 'package:google_contacts_app/domain/usecases/get_all_contacts.dart';
import 'package:google_contacts_app/domain/usecases/get_contact_by_id.dart';
import 'package:google_contacts_app/domain/usecases/get_favorites.dart';
import 'package:google_contacts_app/domain/usecases/search_contacts.dart';
import 'package:google_contacts_app/domain/usecases/toggle_favorite.dart';
import 'package:google_contacts_app/domain/usecases/update_contact.dart';

void registerContactDependencies() {
  if (Get.isRegistered<IContactRepository>()) {
    return;
  }

  Get.lazyPut<IContactLocalDatasource>(ContactLocalDatasourceImpl.new);
  Get.lazyPut<IContactRemoteDatasource>(ContactRemoteDatasourceImpl.new);
  Get.lazyPut(Connectivity.new);
  Get.lazyPut<IContactRepository>(
    () => ContactRepositoryImpl(
      localDatasource: Get.find<IContactLocalDatasource>(),
      remoteDatasource: Get.find<IContactRemoteDatasource>(),
      connectivity: Get.find<Connectivity>(),
    ),
    fenix: true,
  );
}

void _lazyPutUseCase<T>(T Function() builder) {
  registerContactDependencies();
  if (!Get.isRegistered<T>()) {
    Get.lazyPut<T>(builder);
  }
}

void registerContactsUseCases() {
  _lazyPutUseCase(() => GetAllContacts(Get.find<IContactRepository>()));
  _lazyPutUseCase(() => SearchContacts(Get.find<IContactRepository>()));
  _lazyPutUseCase(() => DeleteContact(Get.find<IContactRepository>()));
  _lazyPutUseCase(() => ToggleFavorite(Get.find<IContactRepository>()));
  _lazyPutUseCase(() => AddContact(Get.find<IContactRepository>()));
}

void registerFavoritesUseCases() {
  _lazyPutUseCase(() => GetFavorites(Get.find<IContactRepository>()));
  _lazyPutUseCase(() => ToggleFavorite(Get.find<IContactRepository>()));
}

void registerContactDetailUseCases() {
  _lazyPutUseCase(() => GetContactById(Get.find<IContactRepository>()));
  _lazyPutUseCase(() => DeleteContact(Get.find<IContactRepository>()));
  _lazyPutUseCase(() => ToggleFavorite(Get.find<IContactRepository>()));
}

void registerContactFormUseCases() {
  _lazyPutUseCase(() => AddContact(Get.find<IContactRepository>()));
  _lazyPutUseCase(() => UpdateContact(Get.find<IContactRepository>()));
}

void registerSettingsUseCases() {
  _lazyPutUseCase(() => GetAllContacts(Get.find<IContactRepository>()));
  _lazyPutUseCase(() => DeleteContact(Get.find<IContactRepository>()));
}
