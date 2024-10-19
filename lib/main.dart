// lib/main.dart

import 'dart:convert';
import 'dart:io';

import 'package:organizercaspianexpress/fundamental_model.dart';
import 'package:organizercaspianexpress/home_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter/material.dart';
import 'package:organizercaspianexpress/rawmat_model.dart';
import 'package:organizercaspianexpress/warehouse_model.dart';
import 'package:path_provider/path_provider.dart';

import 'note_model.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      themeMode: ThemeMode.light,

      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.transparent, // transparent
          centerTitle: false,

          iconTheme: IconThemeData(
            color: Colors.black, // Set the color of the AppBar's icon
            size: 18, // Set the size of the AppBar's icon
          ),
        ),

        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'Manrope',
            color: Color(0xFF201A1A),
            fontSize: 32,
            fontWeight: FontWeight.w500,
            height: 1.22,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Manrope',
            color: Color(0xFF201A1A),
            fontSize: 22,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Manrope',
            color: Color(0xFF201A1A),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.50,
            letterSpacing: 0.15,
          ),

          displayLarge: TextStyle(
            color: Color(0xFF201A1A),
            fontSize: 24,
            fontWeight: FontWeight.w500,
            height: 1.50,
            letterSpacing: 0.15,
          ),
          displayMedium: TextStyle(
            color: Color(0xFF201A1A),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.43,
            letterSpacing: 0.25,
          ),
          displaySmall: TextStyle(
            color: Color(0xFF201A1A),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.25,
          ),

          bodyMedium: TextStyle(
            fontFamily: 'Manrope',
            color: Color(0xFFFFFBFF),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: 0.10,
          ),
        ),
      ),

      title: 'note',
      debugShowCheckedModeBanner: false,

      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Warehouse> warehouses = [];
  List<Note> notes = [];
  List<Fundamental> fundamentals = [];
  List<Rawmat> rawmats = [];

  @override
  void initState() {
    super.initState();
    initialization();

    _loadWarehouses();
    _loadNotes();
    _loadFundamentals();
    _loadRawmats();
  }
  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  void _saveFundamentals() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/organizer/fundamentals.json');

    List<Map<String, dynamic>> fundamentalsMapList = fundamentals.map((fundamental) {
      return {
        'editedTime': fundamental.editedTime.toIso8601String(),
        'nameOfRawmat': fundamental.nameOfRawmat,
        'nameOfProduct': fundamental.nameOfProduct,
        'gramOfOnePiece': fundamental.gramOfOnePiece,
        'numberOfPiecesInPackage': fundamental.numberOfPiecesInPackage,
        'priceOfPackageMat': fundamental.priceOfPackageMat,
        'numberOfPackagesInBox': fundamental.numberOfPackagesInBox,
        'typeOfBox': fundamental.typeOfBox,
        'priceOfBoxMat': fundamental.priceOfBoxMat,
        'priceOfWorkLoad': fundamental.priceOfWorkLoad,
        'priceOfOneBoxTotalMat': fundamental.priceOfOneBoxTotalMat,
        'priceOfOneBox': fundamental.priceOfOneBox,
        'weightOfOneBox': fundamental.weightOfOneBox,
      };
    }).toList();

    String fundamentalsJson = jsonEncode(fundamentalsMapList);

    await file.writeAsString(fundamentalsJson);
  }

  void _loadFundamentals() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/organizer/fundamentals.json');

    if (!file.existsSync()) {
      return;
    }

    String fundamentalsJson = await file.readAsString();
    List<dynamic> fundamentalsList = jsonDecode(fundamentalsJson);

    setState(() {
      fundamentals = fundamentalsList.map((fundamentalMap) {
        return Fundamental(
          editedTime: DateTime.parse(fundamentalMap['editedTime']),
          nameOfRawmat: fundamentalMap['nameOfRawmat'],
          nameOfProduct: fundamentalMap['nameOfProduct'],
          gramOfOnePiece: fundamentalMap['gramOfOnePiece'],
          numberOfPiecesInPackage: fundamentalMap['numberOfPiecesInPackage'],
          priceOfPackageMat: fundamentalMap['priceOfPackageMat'],
          numberOfPackagesInBox: fundamentalMap['numberOfPackagesInBox'],
          typeOfBox: fundamentalMap['typeOfBox'],
          priceOfBoxMat: fundamentalMap['priceOfBoxMat'],
          priceOfWorkLoad: fundamentalMap['priceOfWorkLoad'],
          priceOfOneBoxTotalMat: fundamentalMap['priceOfOneBoxTotalMat'],
          priceOfOneBox: fundamentalMap['priceOfOneBox'],
          weightOfOneBox: fundamentalMap['weightOfOneBox'],
        );
      }).toList();
    });
  }

  void _saveNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/organizer/notes.json');

    List<Map<String, dynamic>> notesMapList = notes.map((note) {
      return {
        'nameOfProduct': note.nameOfProduct,
        'content': note.content,
        'editedTime': note.editedTime.toIso8601String(),
        'numberOfBoxesCustomerWants': note.numberOfBoxesCustomerWants,
        'nameOfCustomer': note.nameOfCustomer,
        'telOfCustomer': note.telOfCustomer,
        'mainValue': note.mainValue,
      };
    }).toList();

    String notesJson = jsonEncode(notesMapList);

    await file.writeAsString(notesJson);
  }

  void _loadNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/organizer/notes.json');

    if (!file.existsSync()) {
      return;
    }

    String notesJson = await file.readAsString();
    List<dynamic> notesList = jsonDecode(notesJson);

    setState(() {
      notes = notesList.map((noteMap) {
        return Note(
          nameOfProduct: noteMap['nameOfProduct'],
          content: noteMap['content'],
          editedTime: DateTime.parse(noteMap['editedTime']),
          numberOfBoxesCustomerWants: noteMap['numberOfBoxesCustomerWants'],
          nameOfCustomer: noteMap['nameOfCustomer'],
          telOfCustomer: noteMap['telOfCustomer'],
          mainValue: noteMap['mainValue'],
        );
      }).toList();
    });
  }

  void _saveWarehouses() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/organizer/warehouses.json');

    List<Map<String, dynamic>> warehousesMapList = warehouses.map((warehouse) {
      return {
        'nameOfWarehouse': warehouse.nameOfWarehouse,
        'numberOfBoxesPreparedWarehouse': warehouse.numberOfBoxesPreparedWarehouse,
        'editedTime': warehouse.editedTime.toIso8601String(),
      };
    }).toList();

    String warehousesJson = jsonEncode(warehousesMapList);

    await file.writeAsString(warehousesJson);
  }

  void _loadWarehouses() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/organizer/warehouses.json');

    if (!file.existsSync()) {
      return;
    }

    String warehousesJson = await file.readAsString();
    List<dynamic> warehousesList = jsonDecode(warehousesJson);

    setState(() {
      warehouses = warehousesList.map((warehouseMap) {
        return Warehouse(
          nameOfWarehouse: warehouseMap['nameOfWarehouse'],
          numberOfBoxesPreparedWarehouse: warehouseMap['numberOfBoxesPreparedWarehouse'],
          editedTime: DateTime.parse(warehouseMap['editedTime']),
        );
      }).toList();
    });
  }

  void _saveRawmats() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/organizer/rawmats.json');

    List<Map<String, dynamic>> rawmatsMapList = rawmats.map((rawmat) {
      return {
        'nameOfRawmat': rawmat.nameOfRawmat,
        'weightOfRawmat': rawmat.weightOfRawmat,
        'priceOfOneKiloRawmat': rawmat.priceOfOneKiloRawmat,
        'editedTime': rawmat.editedTime.toIso8601String(),
      };
    }).toList();

    String rawmatsJson = jsonEncode(rawmatsMapList);

    await file.writeAsString(rawmatsJson);
  }

  void _loadRawmats() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/organizer/rawmats.json');

    if (!file.existsSync()) {
      return;
    }

    String rawmatsJson = await file.readAsString();
    List<dynamic> rawmatsList = jsonDecode(rawmatsJson);

    setState(() {
      rawmats = rawmatsList.map((rawmatMap) {
        return Rawmat(
          nameOfRawmat: rawmatMap['nameOfRawmat'],
          weightOfRawmat: rawmatMap['weightOfRawmat'],
          priceOfOneKiloRawmat: rawmatMap['priceOfOneKiloRawmat'],
          editedTime: DateTime.parse(rawmatMap['editedTime']),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomePage(
      warehouses: warehouses,
      onWarehousesUpdated: (updatedWarehouses) {
        setState(() {
          warehouses = updatedWarehouses;
          _saveWarehouses();
        });
      },

      fundamentals: fundamentals,
      onFundamentalsUpdated: (updatedFundamentals) {
        setState(() {
          fundamentals = updatedFundamentals;
          _saveFundamentals();
        });
      },

      notes: notes,
      onNotesUpdated: (updatedNotes) {
        setState(() {
          notes = updatedNotes;
          _saveNotes();
        });
      },

      rawmats: rawmats,
      onRawmatsUpdated: (updatedRawmats) {
        setState(() {
          rawmats = updatedRawmats;
          _saveRawmats();
        });
      },
    );
  }
}
