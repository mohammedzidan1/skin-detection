import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../utilites/constants.dart';

part 'skin_state.dart';

class SkinCubit extends Cubit<SkinState> {
  SkinCubit() : super(SkinInitialState());

  SkinCubit get(context) => BlocProvider.of(context);

  String? result;

  upload({File? img}) async {
    emit(SkinLoadingState());
    final request = http.MultipartRequest("POST", Uri.parse(url));
    final header = {"Content_type": "multipart/form-data"};
    request.files.add(http.MultipartFile(
        'fileup', img!.readAsBytes().asStream(), img!.lengthSync(),
        filename: img.path.split('/').last));
    request.headers.addAll(header);
    final myRequest = await request.send();
    http.Response res = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200) {
      final resJson = jsonDecode(res.body);
      print("response here: $resJson");
      result = resJson['prediction'];
      emit(SkinSuccessState());
    } else {
      emit(SkinErrorState());
      print("Error ${myRequest.statusCode}");
    }
  }
}
