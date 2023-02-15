// ignore_for_file: always_put_required_named_parameters_first

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

/// The type definition for a JSON-serializable [Map].
typedef JsonMap = Map<String, dynamic>;

/// {@template note}
/// A single `todo` item.
///
/// Contains a [title], [content], [lastEdited] and [id].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Note]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@JsonSerializable()
class Note extends Equatable {
  /// {@macro note}
  Note({
    String? id,
    required this.title,
    this.content = '',
    required this.lastEdited,
  })  : assert(
          id == null || id.isNotEmpty,
          'id cannot be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the `note`.
  ///
  /// Cannot be empty.
  final String id;

  /// The title of the `note`.
  ///
  /// Note that the title may be empty.
  final String title;

  /// The description of the `note`.
  ///
  /// Defaults to an empty string.
  final String content;

  /// Last time when the `note` was edited.
  final DateTime lastEdited;

  /// Returns a copy of this `note` with the given values updated.
  ///
  /// {@macro note}
  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? lastEdited,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastEdited: lastEdited ?? this.lastEdited,
    );
  }

  /// Deserializes the given [JsonMap] into a [Note].
  static Note fromJson(JsonMap json) => _$NoteFromJson(json);

  /// Converts this [Note] into a [JsonMap].
  JsonMap toJson() => _$NoteToJson(this);

  @override
  List<Object?> get props => [id, title, content, lastEdited];
}
