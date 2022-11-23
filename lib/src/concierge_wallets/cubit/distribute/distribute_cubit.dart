import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../proxys/custom/cociergebox/conciergebox_proxy.dart';

part 'distribute_cubit.freezed.dart';
part 'distribute_state.dart';

class DistributeCubit extends Cubit<DistributeState> {
  final CociergeBoxProxy cociergeBoxProxy;

  DistributeCubit({
    required this.cociergeBoxProxy,
  }) : super(const DistributeState.initial());

  Future<void> distribute() async {
    try {
      emit(const DistributeState.loading());

      final tx = await cociergeBoxProxy.distribute();

      emit(DistributeState.success(tx: tx));
    } catch (e) {
      emit(const DistributeState.error(message: 'Something goes wrong'));
    }
  }

  Future<void> setConcierges({required String address}) async {
    try {
      emit(const DistributeState.loading());

      final tx = await cociergeBoxProxy.setCocierges(address: address);

      emit(DistributeState.success(tx: tx));
    } catch (e) {
      emit(const DistributeState.error(message: 'Something goes wrong'));
    }
  }
}
