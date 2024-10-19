import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:organizercaspianexpress/fundamental_model.dart';
import 'package:organizercaspianexpress/rawmat_model.dart';
import 'package:organizercaspianexpress/warehouse_model.dart';

class EditWarehousePage extends StatefulWidget {
  final List<Fundamental> fundamentals;

  final List<Rawmat> rawmats;
  final Function(List<Rawmat>) onRawmatsUpdated;

  final Warehouse? warehouse;

  const EditWarehousePage({Key? key, this.warehouse, required this.fundamentals, required this.rawmats, required this.onRawmatsUpdated}) : super(key: key);

  @override
  State<EditWarehousePage> createState() => _EditWarehousePageState();
}

class _EditWarehousePageState extends State<EditWarehousePage> {
  late TextEditingController _nameOfWarehouseController;
  late TextEditingController _numberOfBoxesPreparedWarehouseController;

  String selectedProductTypeCategory = '';
  Future<void> _showProductTypeDropdown() async {
    String? newValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: DropdownButton<String>(
            isDense: true,
            value: _nameOfWarehouseController.text == '' ? selectedProductTypeCategory : _nameOfWarehouseController.text,
            onChanged: (String? value) {
              if (value != null) {
                _nameOfWarehouseController.text = value;
                Navigator.pop(context, value); // Close the dialog and return the selected value
              }
            },
            items: widget.fundamentals.map((fundamental) => fundamental.nameOfProduct).toList().map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall,),
              );
            }).toList(),
          ),
        );
      },
    );

    if (newValue != null) {
      setState(() {
        selectedProductTypeCategory = newValue;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedProductTypeCategory = widget.fundamentals.isNotEmpty
        ? widget.fundamentals[0].nameOfProduct
        : '';

    _nameOfWarehouseController = TextEditingController(text: widget.warehouse?.nameOfWarehouse ?? '');
    _numberOfBoxesPreparedWarehouseController = TextEditingController(text: widget.warehouse?.numberOfBoxesPreparedWarehouse ?? '');
  }

  @override
  void dispose() {
    _nameOfWarehouseController.dispose();
    _numberOfBoxesPreparedWarehouseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isKeyboardActive = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(164),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.warehouse == null ? 'Anbarda yeni Mal' : 'Düzəliş et',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 24,),
              TextField(
                readOnly: true,
                controller: _nameOfWarehouseController,
                decoration: InputDecoration(
                  labelText: 'Mal növü',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                  ),
                ),
                style: Theme.of(context).textTheme.titleSmall,
                onTap: () => _showProductTypeDropdown(),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _numberOfBoxesPreparedWarehouseController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[0-9+]*$'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Klyok / Karobka / Meşok sayı',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                  ),
                ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isKeyboardActive ? null : SizedBox(
        height: 70,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), // Adjust the radius as needed
              color: Colors.black87,
            ),
            child: FloatingActionButton(
              onPressed: () {
                if (_nameOfWarehouseController.text.isNotEmpty &&
                    _numberOfBoxesPreparedWarehouseController.text.isNotEmpty) {

                  DateTime editedTime = DateTime.now();

                  String nameOfWarehouse = _nameOfWarehouseController.text;
                  String numberOfBoxesPreparedWarehouse = _numberOfBoxesPreparedWarehouseController.text;

                  Warehouse updatedWarehouse = Warehouse(
                    editedTime: editedTime,
                    nameOfWarehouse: nameOfWarehouse,
                    numberOfBoxesPreparedWarehouse: numberOfBoxesPreparedWarehouse,
                  );

                  Fundamental relatedFundamental = widget.fundamentals.firstWhere(
                        (fundamental) => fundamental.nameOfProduct == nameOfWarehouse,
                  );

                  // Decrease Warehouse.numberOfBoxesPreparedWarehouse
                  Rawmat relatedRawmat = widget.rawmats.firstWhere(
                        (rawmat) => rawmat.nameOfRawmat == relatedFundamental.nameOfRawmat,
                  );
                  if (double.parse(relatedRawmat.weightOfRawmat) >= double.parse(updatedWarehouse.numberOfBoxesPreparedWarehouse) * double.parse(relatedFundamental.weightOfOneBox)) {
                    int i = widget.rawmats.indexOf(relatedRawmat);
                    List<Rawmat> rawmats = widget.rawmats;
                    rawmats[i] = Rawmat(
                      editedTime: editedTime,
                      nameOfRawmat: relatedRawmat.nameOfRawmat,
                      priceOfOneKiloRawmat: relatedRawmat.priceOfOneKiloRawmat,
                      weightOfRawmat: (double.parse(relatedRawmat.weightOfRawmat) - double.parse(updatedWarehouse.numberOfBoxesPreparedWarehouse) * double.parse(relatedFundamental.weightOfOneBox)).toString(),
                    );
                    widget.onRawmatsUpdated(rawmats);

                    Navigator.pop(context, updatedWarehouse);
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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.black,
                      content: Text('Boşluqları doldurun'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              backgroundColor: Colors.transparent,
              child: Text(
                widget.warehouse == null ? 'Yeni malı əlavə et' : 'Təsdiqlə',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
