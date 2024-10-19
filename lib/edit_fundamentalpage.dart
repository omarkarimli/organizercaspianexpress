import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:organizercaspianexpress/fundamental_model.dart';
import 'package:organizercaspianexpress/rawmat_model.dart';

class EditFundamentalPage extends StatefulWidget {
  final List<Rawmat> rawmats;

  final Fundamental? fundamental;

  const EditFundamentalPage({Key? key, this.fundamental, required this.rawmats}) : super(key: key);

  @override
  State<EditFundamentalPage> createState() => _EditFundamentalPageState();
}

class _EditFundamentalPageState extends State<EditFundamentalPage> {
  late TextEditingController _nameOfProductController;
  late TextEditingController _gramOfOnePieceController;
  late TextEditingController _numberOfPiecesInPackageController;
  late TextEditingController _priceOfPackageMatController;
  late TextEditingController _numberOfPackagesInBoxController;
  late TextEditingController _typeOfBoxController;
  late TextEditingController _priceOfBoxMatController;
  late TextEditingController _priceOfWorkLoadController;
  late TextEditingController _nameOfRawmatController;

  String selectedRawmatTypeCategory = '';
  Future<void> _showRawmatTypeDropdown() async {
    String? newValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: DropdownButton<String>(
            isDense: true,
            value: _nameOfRawmatController.text == '' ? selectedRawmatTypeCategory : _nameOfRawmatController.text,
            onChanged: (String? value) {
              if (value != null) {
                _nameOfRawmatController.text = value;
                Navigator.pop(context, value); // Close the dialog and return the selected value
              }
            },
            items: widget.rawmats.map((rawmat) => rawmat.nameOfRawmat).toList().map<DropdownMenuItem<String>>((String value) {
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
        selectedRawmatTypeCategory = newValue;
      });
    }
  }

