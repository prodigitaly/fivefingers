// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PdfProductAdapter extends TypeAdapter<PdfProduct> {
  @override
  final int typeId = 0;

  @override
  PdfProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfProduct(
      id: fields[0] as String?,
      title: fields[1] as String?,
      link: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PdfProduct obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
