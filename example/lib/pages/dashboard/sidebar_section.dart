import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class SidebarSection extends StatelessWidget {
  const SidebarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 10),
          FlutterLogo(size: 75),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              QR.to('dashboard/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Stores'),
            onTap: () {
              QR.to('dashboard/stores');
            },
          ),
          ListTile(
            leading: Icon(Icons.gif_box),
            title: Text('Products'),
            onTap: () {
              QR.to('dashboard/products');
            },
          )
        ],
      ),
    );
  }
}
