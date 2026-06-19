import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/app.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/data/datasources/local/db_helper.dart';
import 'package:google_contacts_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DatabaseHelper.instance.database;
  Rs.initFromView();
  runApp(const MyApp());
}
