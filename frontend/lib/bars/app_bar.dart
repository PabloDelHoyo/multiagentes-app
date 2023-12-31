import 'package:flutter/material.dart';

class MyAppBarDrawer extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: Colors.white),
      ),
      title: Text(
        'Programador Manchego',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily:
              'CustomFont', // Reemplaza 'CustomFont' con el nombre de tu fuente
        ),
      ),
      leading: Builder(
        builder: (BuildContext innerContext) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              Scaffold.of(innerContext).openDrawer();
            },
          );
        },
      ),
      centerTitle: true,
    );
  }
}
