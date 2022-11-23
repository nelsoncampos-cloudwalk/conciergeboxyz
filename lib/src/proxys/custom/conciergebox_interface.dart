import 'package:web3dart/web3dart.dart';

abstract class IConciergeBox {
  Future<String> setCocierges({required String address});
  Future<List<String>> getCocierges();

  Future<String> distribute();
}
