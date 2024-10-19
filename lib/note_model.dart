// lib/note_model.dart

import 'dart:ui';

class Note {
  String nameOfProduct;
  String content;
  DateTime editedTime;
  String numberOfBoxesCustomerWants;
  String nameOfCustomer;
  String telOfCustomer;
  String mainValue;

  Note({
    required this.nameOfProduct,
    required this.content,
    required this.editedTime,
    required this.numberOfBoxesCustomerWants,
    required this.nameOfCustomer,
    required this.telOfCustomer,
    required this.mainValue,
  });
}
