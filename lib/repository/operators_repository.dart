// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:venturiautospurghi/models/user.dart';
import 'package:venturiautospurghi/plugin/dispatcher/platform_loader.dart';


class OperatorsRepository {
  final collection = PlatformUtils.fire.collection('Utenti');
  Map<String,dynamic> categories;

  @override
  Future<void> addNewOperator(Account u) {
    return collection.add(u.toDocument());
  }

  @override
  Future<List<Account>> getOperators() async {
    var docs = await collection.getDocuments();
    List a = docs.documents.map((doc) => Account.fromMap(doc.documentID, doc)).toList();
    return a;
  }

}
