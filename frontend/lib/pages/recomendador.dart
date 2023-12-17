import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pagina_web/bars/app_bar.dart';
import 'package:pagina_web/bars/footer_bar.dart';
import 'package:pagina_web/bars/side_bar.dart';
import 'package:pagina_web/main.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;

class Prediccion_Page extends StatefulWidget {
  const Prediccion_Page({super.key});

  @override
  State<Prediccion_Page> createState() => _Prediccion_PageState();
}

class _Prediccion_PageState extends State<Prediccion_Page> {
  static const String api_url_base = String.fromEnvironment('API_URL', defaultValue: 'https://multiagentes.programadormanchego.es/api');
  final List<int> numeroDeAsientos = [2, 4, 5, 6, 7];
  final List<String> tipos_de_autonomia = [
    "Distancias Cortas",
    "Viajes Moderados",
    "Viajes Largos"
  ];
  int _min_num_asientos = 2;
  double _max_precio = 20000;
  String _autonomia = "Distancias Cortas";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarDrawer(),
      drawer: NavBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Text(
                  'Conoce tu vehículo eléctrico ideal',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Rellena los siguientes datos y te diremos cuál es tu coche ideal',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: mq.height * 0.1),
                // Formulario con 4 campos
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'Mínimo número de asientos',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: mq.height * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                height: mq.height * 0.1,
                                width: mq.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, .1),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: DropdownButton<int>(
                                  value: _min_num_asientos,
                                  iconSize: 24,
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.white,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _min_num_asientos = value!;
                                    });
                                  },
                                  items: numeroDeAsientos
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: mq.height * 0.05,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: mq.width * 0.05,
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'Autonomía del vehículo',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: mq.height * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                height: mq.height * 0.1,
                                width: mq.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, .1),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: DropdownButton<String>(
                                  value: _autonomia,
                                  iconSize: 24,
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.white,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _autonomia = value!;
                                    });
                                  },
                                  items: tipos_de_autonomia
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: mq.height * 0.05,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Precio máximo',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: mq.height * 0.01,
                            ),
                            Container(
                              height: mq.height * 0.1,
                              width: mq.width * 0.3,
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, .1),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Slider(
                                    value: _max_precio,
                                    onChanged: (value) {
                                      setState(() {
                                        _max_precio = value;
                                      });
                                    },
                                    min: 20000,
                                    max: 220000,
                                    divisions: 20,
                                    label: _max_precio.round().toString(),
                                  ),
                                  Text(
                                    "Cantidad: ${_max_precio.round().toString()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: mq.height * 0.1,
                ),
                Center(
                  child: FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Container(
                      width: mq.width *
                          0.5, // Ajusta el valor de acuerdo a tus preferencias
                      child: MaterialButton(
                        onPressed: () async{
                          Map<String, String> marca_modelo = await hacerPeticionPost(_max_precio.round(),_min_num_asientos, _autonomia);
                          if (marca_modelo['brand']=='' || marca_modelo['model']==''){
                              showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("No encontrado"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        "No existen vehículos eléctricos con esas características"),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cierra el cuadro de diálogo
                                    },
                                    child: Text("Cerrar"),
                                  ),
                                ],
                              );
                            },
                          );
                          }
                          else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Tu coche ideal"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        "Marca: ${marca_modelo['brand']}"),
                                    Text("Modelo: ${marca_modelo['model']}"),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cierra el cuadro de diálogo
                                    },
                                    child: Text("Cerrar"),
                                  ),
                                ],
                              );
                            },
                          );
                          }
                        },
                        height: mq.height * 0.1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "Enviar Peticion",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: mq.height * 0.2,
                ),

                buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, String>> hacerPeticionPost(int max_price, int min_num_seats, String type_autonomy) async {
  final String url = api_url_base + '/recommend';
  int autonomy = 0;
  int autonomy_margin = 0;
  String brand = '';
  String model = '';
  if (type_autonomy == 'Distancias Cortas'){
    autonomy = 100;
    autonomy_margin = 100;
  }
  else if (type_autonomy == 'Viajes Moderados'){
    autonomy = 300;
    autonomy_margin = 100;
  }
  else if (type_autonomy == 'Viajes Largos'){
    autonomy = 700;
    autonomy_margin = 300;
  }

  // Datos que quieres enviar en el cuerpo de la petición
  Map<String, dynamic> datos = {
    "max_price": max_price,
    "min_num_seats": min_num_seats,
    "autonomy": autonomy,
    "autonomy_margin": autonomy_margin,
  };

  // Realizar la petición POST
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(datos),
  );

  // Verificar el código de respuesta
  if (response.statusCode == 200) {
    print("Respuesta exitosa: ${response.body}");
    List<dynamic> jsonResponse = json.decode(response.body);

    // Verificar si hay elementos en la respuesta
    if (jsonResponse.isNotEmpty) {
      // Extraer los campos 'brand' y 'model' del primer elemento
      brand = jsonResponse[0]['brand'] ?? '';
      model = jsonResponse[0]['model'] ?? '';
    } 
  }
  else {
    print("Error en la petición: ${response.statusCode}");
  }
  return {'brand': brand, 'model': model};
}


}
