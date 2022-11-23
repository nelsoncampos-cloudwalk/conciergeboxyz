import '../../proxys/custom/cociergebox/conciergebox_proxy.dart';
import '../../proxys/custom/cociergebox/service/conciergebox.g.dart';
import '../../proxys/erc20/brlc/brlc_proxy.dart';
import '../../proxys/erc20/brlc/service/brlc.g.dart';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:js' as js;

import '../cubit/balance/balance_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cociergeBoxProxy = CociergeBoxProxy(
    conciergebox: Conciergebox(
      address: EthereumAddress.fromHex(
        '0x1E57c5d34E33df08Db5117D3C7517321b76231B4',
      ),
      client: Web3Client('https://rpc.testnet.cloudwalk.io', Client()),
      chainId: 2008,
    ),
    owner: "",
  );

  final brlcProxy = BrlcProxy(
    brlc: Brlc(
      address: EthereumAddress.fromHex(
        '0xA9a55a81a4C085EC0C31585Aed4cFB09D78dfD53',
      ),
      client: Web3Client('https://rpc.mainnet.cloudwalk.io', Client()),
      chainId: 2009,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Chave pix da caixinha: portariakalil@meu.pix',
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium,
            ),
          ),
          const SizedBox(height: 48),
          _Balance(brlcProxy: brlcProxy),
          const SizedBox(height: 48),
          // _Send(cociergeBoxProxy: cociergeBoxProxy),
        ],
      ),
    );
  }
}

// class _Send extends StatefulWidget {
//   final CociergeBoxProxy cociergeBoxProxy;
//   const _Send({
//     Key? key,
//     required this.cociergeBoxProxy,
//   }) : super(key: key);

//   @override
//   State<_Send> createState() => __SendState();
// }

// class __SendState extends State<_Send> {
//   final addressController = TextEditingController();
//   late final DistributeCubit distributeCubit;

//   @override
//   void initState() {
//     distributeCubit = DistributeCubit(
//       cociergeBoxProxy: widget.cociergeBoxProxy,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Center(
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 24),
//             width: 300,
//             child: InfiniteTextField(
//               controller: addressController,
//               keyboardType: TextInputType.number,
//               label: "Carteira do porteiro",
//             ),
//           ),
//         ),
//         const SizedBox(height: 48),
//         InfiniteButton(
//           isExpanded: false,
//           onTap: () async {
//             await distributeCubit.setConcierges(
//               address: addressController.text,
//             );
//           },
//           label: "Distribuir",
//         ),
//         BlocBuilder<DistributeCubit, DistributeState>(
//           bloc: distributeCubit,
//           builder: (context, state) {
//             return state.maybeWhen(
//               success: (tx) => GestureDetector(
//                 onTap: () => js.context.callMethod(
//                   'open',
//                   ['https://explorer.testnet.cloudwalk.io/tx/$tx'],
//                 ),
//                 child: Text(
//                   "https://explorer.testnet.cloudwalk.io/tx/$tx",
//                   style: context.typography.bodyRegular.copyWith(
//                     color: kColorBrandPrimary,
//                   ),
//                 ),
//               ),
//               error: (e) => Text(e),
//               loading: () => const Text("Loading"),
//               orElse: SizedBox.shrink,
//             );
//           },
//         )
//       ],
//     );
//   }
// }

class _Balance extends StatefulWidget {
  final BrlcProxy brlcProxy;
  const _Balance({
    Key? key,
    required this.brlcProxy,
  }) : super(key: key);

  @override
  State<_Balance> createState() => __BalanceState();
}

class __BalanceState extends State<_Balance> {
  late final BalanceCubit balanceCubit;

  @override
  void initState() {
    balanceCubit = BalanceCubit(
      brlcProxy: widget.brlcProxy,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await balanceCubit.balanceOfWallet();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      bloc: balanceCubit,
      builder: (context, state) {
        return state.maybeWhen(
          success: (symbol, balance) => Text(
            'Saldo acumulado na caixinha: $balance $symbol',
            style: context.typography.bodyRegular,
          ),
          error: () => Text(
            'Error to load the balance',
            style: context.typography.bodyRegular,
          ),
          orElse: () => Text(
            'Loading Balance',
            style: context.typography.bodyRegular,
          ),
        );
      },
    );
  }
}
