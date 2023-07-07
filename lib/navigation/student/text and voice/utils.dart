// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  static StreamTransformer transformer<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    return StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
      handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
        final snaps =
            data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        final users = snaps.map((json) => fromJson(json)).toList();
        sink.add(users);
      },
    );
  }

  static DateTime? toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static dynamic toDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return Timestamp.fromDate(date);
  }
}
