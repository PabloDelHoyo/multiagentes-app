import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pagina_web/bars/app_bar.dart';
import 'package:pagina_web/bars/side_bar.dart';

class BBDD4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MyAppBarDrawer(),
        drawer: NavBar(),
        body: Column(
          children: [
            AppBar(
              title: Text(
                        'Esquemas',
                        style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.blue[200],
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  String category;
                  String apiUrl;

                  if (index == 0) {
                    category = 'RAW';
                    apiUrl = 'https://multiagentes.programadormanchego.es/api/raw';
                  } else if (index == 1) {
                    category = 'SILVER';
                    apiUrl = 'https://multiagentes.programadormanchego.es/api/silver';
                  } else {
                    category = 'GOLD';
                    apiUrl = 'https://multiagentes.programadormanchego.es/api/gold';
                  }

                  return Card(
                    child: ListTile(
                      title: Text(category),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => bbdd_schemas(
                              apiUrlBase: apiUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        
      ),
    );
  }
}

class bbdd_schemas extends StatefulWidget {
  final String apiUrlBase;
  const bbdd_schemas({Key? key, required this.apiUrlBase}) : super(key: key);

  @override
  _bbdd_schemasState createState() => _bbdd_schemasState();
}

class _bbdd_schemasState extends State<bbdd_schemas> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MyAppBarDrawer(),
        drawer: NavBar(),
        body: Column(
          children: [
            AppBar(
              title: Text(
                        'Tablas del esquema',
                        style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.blue[200],
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchTables(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No tables available.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final tableName = snapshot.data![index]['name'];
                        return Card(
                          child: ListTile(
                            title: Text(tableName),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpecificTablePage(
                                    tableName: tableName, apiUrlBase: widget.apiUrlBase,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchTables() async {
    final response = await http.get(Uri.parse(widget.apiUrlBase));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonResponse);
    } else {
      throw Exception('Failed to load tables');
    }
  }
}


class SpecificTablePage extends StatefulWidget {
  final String tableName;
  final String apiUrlBase;
  const SpecificTablePage({Key? key, required this.tableName, required this.apiUrlBase})
      : super(key: key);

  @override
  _SpecificTablePageState createState() => _SpecificTablePageState();
}
class _SpecificTablePageState extends State<SpecificTablePage> {
  late int offset;
  late int pageSize;
  List<Map<String, dynamic>> tableData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    offset = 0;
    pageSize = 20;
    loadTableData();
  }

  Future<void> loadTableData() async {
    setState(() {
      isLoading = true;
      offset += 20;
    });

    final apiUrl =
        '${widget.apiUrlBase}${"/"}${widget.tableName}?size=$pageSize&offset=$offset';
    print(apiUrl);
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      final List<Map<String, dynamic>> newData =
          List<Map<String, dynamic>>.from(jsonResponse);
      setState(() {
        tableData.addAll(newData);
      });
    } else {
      throw Exception('Failed to load specific table');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _verticalScrollController = ScrollController();
    final _horizontalScrollController = ScrollController();

    return Scaffold(
      appBar: MyAppBarDrawer(),
      body: Column(
        children: [
          AppBar(
            title: Text(widget.tableName),
            backgroundColor: Colors.blue[200],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: AdaptiveScrollbar(
              underColor: Colors.blueGrey.withOpacity(0.3),
              sliderDefaultColor: Colors.grey.withOpacity(0.7),
              sliderActiveColor: Colors.grey,
              controller: _verticalScrollController,
              child: AdaptiveScrollbar(
                controller: _horizontalScrollController,
                position: ScrollbarPosition.bottom,
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: Colors.grey.withOpacity(0.7),
                sliderActiveColor: Colors.grey,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                      child: tableData.isNotEmpty
                          ? DataTable(
                              columns: tableData.first.keys
                                  .map((columnName) =>
                                      DataColumn(label: Text(columnName)))
                                  .toList(),
                              rows: tableData.map((rowData) {
                                return DataRow(
                                  cells: rowData.keys
                                      .map((columnName) => DataCell(
                                          Text(rowData[columnName].toString())))
                                      .toList(),
                                );
                              }).toList(),
                            )
                          : Center(
                              child: Text(
                                  'No data available for ${widget.tableName}.'),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: NavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading
            ? null // Deshabilita el botón cuando isLoading es true
            : () {
                loadTableData();
              },
        child: isLoading
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Icon(Icons.add), // Puedes cambiar este icono según tus necesidades
      ),
    );
  }
}
