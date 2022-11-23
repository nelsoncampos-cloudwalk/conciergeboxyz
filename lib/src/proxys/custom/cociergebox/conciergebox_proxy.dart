import 'package:web3dart/web3dart.dart';

import '../conciergebox_interface.dart';
import 'service/conciergebox.g.dart';

class CociergeBoxProxy implements IConciergeBox {
  final Conciergebox _conciergebox;
  final String _owner;

  CociergeBoxProxy({
    required Conciergebox conciergebox,
    required String owner,
  })  : _conciergebox = conciergebox,
        _owner = owner;

  @override
  Future<String> distribute() async {
    return await _conciergebox.distributeToConcierges(
      credentials: EthPrivateKey.fromHex(_owner),
    );
  }

  @override
  Future<List<String>> getCocierges() async {
    final conciergesAddress = await _conciergebox.getConcierges();
    return conciergesAddress.map((address) => address.hex).toList();
  }

  @override
  Future<String> setCocierges({required String address}) async {
    return await _conciergebox.setConcierge(
      EthereumAddress.fromHex(address),
      credentials: EthPrivateKey.fromHex(_owner),
    );
  }
}