  String selectedBoxTypeCategory = 'Salafan';
  Future<void> _showBoxCategoryDropdown() async {
    String? newValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: DropdownButton<String>(
            isDense: true,
            value: _typeOfBoxController.text == '' ? selectedBoxTypeCategory : _typeOfBoxController.text,
            onChanged: (String? value) {
              if (value != null) {
                _typeOfBoxController.text = value;
                Navigator.pop(context, value); // Close the dialog and return the selected value
              }
            },
            items: <String>['Salafan', 'Karobka', 'Meşok']
                .map<DropdownMenuItem<String>>((String value) {
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
        selectedBoxTypeCategory = newValue;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedRawmatTypeCategory = widget.rawmats.isNotEmpty
        ? widget.rawmats[0].nameOfRawmat
        : ''; // You can change the default value as needed

    _nameOfProductController = TextEditingController(text: widget.fundamental?.nameOfProduct ?? '');
    _gramOfOnePieceController = TextEditingController(text: widget.fundamental?.gramOfOnePiece ?? '');
    _numberOfPiecesInPackageController = TextEditingController(text: widget.fundamental?.numberOfPiecesInPackage ?? '');
    _priceOfPackageMatController = TextEditingController(text: widget.fundamental?.priceOfPackageMat ?? '');
    _numberOfPackagesInBoxController = TextEditingController(text: widget.fundamental?.numberOfPackagesInBox ?? '');
    _typeOfBoxController = TextEditingController(text: widget.fundamental?.typeOfBox ?? '');
    _priceOfBoxMatController = TextEditingController(text: widget.fundamental?.priceOfBoxMat ?? '');
    _priceOfWorkLoadController = TextEditingController(text: widget.fundamental?.priceOfWorkLoad ?? '');
    _nameOfRawmatController = TextEditingController(text: widget.fundamental?.nameOfRawmat ?? '');
  }

  @override
  void dispose() {
    _nameOfProductController.dispose();
    _gramOfOnePieceController.dispose();
    _numberOfPiecesInPackageController.dispose();
    _priceOfPackageMatController.dispose();
    _numberOfPackagesInBoxController.dispose();
    _typeOfBoxController.dispose();
    _priceOfBoxMatController.dispose();
    _priceOfWorkLoadController.dispose();
    _nameOfRawmatController.dispose();
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
                        widget.fundamental == null ? 'Yeni Mal növü' : 'Düzəliş et',
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
                controller: _nameOfRawmatController,
                decoration: InputDecoration(
                  labelText: 'Xammal növü',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                  ),
                ),
                style: Theme.of(context).textTheme.titleSmall,
                onTap: () => _showRawmatTypeDropdown(),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameOfProductController,
                decoration: InputDecoration(
                  labelText: 'Malın adı',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                  ),
                ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _gramOfOnePieceController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9. ]*$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: '1 ədədin qramı',
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
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _numberOfPiecesInPackageController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]*$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: '1 boş paketin tutum sayı',
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
                      controller: _priceOfPackageMatController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9. ]*$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: '1 ədəd boş paketin qiyməti',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        suffixText: 'AZN',
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                        ),
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _numberOfPackagesInBoxController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]*$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: '1 Salafan / Karobka / Meşokun paket tutum sayı',
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
                      readOnly: true,
                      controller: _typeOfBoxController,
                      decoration: InputDecoration(
                        labelText: 'Salafan / Karobka / Meşok növü',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                        ),
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                      onTap: () => _showBoxCategoryDropdown(),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _priceOfBoxMatController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9. ]*$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: '1 ədəd boş Salafan / Karobka / Meşokun qiyməti',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        suffixText: 'AZN',
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
                controller: _priceOfWorkLoadController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[0-9. ]*$'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'İşçi qüvvəsi sərfiyyatı',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  suffixText: 'AZN',
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(width: 3, color: Colors.greenAccent),
                  ),
                ),
                style: Theme.of(context).textTheme.titleLarge,
              ),

              if (widget.fundamental != null) ...[
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
                              '1 ' + widget.fundamental!.typeOfBox + ' malın ' + 'tam kütləsi',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              "${NumberFormat("###,###.##", "en_US").format(double.parse(widget.fundamental!.weightOfOneBox)).replaceAll(',', "'")} kq",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
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
                              '1 ' + widget.fundamental!.typeOfBox + ' malın ' + 'Qablaşdırma xərci',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              "${NumberFormat("###,###.##", "en_US").format(double.parse(widget.fundamental!.priceOfOneBoxTotalMat)).replaceAll(',', "'")} AZN",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
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
                              '1 ' + widget.fundamental!.typeOfBox + ' malın ' + 'Toplam Maya dəyəri',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              "${NumberFormat("###,###.##", "en_US").format(double.parse(widget.fundamental!.priceOfOneBox)).replaceAll(',', "'")} AZN",
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
                if (_nameOfRawmatController.text.isNotEmpty &&
                    _nameOfProductController.text.isNotEmpty &&
                    _gramOfOnePieceController.text.isNotEmpty &&
                    _numberOfPiecesInPackageController.text.isNotEmpty &&
                    _priceOfPackageMatController.text.isNotEmpty &&
                    _numberOfPackagesInBoxController.text.isNotEmpty &&
                    _typeOfBoxController.text.isNotEmpty &&
                    _priceOfBoxMatController.text.isNotEmpty &&
                    _priceOfWorkLoadController.text.isNotEmpty) {

                  DateTime editedTime = DateTime.now();

                  String nameOfRawmat = _nameOfRawmatController.text;
                  String nameOfProduct = _nameOfProductController.text;
                  String gramOfOnePiece = _gramOfOnePieceController.text;
                  String numberOfPiecesInPackage = _numberOfPiecesInPackageController.text;
                  String priceOfPackageMat = _priceOfPackageMatController.text;
                  String numberOfPackagesInBox = _numberOfPackagesInBoxController.text;
                  String typeOfBox = _typeOfBoxController.text;
                  String priceOfBoxMat = _priceOfBoxMatController.text;
                  String priceOfWorkLoad = _priceOfWorkLoadController.text;
                  String priceOfOneBoxTotalMat = (double.parse(priceOfBoxMat) + double.parse(priceOfPackageMat) * double.parse(numberOfPackagesInBox)).toString();

                  Rawmat relatedRawmat = widget.rawmats.firstWhere(
                        (rawmat) => rawmat.nameOfRawmat == nameOfRawmat,
                  );

                  String weightOfOneBox = ((double.parse(gramOfOnePiece) / 1000 * double.parse(numberOfPiecesInPackage) * double.parse(numberOfPackagesInBox)) * 101 / 100).toString();
                  String priceOfOneBox = (double.parse(weightOfOneBox) * double.parse(relatedRawmat.priceOfOneKiloRawmat) + double.parse(priceOfOneBoxTotalMat) + double.parse(priceOfWorkLoad)).toString();

                  Fundamental updatedFundamental = Fundamental(
                    editedTime: editedTime,
                    nameOfRawmat: nameOfRawmat,
                    nameOfProduct: nameOfProduct,
                    gramOfOnePiece: gramOfOnePiece,
                    numberOfPiecesInPackage: numberOfPiecesInPackage,
                    priceOfPackageMat: priceOfPackageMat,
                    numberOfPackagesInBox: numberOfPackagesInBox,
                    typeOfBox: typeOfBox,
                    priceOfBoxMat: priceOfBoxMat,
                    priceOfWorkLoad: priceOfWorkLoad,
                    priceOfOneBoxTotalMat: priceOfOneBoxTotalMat,
                    priceOfOneBox: priceOfOneBox,
                    weightOfOneBox: weightOfOneBox,
                  );
                  Navigator.pop(context, updatedFundamental);
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
                widget.fundamental == null ? 'Yeni malı əlavə et' : 'Təsdiqlə',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
