import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pagina_web/main.dart';

Widget buildFooter(BuildContext context) {
  return Container(
    width: mq.width,
    color: Colors.grey[200],
    padding: EdgeInsets.symmetric(vertical: mq.height * 0.05, horizontal: mq.width * 0.01),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Información de contacto
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contacto:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            // Usar RichText para convertir correos electrónicos en enlaces
            RichText(
              text: TextSpan(
                children: [
                  _buildEmailLink('diego.cordero@alu.uclm.es'),
                  TextSpan(text: '     '),
                  _buildEmailLink('enrique.albalate@alu.uclm.es'),
                  TextSpan(text: '     '),
                  _buildEmailLink('lucia.ancos@alu.uclm.es'),
                  TextSpan(text: '     '),
                  _buildEmailLink('pablo.hoyo@alu.uclm.es'),
                  TextSpan(text: '     '),
                  _buildEmailLink('mohamed.essalhi@alu.uclm.es'),
                ],
              ),
            ),
          ],
        ),
        // Agregar enlace de GitHub
        _buildGitHubLink(),
      ],
    ),
  );
}

Widget _buildGitHubLink() {
  return InkWell(
    onTap: () {
      // Puedes agregar acciones al hacer clic en el enlace de GitHub
      launch('https://github.com/Mohamed11302/MineriaDeDatosYSistemasMultiagentes');
    },
    child: Text(
      'GitHub',
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

TextSpan _buildEmailLink(String email) {
  return TextSpan(
    text: email,
    style: TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
    recognizer: TapGestureRecognizer()
      ..onTap = () {
        // Puedes agregar acciones al hacer clic en el enlace de correo electrónico
        launch('mailto:$email');
      },
  );
}
