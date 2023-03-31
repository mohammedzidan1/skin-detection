part of 'skin_cubit.dart';

@immutable
abstract class SkinState {}

class SkinInitialState extends SkinState {}

class SkinLoadingState extends SkinState {}

class SkinSuccessState extends SkinState {}

class SkinErrorState extends SkinState {}
