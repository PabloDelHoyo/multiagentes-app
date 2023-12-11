import 'package:flutter/material.dart';
import 'package:pagina_web/pages/bbdd_page.dart';
import 'package:pagina_web/pages/home_page.dart';
import 'package:pagina_web/pages/recomendador.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatelessWidget {
  static const String INICIO = 'Inicio';
  static const String BASE_DE_DATOS = 'Base De Datos';
  static const String API = 'API';
  static const String RECOMENDADOR = 'Recomendador';

  NavBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 50),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(INICIO),
            onTap: () => onItemPressed(context, index: INICIO),
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text(BASE_DE_DATOS),
            onTap: () => onItemPressed(context, index: BASE_DE_DATOS),
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text(API),
            onTap: () => onItemPressed(context, index: API),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text(RECOMENDADOR),
            onTap: () => onItemPressed(context, index: RECOMENDADOR),
          ),
        ],
      ),
    );
  }

  void onItemPressed(BuildContext context, {required String index}) async {
    Navigator.pop(context);

    switch (index) {
      case INICIO:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case BASE_DE_DATOS:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BBDD4()));
        break;
      case API:
          final Uri uri = Uri.parse('https://multiagentes.programadormanchego.es/api/docs');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            throw 'No se pudo abrir el enlace: ${uri.toString()}';
          }
        break;
      case RECOMENDADOR:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Prediccion_Page()));
        break;
    }
  }
}
