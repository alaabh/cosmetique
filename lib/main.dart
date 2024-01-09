import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_flutter/cubit/commande_cubit/commande_cubit.dart';
import 'package:projet_flutter/cubit/login_cubit/login_cubit.dart';
import 'package:projet_flutter/cubit/produit/produit_cubit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projet_flutter/firebase_options.dart';
import 'package:projet_flutter/screens/login.dart';
import 'package:get/get.dart';

import 'cubit/singup_cubit/singup_cubit.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
     providers: [
      BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(),
          ),
      BlocProvider<SingupCubit>(
            create: (context) => SingupCubit(),
          ),
      BlocProvider<ProduitCubit>(
            create: (context) => ProduitCubit(),
          ),
      BlocProvider<CommandeCubit>(
            create: (context) => CommandeCubit(),
          ),
     ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        home: const Login(),
      ),
    );
  }
}
