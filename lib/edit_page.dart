import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:organizercaspianexpress/fundamental_model.dart';
import 'package:organizercaspianexpress/note_model.dart';
import 'package:organizercaspianexpress/warehouse_model.dart';

class EditPage extends StatefulWidget {
  final List<Warehouse> warehouses;
  final Function(List<Warehouse>) onWarehousesUpdated;

  final List<Fundamental> fundamentals;

  final Note? note;

  const EditPage({Key? key, this.note, required this.warehouses, required this.fundamentals, required this.onWarehousesUpdated}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  late TextEditingController _nameOfProductController;
  late TextEditingController _contentController;
  late TextEditingController _numberOfBoxesCustomerWantsController;
  late TextEditingController _nameOfCustomerController;
  late TextEditingController _telOfCustomerController;

  String selectedProductTypeCategory = '';
  Future<void> _showProductTypeDropdown() async {
    String? newValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: DropdownButton<String>(
            isDense: true,
            value: _nameOfProductController.text == '' ? selectedProductTypeCategory : _nameOfProductController.text,
            onChanged: (String? value) {
              if (value != null) {
                _nameOfProductController.text = value;
                Navigator.pop(context, value); // Close the dialog and return the selected value
              }
            },
            items: widget.warehouses.map((warehouse) => warehouse.nameOfWarehouse).toList().map<DropdownMenuItem<String>>((String value) {
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
    selectedProductTypeCategory = widget.warehouses.isNotEmpty
        ? widget.warehouses[0].nameOfWarehouse
        : ''; // You can change the default value as needed

    _nameOfProductController = TextEditingController(text: widget.note?.nameOfProduct ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _numberOfBoxesCustomerWantsController = TextEditingController(text: widget.note?.numberOfBoxesCustomerWants ?? '');
    _nameOfCustomerController = TextEditingController(text: widget.note?.nameOfCustomer ?? '');
    _telOfCustomerController = TextEditingController(text: widget.note?.telOfCustomer ?? '');
  }

  @override
  void dispose() {
    _nameOfProductController.dispose();
    _contentController.dispose();
    _numberOfBoxesCustomerWantsController.dispose();
    _nameOfCustomerController.dispose();
    _telOfCustomerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                        widget.note == null ? 'Yeni Satılan' : 'Düzəliş et Satılana',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: _nameOfProductController,
                      decoration: InputDecoration(
                        labelText: 'Malın adı',
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
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _nameOfCustomerController,
                      decoration: InputDecoration(
                        labelText: 'Müştəri adı',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                        ),
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _telOfCustomerController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9+]*$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'əlaqə nömrəsi',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                        ),
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _numberOfBoxesCustomerWantsController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9. ]*$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Karobka / Salafan / Meşok sifariş sayı',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                        ),
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Qeyd etmək istədikləriniz',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                  ),
                ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (widget.note != null) ...[
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(), // Empty container to push text to the right
                    ),
                    Card(
                      elevation: 4,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Toplam Maya dəyərləri',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              "${NumberFormat("###,###.##", "en_US").format(double.parse(widget.note!.mainValue)).replaceAll(',', "'")} AZN",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 70,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.black87,
            ),
            child: FloatingActionButton(
              onPressed: () {
                if (_nameOfProductController.text.isNotEmpty &&
                    _numberOfBoxesCustomerWantsController.text.isNotEmpty &&
                    _telOfCustomerController.text.isNotEmpty)
                {
                  String nameOfProduct = _nameOfProductController.text;
                  String content = _contentController.text;
                  DateTime editedTime = DateTime.now();
                  String numberOfBoxesCustomerWants = _numberOfBoxesCustomerWantsController.text;
                  String nameOfCustomer = _nameOfCustomerController.text;
                  String telOfCustomer = _telOfCustomerController.text;

                  Fundamental relatedFundamental = widget.fundamentals.firstWhere(
                        (fundamental) => fundamental.nameOfProduct == nameOfProduct,
                  );

                  String mainValue = (double.parse(relatedFundamental.priceOfOneBox) * double.parse(numberOfBoxesCustomerWants)).toString();

                  Note updatedNote = Note(
                    nameOfProduct: nameOfProduct,
                    content: content,
                    editedTime: editedTime,
                    numberOfBoxesCustomerWants: numberOfBoxesCustomerWants,
                    nameOfCustomer: nameOfCustomer,
                    telOfCustomer: telOfCustomer,
                    mainValue: mainValue,
                  );
                  
                  // Decrease Warehouse.numberOfBoxesPreparedWarehouse
                  Warehouse relatedWarehouse = widget.warehouses.firstWhere(
                        (warehouse) => warehouse.nameOfWarehouse == nameOfProduct,
                  );
                  if (double.parse(relatedWarehouse.numberOfBoxesPreparedWarehouse) >= double.parse(updatedNote.numberOfBoxesCustomerWants)) {
                    int i = widget.warehouses.indexOf(relatedWarehouse);
                    List<Warehouse> warehouses = widget.warehouses;
                    warehouses[i] = Warehouse(
                      editedTime: editedTime,
                      nameOfWarehouse: nameOfProduct,
                      numberOfBoxesPreparedWarehouse: (double.parse(relatedWarehouse.numberOfBoxesPreparedWarehouse) - double.parse(numberOfBoxesCustomerWants)).toString(),
                    );
                    widget.onWarehousesUpdated(warehouses);

                    Navigator.pop(context, updatedNote);
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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.black,
                      content: Text('Xanaları doldurun'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              backgroundColor: Colors.transparent,
              child: Text(
                widget.note == null ? 'əlavə et' : 'Yadda saxla',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
