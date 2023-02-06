// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ComplaintTypes {
  final List<ComplaintTypesDetails> complaintTypes;
  ComplaintTypes({
    this.complaintTypes = const [],
  });

  ComplaintTypes copyWith({
    List<ComplaintTypesDetails>? complaintTypes,
  }) {
    return ComplaintTypes(
      complaintTypes: complaintTypes ?? this.complaintTypes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'complaint_types': complaintTypes.map((x) => x.toMap()).toList(),
    };
  }

  factory ComplaintTypes.fromMap(Map<String, dynamic> map) {
    return ComplaintTypes(
      complaintTypes: List<ComplaintTypesDetails>.from(
        (map['complaint_types']).map<ComplaintTypesDetails>(
          (x) => ComplaintTypesDetails.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplaintTypes.fromJson(String source) =>
      ComplaintTypes.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ComplaintTypes(complaintTypes: $complaintTypes)';

  @override
  bool operator ==(covariant ComplaintTypes other) {
    if (identical(this, other)) return true;

    return listEquals(other.complaintTypes, complaintTypes);
  }

  @override
  int get hashCode => complaintTypes.hashCode;
}

class ComplaintTypesDetails extends Equatable {
  final int id;
  final String title;
  const ComplaintTypesDetails({
    this.id = 0,
    this.title = '',
  });

  ComplaintTypesDetails copyWith({
    int? id,
    String? title,
  }) {
    return ComplaintTypesDetails(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory ComplaintTypesDetails.fromMap(Map<String, dynamic> map) {
    return ComplaintTypesDetails(
      id: map['id'] as int,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplaintTypesDetails.fromJson(String source) =>
      ComplaintTypesDetails.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, title];
}
