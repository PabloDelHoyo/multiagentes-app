import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pagina_web/main.dart';
import 'package:pagina_web/bars/app_bar.dart';
import 'package:pagina_web/bars/side_bar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pagina_web/bars/footer_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarDrawer(),
      drawer: NavBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: mq.height * 0.05),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: const Text('Introducción al proyecto',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        mq.width * 0.2, mq.height * 0.05, mq.width * 0.2, 0),
                    child: Text(
                        'Esta es la pagina oficial del proyecto de MineriaDeDatos y SistemasMultiagentes. En ella se encontrará la información relacionada con el proyecto que conllevará el desarrollo de un proceso KDD para la asignatura Minería de Datos. Además, en la asignatura Sistemas Multiagentes desarrollaremos funciones relacionadas con el proceso KDD.\n\n Los vehículos eléctricos han surgido con fuerza en los últimos años, principalmente debido a su colaboración con el medio ambiente. Estos vehículos utilizan una fuente energética que no contamina como la electricidad para cargar sus baterías, al contrario que otros coches de combustión que necesitan diésel o gasolina. Es necesario expandir su uso a lo largo del mundo y en este trabajo queremos encontrar información mediante un proceso KDD sobre los diferentes motivos que pueden llevar a un comprador a decantarse por el vehículo eléctrico, esta información podría ser de utilidad para gobiernos o empresas que quieran ayudar al medio ambiente mediante la mejora de las características que buscan los conductores.',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        textAlign: TextAlign.center),
                  )),
              SizedBox(height: mq.height * 0.05),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: const Text('Pestañas Página Web',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    mq.width * 0.2,
                    mq.height * 0.05,
                    mq.width * 0.2,
                    0,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 20),
                      children: [
                        TextSpan(
                          text: 'En la pestaña ',
                        ),
                        TextSpan(
                          text: 'bases de datos',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text:
                                ' podremos encontrar los datos utilizados en el proceso KDD. Tenemos tres esquemas que representan los distintos pasos que se han realizado:\n\n'
                                '1. RAW: Almacenamos los datos en crudo.\n'
                                '2. SILVER: Almacenamos los datos tras aplicar técnicas de limpieza y transformación.\n'
                                '3. GOLD: Almacenamos las tarjetas de datos sobre las que hemos construido nuestras hipótesis.')
                      ],
                    ),
                  ),
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    mq.width * 0.2,
                    mq.height * 0.05,
                    mq.width * 0.2,
                    0,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 20),
                      children: [
                        TextSpan(
                          text: 'En la pestaña ',
                        ),
                        TextSpan(
                          text: 'Recomendador',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              ', podrás elegir el vehículo eléctrico más acorde a tus necesidades con nuestro sistema de reglas que buscará entre diversos vehículos del mercado y te ofrecerá los más óptimos.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    mq.width * 0.2,
                    mq.height * 0.05,
                    mq.width * 0.2,
                    0,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 20),
                      children: [
                        TextSpan(
                          text:
                              'Para conectarnos y mostrar los registros de la base de datos ha sido necesario construir una ',
                        ),
                        TextSpan(
                          text: 'API\n',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://multiagentes.programadormanchego.es/api/docs');
                            },
                        ),
                        TextSpan(
                          text:
                              'Podras encontrar más información respecto a la construcción del proyecto en el repositorio de ',
                        ),
                        TextSpan(
                          text: 'Github',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://github.com/Mohamed11302/MineriaDeDatosYSistemasMultiagentes');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: mq.height * 0.05),
              buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }
}
