import 'dart:convert';

import 'package:google_contacts_app/core/utils/date_utils.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_model.g.dart';

DateTime _dateTimeFromJson(String json) => DateTime.parse(json);

String _dateTimeToJson(DateTime date) => date.toIso8601String();

DateTime? _nullableBirthdayFromJson(String? json) =>
    DateUtilsX.birthdayFromStorage(json);

String? _nullableBirthdayToJson(DateTime? date) =>
    DateUtilsX.birthdayToStorage(date);

List<String> _stringListFromMapValue(dynamic value) {
  if (value == null) {
    return const [];
  }
  if (value is String) {
    return (jsonDecode(value) as List<dynamic>).map((e) => e as String).toList();
  }
  return (value as List<dynamic>).map((e) => e as String).toList();
}

String? _nullableTrimmedString(Object? value) {
  if (value == null) {
    return null;
  }
  final trimmed = (value as String).trim();
  return trimmed.isEmpty ? null : trimmed;
}

@JsonSerializable(explicitToJson: true)
class ContactModel {
  const ContactModel({
    required this.id,
    required this.firstName,
    this.lastName = '',
    this.nickname,
    this.phone,
    this.email,
    this.company,
    this.jobTitle,
    this.department,
    this.websiteUrls = const [],
    this.birthday,
    this.notes,
    this.isFavorite = false,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
        id: map['id'] as String,
        firstName: map['first_name'] as String,
        lastName: map['last_name'] as String? ?? '',
        nickname: map['nickname'] as String?,
        phone: _nullableTrimmedString(map['phone']),
        email: _nullableTrimmedString(map['email']),
        company: map['company'] as String?,
        jobTitle: map['job_title'] as String?,
        department: map['department'] as String?,
        websiteUrls: _stringListFromMapValue(map['website_urls']),
        birthday: DateUtilsX.birthdayFromStorage(map['birthday'] as String?),
        notes: map['notes'] as String?,
        isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
        isSynced: (map['is_synced'] as int? ?? 0) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  factory ContactModel.fromEntity(ContactEntity entity) => ContactModel(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        nickname: entity.nickname,
        phone: entity.phone,
        email: entity.email,
        company: entity.company,
        jobTitle: entity.jobTitle,
        department: entity.department,
        websiteUrls: entity.websiteUrls,
        birthday: entity.birthday,
        notes: entity.notes,
        isFavorite: entity.isFavorite,
        isSynced: entity.isSynced,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  final String id;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name', defaultValue: '')
  final String lastName;

  @JsonKey(includeIfNull: false)
  final String? nickname;

  @JsonKey(includeIfNull: false)
  final String? phone;

  @JsonKey(includeIfNull: false)
  final String? email;

  @JsonKey(includeIfNull: false)
  final String? company;

  @JsonKey(name: 'job_title', includeIfNull: false)
  final String? jobTitle;

  @JsonKey(includeIfNull: false)
  final String? department;

  @JsonKey(name: 'website_urls', defaultValue: <String>[])
  final List<String> websiteUrls;

  @JsonKey(
    fromJson: _nullableBirthdayFromJson,
    toJson: _nullableBirthdayToJson,
    includeIfNull: false,
  )
  final DateTime? birthday;

  @JsonKey(includeIfNull: false)
  final String? notes;

  @JsonKey(name: 'is_favorite', defaultValue: false)
  final bool isFavorite;

  @JsonKey(name: 'is_synced', defaultValue: false)
  final bool isSynced;

  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);

  Map<String, dynamic> toMap() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'nickname': nickname,
        'phone': phone,
        'email': email,
        'company': company,
        'job_title': jobTitle,
        'department': department,
        'website_urls': jsonEncode(websiteUrls),
        'birthday': DateUtilsX.birthdayToStorage(birthday),
        'notes': notes,
        'is_favorite': isFavorite ? 1 : 0,
        'is_synced': isSynced ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  ContactEntity toEntity() => ContactEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        nickname: nickname,
        phone: phone,
        email: email,
        company: company,
        jobTitle: jobTitle,
        department: department,
        websiteUrls: websiteUrls,
        birthday: birthday,
        notes: notes,
        isFavorite: isFavorite,
        isSynced: isSynced,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
