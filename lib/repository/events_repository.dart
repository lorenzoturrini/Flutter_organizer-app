// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venturiautospurghi/models/event.dart';
import 'package:venturiautospurghi/plugin/dispatcher/platform_loader.dart';
import 'package:venturiautospurghi/utils/global_methods.dart';


class EventsRepository {
  final collection = PlatformUtils.fire.collection('Eventi');
  Map<String,dynamic> categories;
  Future init() async {
    categories = await Utils.getCategories();
    return;
  }

  @override
  Future<void> addNewEvent(Event e) {
    return collection.add(e.toDocument());
  }

  @override
  Future<void> deleteEvent(Event todo) async {
    return collection.document(todo.id).delete();
  }

  @override
  Future<List<Event>> getEvents(DateTime selectedDay) async {
    var docs = await collection.where("days",isGreaterThanOrEqualTo:new DateTime.now().day).getDocuments();
    List a = docs.documents.map((doc) => Event.fromMap(doc.documentID, categories[doc["Categoria"]]??categories['default'],doc))
          .toList();
    print(a.length);
    return a;
  }
  
  @override
  Stream<List<Event>> events() {
    return collection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Event.fromMap(doc.documentID, categories[doc["Categoria"]]!=null?categories[doc["Categoria"]]:categories['default'],doc))
          .toList();
    });
  }

  @override
  Stream<List<Event>> getOperatorEvents(String uuid) {
    return collection.where("SubOperatori","array-contains", "uuid").snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Event.fromMap(doc.documentID, categories[doc["Categoria"]]!=null?categories[doc["Categoria"]]:categories['default'],doc))
          .toList();
    });
  }

  @override
  Future<void> updateEvent(Event update) {
    return collection
        .document(update.id)
        .updateData(update.toDocument());
  }

  @override
  Stream<List<Event>> eventsWating() {
    return collection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Event.fromMap(doc.documentID, categories[doc["Categoria"]]!=null?categories[doc["Categoria"]]:categories['default'],doc))
          .toList();
    });
  }
}
