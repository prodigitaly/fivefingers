import 'package:hive/hive.dart';

part 'pdf_model.g.dart';

@HiveType(typeId: 0)
class PdfProduct {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? link;



  PdfProduct({
    this.id,
    this.title,

    this.link,

  });
}
