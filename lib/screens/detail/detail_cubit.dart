import 'package:cook_book/network/model/product_entity.dart';
import 'package:cook_book/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit({@required this.repository}) : super(DetailState_Info());

  final NetworkRepository repository;
  bool isFavorite = false;

  Future<bool> addToFavorite(ProductEntity entity) async {}
}
