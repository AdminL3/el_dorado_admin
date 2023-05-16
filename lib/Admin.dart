import 'package:flutter/material.dart';
import 'Functions.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.black, Colors.blue]),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Functions.addShop();
                Functions.showLoadingDialog(context);
              },
              child: const Text('Add Shop'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Functions.deleteShop();
                Functions.showLoadingDialog(context);
              },
              child: const Text('Delete Shop'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Functions.addPlayers();
                Functions.showLoadingDialog(context);
              },
              child: const Text('Add Players'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Functions.deletePlayers();
                Functions.showLoadingDialog(context);
              },
              child: const Text('Delete Players'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Functions.deletePlayers();
                Functions.deleteShop();
                Functions.showLoadingDialog(context);
              },
              child: const Text('Delete All'),
            ),
          ],
        ),
      ),
    );
  }
}