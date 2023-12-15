import 'package:flutter/material.dart';
import 'package:pagina_web/bars/app_bar.dart';
import 'package:pagina_web/bars/footer_bar.dart';
import 'package:pagina_web/bars/side_bar.dart';
import 'package:pagina_web/main.dart';
import 'package:animate_do/animate_do.dart';

class Prediccion_Page extends StatefulWidget {
  const Prediccion_Page({super.key});

  @override
  State<Prediccion_Page> createState() => _Prediccion_PageState();
}

class _Prediccion_PageState extends State<Prediccion_Page> {
  String _tipoFamilia = "";
  String _tipoUso = "";
  String _rangoPrecio = "";
  String _color = "";
  final List<int> numeroDeAsientos = [2, 4, 5, 6, 7];
  int _selectedAsientos = 0;
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                                'Número de asientos',
                                style: TextStyle(fontSize: 16),
                              ),
                            SizedBox(height: mq.height*0.01,),
                            Container(
                              padding: EdgeInsets.all(15), // Ajusta el espacio
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
                                value: _selectedAsientos,
                                //icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                //style: TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                height: 2,
                                color: Colors.white,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAsientos = value!;
                                  });
                                },
                                items: <int>[0, 1, 2, 3, 4, 5, 6]
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
                            Container(
                              height: mq.height * 0.1,
                              width: mq.width * 0.3,
                              padding: EdgeInsets.all(15), // Ajusta el espacio
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
                              child: TextField(
                                onChanged: (text) {
                                  setState(() {
                                    _tipoUso = text;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Tipo de Uso",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: mq.width * 0.05,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(15), // Ajusta el espacio
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
                              child: TextField(
                                onChanged: (text) {
                                  setState(() {
                                    _rangoPrecio = text;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Rango de Precio",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: mq.height * 0.05,
                            ),
                            Container(
                              height: mq.height * 0.1,
                              width: mq.width * 0.3,
                              padding: EdgeInsets.all(15), // Ajusta el espacio
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
                              child: TextField(
                                onChanged: (text) {
                                  setState(() {
                                    _color = text;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Color",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
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
                        onPressed: () {
                          // Lógica cuando se presiona el botón
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
}
