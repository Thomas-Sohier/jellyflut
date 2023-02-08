import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_attachment.freezed.dart';
part 'media_attachment.g.dart';

@Freezed()
class MediaAttachment with _$MediaAttachment {
  factory MediaAttachment(
      {
      /// Gets or sets the codec.
      String? codec,

      ///Gets or sets the codec tag.
      String? codecTag,

      /// Gets or sets the comment
      String? comment,

      /// Gets or sets the index
      int? index,

      /// Gets or sets the filename
      String? fileName,

      /// Gets or sets the MIME type
      String? mimeType,

      /// Gets or sets the delivery URL
      String? deliveryUrl}) = _MediaAttachment;

  factory MediaAttachment.fromJson(Map<String, Object?> json) => _$MediaAttachmentFromJson(json);
}
