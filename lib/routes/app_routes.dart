import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/screen.dart';

class AppRoutes {
  static const initialRoute = 'login';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'home': (BuildContext context) => const HomeScreen(), 
    'list_product': (BuildContext context) => const ListProductScreen(),
    'edit_product': (BuildContext context) => const EditProductScreen(),
    'view_product': (BuildContext context) => const ViewProductScreen(),
    'new_product': (BuildContext context) => const CreateProductScreen(),
    'list_category': (BuildContext context) => CategoryScreen(),
    'list_provider': (BuildContext context) => ProviderScreen()
  };


  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    //Control de rutas no existentes
    return MaterialPageRoute(
      builder: (context) {
        return const ErrorScreen();
      },
    );
  }
}

