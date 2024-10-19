import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organizercaspianexpress/rawmat_model.dart';

class EditRawmatPage extends StatefulWidget {
  final Rawmat? rawmat;

  const EditRawmatPage({Key? key, this.rawmat}) : super(key: key);

  @override
  State<EditRawmatPage> createState() => _EditRawmatPageState();
}

class _EditRawmatPageState extends State<EditRawmatPage> {
  late TextEditingController _nameOfRawmatController;
  late TextEditingController _weightOfRawmatController;
  late TextEditingController _priceOfOneKiloRawmatController;

  @override
  void initState() {
    super.initState();
    _nameOfRawmatController = TextEditingController(text: widget.rawmat?.nameOfRawmat ?? '');
    _weightOfRawmatController = TextEditingController(text: widget.rawmat?.weightOfRawmat ?? '');
    _priceOfOneKiloRawmatController = TextEditingController(text: widget.rawmat?.priceOfOneKiloRawmat ?? '');
  }

  @override
  void dispose() {
    _nameOfRawmatController.dispose();
    _weightOfRawmatController.dispose();
    _priceOfOneKiloRawmatController.dispose();
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
                        widget.rawmat == null ? 'Yeni Xammal' : 'Düzəliş et',
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
                      controller: _nameOfRawmatController,
                      decoration: InputDecoration(
                        labelText: 'Xammal adı',
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
                      controller: _weightOfRawmatController,
                      decoration: InputDecoration(
                        labelText: 'əldə olan xammal kilosu',
                        labelStyle: Theme.of(context).textTheme.titleSmall,
                        suffixText: ' kq',
                        suffixStyle: Theme.of(context).textTheme.titleSmall,
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
              const SizedBox(height: 24,),
              TextField(
                controller: _priceOfOneKiloRawmatController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[0-9. ]*$'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: '1 kilo xammalın qiyməti',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  suffixText: 'AZN',
                  suffixStyle: Theme.of(context).textTheme.titleSmall,
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
                if (_nameOfRawmatController.text.isNotEmpty
                    && _weightOfRawmatController.text.isNotEmpty
                    && _priceOfOneKiloRawmatController.text.isNotEmpty) {

                  DateTime editedTime = DateTime.now();
                  String nameOfRawmat = _nameOfRawmatController.text;
                  String weightOfRawmat = _weightOfRawmatController.text;
                  String priceOfOneKiloRawmat = _priceOfOneKiloRawmatController.text;

                  Rawmat updatedFundamental = Rawmat(
                    editedTime: editedTime,
                    nameOfRawmat: nameOfRawmat,
                    weightOfRawmat: weightOfRawmat,
                    priceOfOneKiloRawmat: priceOfOneKiloRawmat,
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
                widget.rawmat == null ? 'Yeni Xammalı əlavə et' : 'Təsdiqlə',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
