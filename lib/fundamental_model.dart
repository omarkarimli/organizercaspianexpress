// lib/fundamental_model.dart

class Fundamental {
  DateTime editedTime;
  String nameOfRawmat;
  String nameOfProduct;
  String gramOfOnePiece;
  String numberOfPiecesInPackage;
  String priceOfPackageMat;
  String numberOfPackagesInBox;
  String typeOfBox;
  String priceOfBoxMat;
  String priceOfWorkLoad;
  String priceOfOneBoxTotalMat;
  String priceOfOneBox;
  String weightOfOneBox;

  Fundamental({
    required this.editedTime,
    required this.nameOfRawmat,
    required this.nameOfProduct,
    required this.gramOfOnePiece,
    required this.numberOfPiecesInPackage,
    required this.priceOfPackageMat,
    required this.numberOfPackagesInBox,
    required this.typeOfBox,
    required this.priceOfBoxMat,
    required this.priceOfWorkLoad,
    required this.priceOfOneBoxTotalMat,
    required this.priceOfOneBox,
    required this.weightOfOneBox,
  });
}
