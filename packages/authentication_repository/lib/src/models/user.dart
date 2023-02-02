// ignore_for_file: sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';

/// {@template user}
/// User model.
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    this.email,
    required this.id,
    this.username,
    this.fullName,
    this.avatarUrl,
    this.updatedAt,
  });

  /// The current user's email.
  final String? email;

  /// The current user's ID.
  final String id;

  /// The current user's username.
  final String? username;

  /// The current user's full name.
  final String? fullName;

  /// Url for the photo of the current user.
  final String? avatarUrl;

  /// Last time when the user was updated.
  final DateTime? updatedAt;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenient getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenient getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props =>
      [email, id, username, fullName, avatarUrl, updatedAt];

  /// Creates a copy of this class with updated values.
  ///
  /// {@macro user}
  User copyWith({
    String? email,
    String? id,
    String? username,
    String? fullName,
    String? avatarUrl,
    DateTime? updatedAt,
  }) {
    return User(
      email: email ?? this.email,
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Creates User from a map object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: (map['id'] ?? '') as String,
      fullName: map['full_name'] as String?,
      username: map['username'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }
}
