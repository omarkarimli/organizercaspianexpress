import 'dart:io';
import 'package:excel/excel.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:organizercaspianexpress/edit_rawmatpage.dart';
import 'package:organizercaspianexpress/edit_warehousepage.dart';
import 'package:organizercaspianexpress/fundamental_model.dart';
import 'package:organizercaspianexpress/rawmat_model.dart';
import 'package:organizercaspianexpress/warehouse_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:organizercaspianexpress/note_model.dart';
import 'package:organizercaspianexpress/edit_page.dart';
import 'package:organizercaspianexpress/edit_fundamentalpage.dart';
import 'package:intl/intl.dart';
import 'package:restart_app/restart_app.dart';


class HomePage extends StatefulWidget {
  final List<Warehouse> warehouses;
  final Function(List<Warehouse>) onWarehousesUpdated;

  final List<Rawmat> rawmats;
  final Function(List<Rawmat>) onRawmatsUpdated;

  final List<Fundamental> fundamentals;
  final Function(List<Fundamental>) onFundamentalsUpdated;

  final List<Note> notes;
  final Function(List<Note>) onNotesUpdated;

  const HomePage({Key? key, required this.notes, required this.onNotesUpdated, required this.fundamentals, required this.onFundamentalsUpdated, required this.rawmats, required this.onRawmatsUpdated, required this.warehouses, required this.onWarehousesUpdated})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> createSaleExcelFile() async {
    var excel = Excel.createExcel();

    var sheet = excel['Sheet1'];

    // Set column headers
    sheet.appendRow([
      'Satış tarixi',
      'Müştəri adı',
      'Əlaqə nömrəsi',
      'Malların Adı',
      'Meşok sayı',
      'Maya dəyəri (AZN)'
    ]);

    // Set column widths
    sheet.setColWidth(0, 20); // Column A (Satış tarixi)
    sheet.setColWidth(1, 20); // Column B (Müştəri adı)
    sheet.setColWidth(2, 20); // Column C (Əlaqə nömrəsi)
    sheet.setColWidth(3, 15); // Column D (Malların Adı)
    sheet.setColWidth(4, 15); // Column E (Kilosu)
    sheet.setColWidth(5, 20); // Column G (Maya dəyəri (AZN))

    // Add data rows
    for (int index = 0; index < widget.notes.length; index++) {
      var note = widget.notes[index];
      sheet.appendRow([
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse('${note.editedTime}')),
        note.nameOfCustomer,
        note.telOfCustomer,
        note.nameOfProduct,
        double.parse(note.numberOfBoxesCustomerWants),
        double.parse(note.mainValue),
      ]);
    }

