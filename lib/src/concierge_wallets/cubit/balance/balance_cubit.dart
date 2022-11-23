import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../proxys/erc20/brlc/brlc_proxy.dart';
part 'balance_cubit.freezed.dart';
part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final BrlcProxy brlcProxy;

  BalanceCubit({
    required this.brlcProxy,
  }) : super(const BalanceState.initial());

  Future<void> balanceOfWallet() async {
    try {
      emit(const BalanceState.loading());

      final currentBalance = await brlcProxy.balanceOf(
        address: "0xe23048452e5b609ca8f13f00430299fe9600bc9f",
      );

      emit(
        BalanceState.success(
          balance: currentBalance,
          symbol: "BRLC",
        ),
      );
    } catch (e) {
      emit(const BalanceState.error());
    }
  }
}
