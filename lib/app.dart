import 'package:flutter/material.dart';
import 'package:untitled8/models/product_model.dart';
import 'package:untitled8/ui/screens/create_product_screen.dart';
import 'package:untitled8/ui/screens/edit_product_screen.dart';
import 'package:untitled8/ui/screens/product_list_screen.dart';

class CRUDApp extends StatelessWidget {
  const CRUDApp({super.key});

  static Color appThemeColor = const Color(0xFFC300A3);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings){
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) {
            return const ProductListScreen();
          });
        } else if (settings.name == CreateProductScreen.name) {
          return MaterialPageRoute(
              builder: (context) => const CreateProductScreen());
        } else if (settings.name == EditProductScreen.name) {
          final Product product = settings.arguments
              as Product; //its taking the 'product' which we gave on arguments.+++
          return MaterialPageRoute(
            builder: (context) => EditProductScreen(product: product),
          );
        }
      },
    );
  }

  ThemeData _buildThemeData() {   //Just Extracted ThemeData to a Method.
    return ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: appThemeColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16))),
          shadowColor: Colors.purple,
        ),
        iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.black))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: appThemeColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: appThemeColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
        ));
  }
}
