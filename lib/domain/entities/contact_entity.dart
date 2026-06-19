import 'package:google_contacts_app/core/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_entity.g.dart';

DateTime _dateTimeFromJson(String json) => DateTime.parse(json);

String _dateTimeToJson(DateTime date) => date.toIso8601String();

DateTime? _nullableBirthdayFromJson(String? json) =>
    DateUtilsX.birthdayFromStorage(json);

String? _nullableBirthdayToJson(DateTime? date) =>
    DateUtilsX.birthdayToStorage(date);

@JsonSerializable(explicitToJson: true)
class ContactEntity {
  const ContactEntity({
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

  factory ContactEntity.fromJson(Map<String, dynamic> json) =>
      _$ContactEntityFromJson(json);

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

  Map<String, dynamic> toJson() => _$ContactEntityToJson(this);

  ContactEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? nickname,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? department,
    List<String>? websiteUrls,
    DateTime? birthday,
    String? notes,
    bool? isFavorite,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContactEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      department: department ?? this.department,
      websiteUrls: websiteUrls ?? this.websiteUrls,
      birthday: birthday ?? this.birthday,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