    // Save Excel file
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDirectory.path}/organizer/sales_organizer.xlsx';

    var onValue = excel.encode();
    File file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsBytes(onValue!);

    // Open Excel File
    OpenFile.open(filePath);
  }

  Future<void> createRawmatExcelFile() async {
    var excel = Excel.createExcel();

    var sheet = excel['Sheet1'];

    // Set column headers
    sheet.appendRow([
      'Tarix',
      'Xammalın adı',
      'Qalan kütlə',
      '1 kilosunun qiyməti (AZN)',
    ]);

    // Set column widths
    sheet.setColWidth(0, 20); // Column A
    sheet.setColWidth(1, 20); // Column B
    sheet.setColWidth(2, 20); // Column C
    sheet.setColWidth(3, 25); // Column D

    // Add data rows
    for (int index = 0; index < widget.rawmats.length; index++) {
      var rawmat = widget.rawmats[index];
      sheet.appendRow([
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse('${rawmat.editedTime}')),
        rawmat.nameOfRawmat,
        double.parse(rawmat.weightOfRawmat),
        double.parse(rawmat.priceOfOneKiloRawmat),
      ]);
    }

    // Save Excel file
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDirectory.path}/organizer/rawmats_organizer.xlsx';

    var onValue = excel.encode();
    File file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsBytes(onValue!);

    // Open Excel File
    OpenFile.open(filePath);
  }

  Future<void> createWarehouseExcelFile() async {
    var excel = Excel.createExcel();

    var sheet = excel['Sheet1'];

    // Set column headers
    sheet.appendRow([
      'Tarix',
      'Anbarda qalan malın adı',
      'Qalan mal sayı',
    ]);

    // Set column widths
    sheet.setColWidth(0, 20);
    sheet.setColWidth(1, 25);
    sheet.setColWidth(2, 20);

    // Add data rows
    for (int index = 0; index < widget.warehouses.length; index++) {
      var warehouse = widget.warehouses[index];
      sheet.appendRow([
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse('${warehouse.editedTime}')),
        warehouse.nameOfWarehouse,
        double.parse(warehouse.numberOfBoxesPreparedWarehouse),
      ]);
    }

    // Save Excel file
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDirectory.path}/organizer/warehouses_organizer.xlsx';

    var onValue = excel.encode();
    File file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsBytes(onValue!);

    // Open Excel File
    OpenFile.open(filePath);
  }

  Future<void> createFundamentalExcelFile() async {
    var excel = Excel.createExcel();

    var sheet = excel['Sheet1'];

    // Set column headers
    sheet.appendRow([
      'Tarix',
      'Malın adı',
      'Xammal növü',
      '1 dənəsinin qramı',
      '1 paketdə dənələrinin sayı',
      'Paket materialının qiyməti (AZN)',
      '1 meşokda paketlərin sayı',
      'Meşok növü',
      'Meşok materialının qiyməti (AZN)',
      'Toplam material qiyməti (AZN)',
      '1 meşokun tam qiyməti (AZN)',
    ]);

    // Set column widths
    sheet.setColWidth(0, 17);
    sheet.setColWidth(1, 20);
    sheet.setColWidth(2, 20);
    sheet.setColWidth(3, 20);
    sheet.setColWidth(4, 25);
    sheet.setColWidth(5, 28);
    sheet.setColWidth(6, 22);
    sheet.setColWidth(7, 20);
    sheet.setColWidth(8, 28);
    sheet.setColWidth(9, 25);
    sheet.setColWidth(10, 28);

    // Add data rows
    for (int index = 0; index < widget.fundamentals.length; index++) {
      var fundamental = widget.fundamentals[index];
      sheet.appendRow([
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse('${fundamental.editedTime}')),
        fundamental.nameOfProduct,
        fundamental.nameOfRawmat,
        double.parse(fundamental.gramOfOnePiece),
        double.parse(fundamental.numberOfPiecesInPackage),
        double.parse(fundamental.priceOfPackageMat),
        double.parse(fundamental.numberOfPackagesInBox),
        fundamental.typeOfBox,
        double.parse(fundamental.priceOfBoxMat),
        double.parse(fundamental.priceOfOneBoxTotalMat),
        double.parse(fundamental.priceOfOneBox),
      ]);
    }

    // Save Excel file
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDirectory.path}/organizer/fundamentals_organizer.xlsx';

    var onValue = excel.encode();
    File file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsBytes(onValue!);

    // Open Excel File
    OpenFile.open(filePath);
  }

  List<Warehouse> filteredWarehouses = [];
  List<Rawmat> filteredRawmats = [];
  List<Fundamental> filteredFundamentals = [];
  List<Note> filteredNotes = []; // Store the filtered notes here
  String searchText = ''; // Store the search query here

  List<dynamic> performAdvancedSearch(String query) {
    query = query.toLowerCase();

    List<Warehouse> matchingWarehouses = widget.warehouses.where((warehouse) {
      final nameOfWarehouse = warehouse.nameOfWarehouse.toLowerCase();
      return nameOfWarehouse.contains(query);
    }).toList();

    List<Rawmat> matchingRawmats = widget.rawmats.where((rawmat) {
      final nameOfRaw = rawmat.nameOfRawmat.toLowerCase();
      return nameOfRaw.contains(query);
    }).toList();

    List<Fundamental> matchingFundamentals = widget.fundamentals.where((fundamental) {
      final nameOfProduct = fundamental.nameOfProduct.toLowerCase();
      return nameOfProduct.contains(query);
    }).toList();

    List<Note> matchingNotes = widget.notes.where((note) {
      final nameOfProduct = note.nameOfProduct.toLowerCase();
      final nameOfCustomer = note.nameOfCustomer.toLowerCase();
      final editedTime = note.editedTime.toString().toLowerCase();
      final numberOfBoxesCustomerWants = note.numberOfBoxesCustomerWants.toLowerCase();
      return nameOfProduct.contains(query) || nameOfCustomer.contains(query) || editedTime.contains(query) || numberOfBoxesCustomerWants.contains(query);
    }).toList();

    return [...matchingFundamentals, ...matchingNotes, ...matchingRawmats, ...matchingWarehouses];
  }

  // Search
  void onSearchTextChanged(String query) {
    setState(() {
      searchText = query;

      if (query.isEmpty) {
        filteredWarehouses = widget.warehouses;
        filteredRawmats = widget.rawmats;
        filteredFundamentals = widget.fundamentals;
        filteredNotes = widget.notes;
      } else {
        List<dynamic> matchingItems = performAdvancedSearch(query);

        filteredWarehouses = matchingItems.whereType<Warehouse>().toList();
        filteredRawmats = matchingItems.whereType<Rawmat>().toList();
        filteredFundamentals = matchingItems.whereType<Fundamental>().toList();
        filteredNotes = matchingItems.whereType<Note>().toList();
      }
    });
  }

  @override
  void initState() {
    filteredWarehouses = widget.warehouses;
    filteredRawmats = widget.rawmats;
    filteredFundamentals = widget.fundamentals;

    // Initialize the filtered notes with all the notes initially
    filteredNotes = widget.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(274),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 11),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppBar(
                    leading: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 17,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/banner.png',
                            width: 36,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        const SizedBox(width: 11,),
                        Text(
                          'Xoş gəldiniz!',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                          onPressed: () async {
                            // Get the application documents directory
                            final directory = await getApplicationDocumentsDirectory();

                            // List all files in the directory
                            List<FileSystemEntity> files = directory.listSync();

                            // Delete each file
                            for (var file in files) {
                              if (file is File) {
                                await file.delete();
                              }
                            }

                            // Optionally, you can check if the directory is empty
                            bool isDirectoryEmpty = directory.listSync().isEmpty;
                            print('Is directory empty: $isDirectoryEmpty');

                            if (isDirectoryEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.black,
                                  content: Text('Datalar silindi'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }

                            Restart.restartApp();
                          },
                          icon: const Icon(Icons.lock_reset_rounded)
                      ),
                    ],
                    leadingWidth: double.infinity,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 128, 24, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  'Organizer ',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  'for CaspianExpress',
                                  style: Theme.of(context).textTheme.displayLarge,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                            child: TextField(
                              onChanged: onSearchTextChanged,
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                hintText: "Search",
                                hintStyle: Theme.of(context).textTheme.titleSmall,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.black54),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CardRawmat(
                            notes: widget.notes,
                            onNotesUpdated: widget.onNotesUpdated,
                            fundamentals: widget.fundamentals,
                            onFundamentalsUpdated: widget.onFundamentalsUpdated,
                            rawmats: widget.rawmats,
                            onRawmatsUpdated: widget.onRawmatsUpdated,
                            warehouses: widget.warehouses,
                            onWarehousesUpdated: widget.onWarehousesUpdated,
                            searchText: searchText,
                            filteredRawmats: filteredRawmats,
                            createRawmatExcelFile: createRawmatExcelFile
                        ),
                        if (widget.fundamentals.isNotEmpty) ...[
                          CardWarehouse(
                              notes: widget.notes,
                              onNotesUpdated: widget.onNotesUpdated,
                              fundamentals: widget.fundamentals,
                              onFundamentalsUpdated: widget.onFundamentalsUpdated,
                              rawmats: widget.rawmats,
                              onRawmatsUpdated: widget.onRawmatsUpdated,
                              warehouses: widget.warehouses,
                              onWarehousesUpdated: widget.onWarehousesUpdated,
                              searchText: searchText,
                              filteredWarehouses: filteredWarehouses,
                              createWarehouseExcelFile: createWarehouseExcelFile,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: Column(
                      children: [
                        if (widget.rawmats.isNotEmpty) ...[
                          CardFundamental(
                              notes: widget.notes,
                              onNotesUpdated: widget.onNotesUpdated,
                              fundamentals: widget.fundamentals,
                              onFundamentalsUpdated: widget.onFundamentalsUpdated,
                              rawmats: widget.rawmats,
                              onRawmatsUpdated: widget.onRawmatsUpdated,
                              warehouses: widget.warehouses,
                              onWarehousesUpdated: widget.onWarehousesUpdated,
                              searchText: searchText,
                              filteredFundamentals: filteredFundamentals,
                              createFundamentalExcelFile: createFundamentalExcelFile,
                          ),
                        ],
                        if (widget.warehouses.isNotEmpty) ...[
                          CardSale(
                            notes: widget.notes,
                            onNotesUpdated: widget.onNotesUpdated,
                            fundamentals: widget.fundamentals,
                            onFundamentalsUpdated: widget.onFundamentalsUpdated,
                            rawmats: widget.rawmats,
                            onRawmatsUpdated: widget.onRawmatsUpdated,
                            warehouses: widget.warehouses,
                            onWarehousesUpdated: widget.onWarehousesUpdated,
                            searchText: searchText,
                            filteredNotes: filteredNotes,
                            createSaleExcelFile: createSaleExcelFile,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardRawmat extends StatefulWidget {
  final String searchText;
  final List<Rawmat> filteredRawmats;
  final dynamic createRawmatExcelFile;

  final List<Warehouse> warehouses;
  final Function(List<Warehouse>) onWarehousesUpdated;

  final List<Rawmat> rawmats;
  final Function(List<Rawmat>) onRawmatsUpdated;

  final List<Fundamental> fundamentals;
  final Function(List<Fundamental>) onFundamentalsUpdated;

  final List<Note> notes;
  final Function(List<Note>) onNotesUpdated;

  const CardRawmat({
    Key? key,
    required this.notes,
    required this.onNotesUpdated,
    required this.fundamentals,
    required this.onFundamentalsUpdated,
    required this.rawmats,
    required this.onRawmatsUpdated,
    required this.warehouses,
    required this.onWarehousesUpdated,
    required this.searchText,
    required this.filteredRawmats,
    required this.createRawmatExcelFile
  }) : super(key: key);

  @override
  State<CardRawmat> createState() => _CardRawmatState();
}

class _CardRawmatState extends State<CardRawmat> {
  bool isCardExtended = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCardExtended = !isCardExtended;
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 6, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'əlimizdə olan Xammallar > ${widget.rawmats.length}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: GestureDetector(
                          onTap: () {
                            // Open the edit page to add a new note.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditRawmatPage(),
                              ),
                            ).then((newRawmat) {
                              if (newRawmat != null) {
                                setState(() {
                                  widget.rawmats.add(newRawmat);
                                });
                                widget.onRawmatsUpdated(widget.rawmats);
                              }
                            });
                          },
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.createRawmatExcelFile(); // Call the function to create Excel file
                                },
                                icon: const Icon(
                                  Icons.file_download_outlined,
                                  size: 20,
                                  color: Colors.grey,),
                              ),
                              const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          isCardExtended ? Column(
            children: [
              const SizedBox(height: 16,),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 73, // Adjust the height according to your design
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/banner.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16,),

              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.searchText.isEmpty ? widget.rawmats.length : widget.filteredRawmats.length,
                itemBuilder: (context, index) {
                  final rawmat = widget.searchText.isEmpty ? widget.rawmats[index] : widget.filteredRawmats[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          fit: StackFit.passthrough,
                          children: [
                            ListTile(
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 4, // Width of the vertical line
                                    height: 30, // Height of the vertical line
                                    color: Colors.blue, // Color of the vertical line
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rawmat.nameOfRawmat,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${rawmat.weightOfRawmat} kq',
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        IconButton(
                                          iconSize: 20,
                                          icon: Icon(Icons.copy_all_rounded), // Replace with your desired icon
                                          onPressed: () {
                                            setState(() {
                                              // copy
                                              widget.rawmats.add(rawmat);
                                              widget.filteredRawmats.add(rawmat);
                                              widget.onRawmatsUpdated(widget.rawmats);
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Rawmat copied, pasted'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          iconSize: 20,
                                          icon: Icon(Icons.delete_rounded), // Replace with your desired icon
                                          onPressed: () {
                                            setState(() {
                                              // delete
                                              widget.rawmats.remove(rawmat);
                                              widget.filteredRawmats.remove(rawmat);
                                              widget.onRawmatsUpdated(widget.rawmats);
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Rawmat deleted'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Open the edit page with the selected note data.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditRawmatPage(
                                      rawmat: rawmat, // Pass the selected note to EditPage
                                    ),
                                  ),
                                ).then((updatedRawmat) {
                                  if (updatedRawmat != null) {
                                    setState(() {
                                      widget.rawmats[index] = updatedRawmat;
                                    });
                                    widget.onRawmatsUpdated(widget.rawmats);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              if((widget.searchText.isEmpty ? widget.rawmats.length : widget.filteredRawmats.length) == 0) ...[
                SizedBox(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No result',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ],
          ) : const SizedBox.shrink(),

          isCardExtended ? const SizedBox(height: 16,) : const SizedBox(height: 8,),
        ],
      ),
    );
  }
}

class CardWarehouse extends StatefulWidget {
  final String searchText;
  final List<Warehouse> filteredWarehouses;
  final dynamic createWarehouseExcelFile;

  final List<Warehouse> warehouses;
  final Function(List<Warehouse>) onWarehousesUpdated;

  final List<Rawmat> rawmats;
  final Function(List<Rawmat>) onRawmatsUpdated;

  final List<Fundamental> fundamentals;
  final Function(List<Fundamental>) onFundamentalsUpdated;

  final List<Note> notes;
  final Function(List<Note>) onNotesUpdated;

  const CardWarehouse({
    Key? key,
    required this.notes,
    required this.onNotesUpdated,
    required this.fundamentals,
    required this.onFundamentalsUpdated,
    required this.rawmats,
    required this.onRawmatsUpdated,
    required this.warehouses,
    required this.onWarehousesUpdated,
    required this.searchText,
    required this.filteredWarehouses,
    required this.createWarehouseExcelFile
  }) : super(key: key);

  @override
  State<CardWarehouse> createState() => _CardWarehouseState();
}

class _CardWarehouseState extends State<CardWarehouse> {
  bool isCardExtended = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isCardExtended = !isCardExtended;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7, 6, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Anbarda olanlar > ${widget.warehouses.length}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: GestureDetector(
                            onTap: () {
                              // Open the edit page to add a new note.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditWarehousePage(fundamentals: widget.fundamentals, rawmats: widget.rawmats, onRawmatsUpdated: widget.onRawmatsUpdated),
                                ),
                              ).then((newWarehouse) {
                                if (newWarehouse != null) {
                                  setState(() {
                                    widget.warehouses.add(newWarehouse);
                                  });
                                  widget.onWarehousesUpdated(widget.warehouses);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    widget.createWarehouseExcelFile(); // Call the function to create Excel file
                                  },
                                  icon: const Icon(
                                    Icons.file_download_outlined,
                                    size: 20,
                                    color: Colors.grey,),
                                ),
                                const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isCardExtended ? Column(
              children: [
                const SizedBox(height: 16,),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 73, // Adjust the height according to your design
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16,),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.searchText.isEmpty ? widget.warehouses.length : widget.filteredWarehouses.length,
                  itemBuilder: (context, index) {
                    final warehouse = widget.searchText.isEmpty ? widget.warehouses[index] : widget.filteredWarehouses[index];

                    Fundamental relatedFundamental = widget.fundamentals.firstWhere(
                          (fundamental) => fundamental.nameOfProduct == warehouse.nameOfWarehouse,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            alignment: Alignment.centerRight,
                            fit: StackFit.passthrough,
                            children: [
                              ListTile(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(width: 3, color: Colors.grey.shade50),
                                ),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 4, // Width of the vertical line
                                      height: 30, // Height of the vertical line
                                      color: Colors.redAccent, // Color of the vertical line
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${warehouse.nameOfWarehouse}',
                                                style: Theme.of(context).textTheme.titleSmall,
                                              ),
                                            ],
                                          ),
                                          const Expanded(child: SizedBox()),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      warehouse.numberOfBoxesPreparedWarehouse,
                                                      style: Theme.of(context).textTheme.titleSmall,
                                                    ),
                                                    Text(
                                                      ' ${relatedFundamental.typeOfBox}',
                                                      style: Theme.of(context).textTheme.titleSmall,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            iconSize: 20,
                                            icon: Icon(Icons.copy_all_rounded),
                                            onPressed: () {
                                              // Decrease Warehouse.numberOfBoxesPreparedWarehouse
                                              Fundamental relatedFundamental = widget.fundamentals.firstWhere(
                                                    (fundamental) => fundamental.nameOfProduct == warehouse.nameOfWarehouse,
                                              );

                                              Rawmat relatedRawmat = widget.rawmats.firstWhere(
                                                    (rawmat) => rawmat.nameOfRawmat == relatedFundamental.nameOfRawmat,
                                              );

                                              setState(() {
                                                // copy
                                                if (double.parse(relatedRawmat.weightOfRawmat) >= double.parse(warehouse.numberOfBoxesPreparedWarehouse) * double.parse(relatedFundamental.weightOfOneBox)) {
                                                  int i = widget.rawmats.indexOf(relatedRawmat);
                                                  List<Rawmat> rawmats = widget.rawmats;
                                                  rawmats[i] = Rawmat(
                                                    editedTime: warehouse.editedTime,
                                                    nameOfRawmat: relatedRawmat.nameOfRawmat,
                                                    priceOfOneKiloRawmat: relatedRawmat.priceOfOneKiloRawmat,
                                                    weightOfRawmat: (double.parse(relatedRawmat.weightOfRawmat) - double.parse(warehouse.numberOfBoxesPreparedWarehouse) * double.parse(relatedFundamental.weightOfOneBox)).toString(),
                                                  );
                                                  widget.onRawmatsUpdated(rawmats);

                                                  widget.filteredWarehouses.add(warehouse);
                                                  widget.warehouses.add(warehouse);
                                                  widget.onWarehousesUpdated(widget.warehouses);

                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor: Colors.black,
                                                      content: Text('Warehouse copied, pasted'),
                                                      duration: Duration(seconds: 1),
                                                    ),
                                                  );
                                                }
                                                else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor: Colors.black,
                                                      content: Text('Yetərli xammal yoxdur'),
                                                      duration: Duration(seconds: 1),
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                          IconButton(
                                            iconSize: 20,
                                            icon: Icon(Icons.delete_rounded), // Replace with your desired icon
                                            onPressed: () {
                                              setState(() {
                                                // delete
                                                widget.warehouses.remove(warehouse);
                                                widget.filteredWarehouses.remove(warehouse);
                                                widget.onWarehousesUpdated(widget.warehouses);
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Warehouse deleted'),
                                                  duration: Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Open the edit page with the selected note data.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditWarehousePage(
                                        warehouse: warehouse,
                                        fundamentals: widget.fundamentals,
                                        rawmats: widget.rawmats,
                                        onRawmatsUpdated: widget.onRawmatsUpdated,
                                      ),
                                    ),
                                  ).then((updatedWarehouse) {
                                    if (updatedWarehouse != null) {
                                      setState(() {
                                        widget.warehouses[index] = updatedWarehouse;
                                      });
                                      widget.onWarehousesUpdated(widget.warehouses);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                if((widget.searchText.isEmpty ? widget.warehouses.length : widget.filteredWarehouses.length) == 0) ...[
                  SizedBox(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No result',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              ],
            ) : SizedBox.shrink(),

            isCardExtended ? const SizedBox(height: 16,) : const SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}

class CardFundamental extends StatefulWidget {
  final String searchText;
  final List<Fundamental> filteredFundamentals;
  final dynamic createFundamentalExcelFile;

  final List<Warehouse> warehouses;
  final Function(List<Warehouse>) onWarehousesUpdated;

  final List<Rawmat> rawmats;
  final Function(List<Rawmat>) onRawmatsUpdated;

  final List<Fundamental> fundamentals;
  final Function(List<Fundamental>) onFundamentalsUpdated;

  final List<Note> notes;
  final Function(List<Note>) onNotesUpdated;

  const CardFundamental({
    Key? key,
    required this.notes,
    required this.onNotesUpdated,
    required this.fundamentals,
    required this.onFundamentalsUpdated,
    required this.rawmats,
    required this.onRawmatsUpdated,
    required this.warehouses,
    required this.onWarehousesUpdated,
    required this.searchText,
    required this.filteredFundamentals,
    required this.createFundamentalExcelFile,
  }) : super(key: key);

  @override
  State<CardFundamental> createState() => _CardFundamentalState();
}

class _CardFundamentalState extends State<CardFundamental> {
  bool isCardExtended = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isCardExtended = !isCardExtended;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7, 6, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mal növləri > ${widget.fundamentals.length}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: GestureDetector(
                            onTap: () {
                              // Open the edit page to add a new note.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditFundamentalPage(rawmats: widget.rawmats,),
                                ),
                              ).then((newFundamental) {
                                if (newFundamental != null) {
                                  setState(() {
                                    widget.fundamentals.add(newFundamental);
                                  });
                                  widget.onFundamentalsUpdated(widget.fundamentals);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    widget.createFundamentalExcelFile(); // Call the function to create Excel file
                                  },
                                  icon: const Icon(
                                    Icons.file_download_outlined,
                                    size: 20,
                                    color: Colors.grey,),
                                ),
                                const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isCardExtended ? Column(
              children: [
                const SizedBox(height: 16,),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 73, // Adjust the height according to your design
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16,),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.searchText.isEmpty ? widget.fundamentals.length : widget.filteredFundamentals.length,
                  itemBuilder: (context, index) {
                    final fundamental = widget.searchText.isEmpty ? widget.fundamentals[index] : widget.filteredFundamentals[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation: 0,
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 4, // Width of the vertical line
                              height: 30, // Height of the vertical line
                              color: Colors.orangeAccent, // Color of the vertical line
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Add this line
                                children: [
                                  Text(
                                    fundamental.nameOfProduct,
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        iconSize: 20,
                                        icon: Icon(Icons.copy_all_rounded), // Replace with your desired icon
                                        onPressed: () {
                                          setState(() {
                                            // copy
                                            widget.filteredFundamentals.add(fundamental);
                                            widget.fundamentals.add(fundamental);
                                            widget.onFundamentalsUpdated(widget.fundamentals);
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Fundamental copied, pasted'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        iconSize: 20,
                                        icon: Icon(Icons.delete_rounded), // Replace with your desired icon
                                        onPressed: () {
                                          setState(() {
                                            // delete
                                            widget.fundamentals.remove(fundamental);
                                            widget.filteredFundamentals.remove(fundamental);
                                            widget.onFundamentalsUpdated(widget.fundamentals);
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Fundamental deleted'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Open the edit page with the selected note data.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditFundamentalPage(
                                rawmats: widget.rawmats,
                                fundamental: fundamental,
                              ),
                            ),
                          ).then((updatedFundamental) {
                            if (updatedFundamental != null) {
                              setState(() {
                                widget.fundamentals[index] = updatedFundamental;
                              });
                              widget.onFundamentalsUpdated(widget.fundamentals);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),

                if((widget.searchText.isEmpty ? widget.fundamentals.length : widget.filteredFundamentals.length) == 0) ...[
                  SizedBox(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No result',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              ],
            ) : SizedBox.shrink(),

            isCardExtended ? const SizedBox(height: 16,) : const SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}

class CardSale extends StatefulWidget {
  final String searchText;
  final List<Note> filteredNotes;
  final dynamic createSaleExcelFile;

  final List<Warehouse> warehouses;
  final Function(List<Warehouse>) onWarehousesUpdated;

  final List<Rawmat> rawmats;
  final Function(List<Rawmat>) onRawmatsUpdated;

  final List<Fundamental> fundamentals;
  final Function(List<Fundamental>) onFundamentalsUpdated;

  final List<Note> notes;
  final Function(List<Note>) onNotesUpdated;

  const CardSale({
    Key? key,
    required this.notes,
    required this.onNotesUpdated,
    required this.fundamentals,
    required this.onFundamentalsUpdated,
    required this.rawmats,
    required this.onRawmatsUpdated,
    required this.warehouses,
    required this.onWarehousesUpdated,
    required this.searchText,
    required this.filteredNotes,
    required this.createSaleExcelFile,
  }) : super(key: key);

  @override
  State<CardSale> createState() => _CardSaleState();
}

class _CardSaleState extends State<CardSale> {
  bool isCardExtended = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCardExtended = !isCardExtended;
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 6, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Toplam Maya dəyərləri > ${widget.notes.length}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: GestureDetector(
                          onTap: () {
                            // Open the edit page to add a new note.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPage(fundamentals: widget.fundamentals, warehouses: widget.warehouses, onWarehousesUpdated: widget.onWarehousesUpdated,),
                              ),
                            ).then((newNote) {
                              if (newNote != null) {
                                setState(() {
                                  widget.notes.add(newNote);
                                });
                                widget.onNotesUpdated(widget.notes);
                              }
                            });
                          },
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.createSaleExcelFile(); // Call the function to create Excel file
                                },
                                icon: const Icon(
                                  Icons.file_download_outlined,
                                  size: 20,
                                  color: Colors.grey,),
                              ),
                              const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isCardExtended ? Column(
            children: [
              const SizedBox(height: 16,),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 73, // Adjust the height according to your design
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/banner.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16,),

              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.searchText.isEmpty ? widget.notes.length : widget.filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = widget.searchText.isEmpty ? widget.notes[index] : widget.filteredNotes[index];

                  Fundamental relatedFundamental = widget.fundamentals.firstWhere(
                        (fundamental) => fundamental.nameOfProduct == note.nameOfProduct,
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          fit: StackFit.passthrough,
                          children: [
                            ListTile(
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(width: 3, color: Colors.grey.shade50),
                              ),
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 4, // Width of the vertical line
                                    height: 30, // Height of the vertical line
                                    color: Colors.green, // Color of the vertical line
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${note.nameOfCustomer} > ${note.numberOfBoxesCustomerWants} ${relatedFundamental.typeOfBox} ${note.nameOfProduct}',
                                              style: Theme.of(context).textTheme.titleSmall,
                                            ),
                                            Text(
                                              DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse('${note.editedTime}')),
                                              style: const TextStyle(
                                                fontFamily: 'Manrope',
                                                color: Color(0xFF201A1A),
                                                fontSize: 12,
                                                height: 1.50,
                                                letterSpacing: 0.15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    NumberFormat("###,###.00", "en_US").format(double.parse(note.mainValue)).replaceAll(',', "'"),
                                                    style: Theme.of(context).textTheme.titleSmall,
                                                  ),
                                                  const Text(
                                                    ' AZN',
                                                    style: TextStyle(
                                                      fontFamily: 'Manrope',
                                                      color: Color(0xFF201A1A),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      height: 1.50,
                                                      letterSpacing: 0.15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 20,
                                          icon: Icon(Icons.copy_all_rounded),
                                          onPressed: () {
                                            // Decrease Warehouse.numberOfBoxesPreparedWarehouse
                                            Warehouse relatedWarehouse = widget.warehouses.firstWhere(
                                                  (warehouse) => warehouse.nameOfWarehouse == note.nameOfProduct,
                                            );
                                            setState(() {
                                              // copy
                                              if (double.parse(relatedWarehouse.numberOfBoxesPreparedWarehouse) >= double.parse(note.numberOfBoxesCustomerWants)) {
                                                int i = widget.warehouses.indexOf(relatedWarehouse);
                                                List<Warehouse> warehouses = widget.warehouses;
                                                warehouses[i] = Warehouse(
                                                  editedTime: note.editedTime,
                                                  nameOfWarehouse: relatedWarehouse.nameOfWarehouse,
                                                  numberOfBoxesPreparedWarehouse: (double.parse(relatedWarehouse.numberOfBoxesPreparedWarehouse) - double.parse(note.numberOfBoxesCustomerWants)).toString(),
                                                );
                                                widget.onWarehousesUpdated(warehouses);

                                                widget.filteredNotes.add(note);
                                                widget.notes.add(note);
                                                widget.onNotesUpdated(widget.notes);

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    backgroundColor: Colors.black,
                                                    content: Text('Note copied, pasted'),
                                                    duration: Duration(seconds: 1),
                                                  ),
                                                );
                                              }
                                              else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    backgroundColor: Colors.black,
                                                    content: Text('Yetərli mal Anbarda yoxdur'),
                                                    duration: Duration(seconds: 1),
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                        ),
                                        IconButton(
                                          iconSize: 20,
                                          icon: Icon(Icons.delete_rounded), // Replace with your desired icon
                                          onPressed: () {
                                            setState(() {
                                              // delete
                                              widget.notes.remove(note);
                                              widget.filteredNotes.remove(note);
                                              widget.onNotesUpdated(widget.notes);
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Note deleted'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Open the edit page with the selected note data.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPage(
                                      note: note,
                                      fundamentals: widget.fundamentals,
                                      warehouses: widget.warehouses,
                                      onWarehousesUpdated: widget.onWarehousesUpdated,
                                    ),
                                  ),
                                ).then((updatedNote) {
                                  if (updatedNote != null) {
                                    setState(() {
                                      widget.notes[index] = updatedNote;
                                    });
                                    widget.onNotesUpdated(widget.notes);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              if((widget.searchText.isEmpty ? widget.notes.length : widget.filteredNotes.length) == 0) ...[
                SizedBox(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No result',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ],
          ) : SizedBox.shrink(),

          isCardExtended ? const SizedBox(height: 16,) : const SizedBox(height: 8,),
        ],
      ),
    );
  }
}
