part of 'distribute_cubit.dart';

@freezed
class DistributeState with _$DistributeState {
  const factory DistributeState.initial() = _Initial;
  const factory DistributeState.loading() = _Loading;
  const factory DistributeState.success({required String tx}) = _Success;
  const factory DistributeState.error({required String message}) = _Error;
}
