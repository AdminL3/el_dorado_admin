import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Functions {

  static addShop() async {
    List<bool> isInShop = [
      true,
      true,
      true,
      true,
      true,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    List<String> namen = [
      'Kundschafter',
      'Entdecker',
      'Tausendsassa',
      'Schatztruhe',
      'Fernsprechgerät',
      'Fotografin',
      'Pionier',
      'Mächtige Machete',
      'Abenteurerin',
      'Propellerflugzeug',
      'Journalistin',
      'Millionärin',
      'Kapitän',
      'Ureinwohner',
      'Kartograph',
      'Wissenschaftlerin',
      'Kompass',
      'Reisetagebuch'
    ];
    final firebase =
    FirebaseFirestore.instance.collection('Shop').doc('AnzahlVorne');
    final json = {
      'Anzahl': 6,
    };
    await firebase.set(json);

    String x;
    for (int i = 0; i < namen.length; i++) {
      x = '$i';
      final firebase = FirebaseFirestore.instance.collection('Shop').doc(x);
      final json = {
        'ID': i,
        'Name': namen[i],
        'Anzahl': 3,
        'Karte ist vorne': isInShop[i],
      };
      await firebase.set(json);
    }
  }

  static cancel(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Purchase Canceled"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static buyCard(int cardid, context) async {
    if (kDebugMode) {
      print("Logger: Started!");
    }
    if (await checkVorne(cardid)) {
      //checks if shop is open
      const String message = 'Der Shop ist zu!';
      cancel(context, message);
      if (kDebugMode) {
        print('Logger: Purchase Canceled: $message');
      }
    } else {
      if (kDebugMode) {
        print('Logger: Purchase Possible');
      }
      if (kDebugMode) {
        print('Logger: Trying update Shop');
      }
      buyShop(cardid);
      debugPrint('Logger: Finished Shop!');
      if (kDebugMode) {
        print('Logger: Trying update Player');
      }
      buyPlayer(cardid);
      debugPrint('Logger: Finished Player!');
      debugPrint('Logger: Finished!');
    }
  }

  static Future<bool> checkVorne(int cardid) async {
    String x = '$cardid';
    final firebaseShop = await FirebaseFirestore.instance
        .collection('Shop')
        .doc('AnzahlVorne')
        .get();
    final firebasecard =
    await FirebaseFirestore.instance.collection('Shop').doc(x).get();
    final dataCard = firebasecard.data();
    final dataShop = firebaseShop.data();
    if (dataCard?['Karte ist vorne']) {
      return false;
    } else if (dataShop?['Anzahl'] < 6) {
      return false;
    } else {
      return true;
    }
  }

  static buyPlayer(int cardid) async {}
  static buyShop(int cardid) async {
    String x = '$cardid';
    // Set firebase
    final firebasesetShop = FirebaseFirestore.instance.collection('Shop').doc('AnzahlVorne');
    final firebasesetCard = FirebaseFirestore.instance.collection('Shop').doc(x);
    // Get firebase
    final firebasegetCard = await FirebaseFirestore.instance.collection('Shop').doc(x).get();
    final firebasegetShop = await FirebaseFirestore.instance.collection('Shop').doc('AnzahlVorne').get();
    final dataShop = firebasegetShop.data();
    final dataCard = firebasegetCard.data();
    if (kDebugMode) {
      print('Logger: Before: $dataCard');
    }
    // Set new data
    final int anzahlCard = dataCard?['Anzahl'] - 1;
    final int anzahlShop = dataShop?['Anzahl'] - 1;
    bool karteVorne = false;
    // Karten nachrücken
    if (dataShop != null && dataShop.containsKey('AnzahlVorne') && dataShop['AnzahlVorne'] != null && dataShop['AnzahlVorne'] < 6) {
      karteVorne = true;
    }
    final jsonCard = {
      'ID': 'cardid',
      'Name': dataCard?['Name'],
      'Anzahl': anzahlCard,
      'Karte ist vorne': karteVorne,
    };
    final jsonShop = {
      'AnzahlVorne': anzahlShop,
    };
    if (kDebugMode) {
      print('Logger: After: $jsonCard');
    }
    if (kDebugMode) {
      print('complete');
    }
    // Publish data
    await firebasesetShop.set(jsonShop);
    await firebasesetCard.set(jsonCard);
  }


  static deletePlayers() {
    for (int i = 0; i < 4; i++) {
      FirebaseFirestore.instance.collection('Spieler$i').get().then((value) {
        for (DocumentSnapshot students in value.docs) {
          students.reference.delete();
        }
      });
    }
  }

  static resetPlayerx(int i) {
    FirebaseFirestore.instance.collection('Spieler$i').get().then((value) {
      for (DocumentSnapshot students in value.docs) {
        students.reference.delete();
      }
    });
  }

  static deleteShop() {
    FirebaseFirestore.instance.collection('Shop').get().then((value) {
      for (DocumentSnapshot students in value.docs) {
        students.reference.delete();
      }
    });
  }

  static addPlayers() async {
    for (int i = 0; i < 4; i++) {
      List<int> ids = [18, 18, 18, 18, 19, 19, 19, 20];
      List<String> namen = [
        'Reisende',
        'Reisende',
        'Reisende',
        'Reisende',
        'Forscher',
        'Forscher',
        'Forscher',
        'Matrose',
      ];

      String x;
      String y;
      for (int j = 0; j < namen.length; j++) {
        x = '$j';
        y = 'Spieler$i';
        final firebase = FirebaseFirestore.instance.collection(y).doc(x);
        final json = {
          'Name': namen[j],
          'ID': ids[j],
          'IsInHand': false,
          'IsUsed': false,
        };
        await firebase.set(json);
      }
    }
  }

  static reset() {
    addShop();
    deletePlayers();
    addPlayers();
  }

  static int getidbycard(String card) {
    List<String> namen = [
      'Kundschafter',
      'Entdecker',
      'Tausendsassa',
      'Schatztruhe',
      'Fernsprechgerät',
      'Fotografin',
      'Pionier',
      'Mächtige Machete',
      'Abenteurerin',
      'Propellerflugzeug',
      'Journalistin',
      'Millionärin',
      'Kapitän',
      'Ureinwohner',
      'Kartograph',
      'Wissenschaftlerin',
      'Kompass',
      'Reisetagebuch'
    ];
    return namen.indexOf(card);
  }
  static String getcardbyid(int id) {
    List<String> namen = [
      'Kundschafter',
      'Entdecker',
      'Tausendsassa',
      'Schatztruhe',
      'Fernsprechgerät',
      'Fotografin',
      'Pionier',
      'Mächtige Machete',
      'Abenteurerin',
      'Propellerflugzeug',
      'Journalistin',
      'Millionärin',
      'Kapitän',
      'Ureinwohner',
      'Kartograph',
      'Wissenschaftlerin',
      'Kompass',
      'Reisetagebuch'
    ];
    return namen[id];
  }

  static showLoadingDialog(context, [bool mounted = true]) async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return const Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Loading...')
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(milliseconds: 700));

    // Close the dialog programmatically
    // We use "mounted" variable to get rid of the "Do not use BuildContexts across async gaps" warning
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  static String getImagePathById(int id) {
    List<String> imageNames = [
      'Kundschafter',
      'Entdecker',
      'Tausendsassa',
      'Schatztruhe',
      'Fernsprechgerät',
      'Fotografin',
      'Pionier',
      'Mächtige Machete',
      'Abenteurerin',
      'Propellerflugzeug',
      'Journalistin',
      'Millionärin',
      'Kapitän',
      'Ureinwohner',
      'Kartograph',
      'Wissenschaftlerin',
      'Kompass',
      'Reisetagebuch',
    ];

    if (id >= 0 && id < imageNames.length) {
      return 'assets/images/${imageNames[id]}.png';
    } else {
      debugPrint('Couldnt load Image');
      return 'assets/images/X.png';
    }
  }
}