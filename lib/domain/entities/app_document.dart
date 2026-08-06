import 'package:equatable/equatable.dart';

final class AppDocument extends Equatable {
  const AppDocument({
    required this.id,
    required this.title,
    required this.pdfPath,
    required this.firstPreviewPath,
    required this.createdAt,
    required this.isSigned,
    this.lastPreviewPath,
  });

  final int id;
  final String title;
  final String pdfPath;
  final String firstPreviewPath;
  final String? lastPreviewPath;
  final DateTime createdAt;
  final bool isSigned;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      pdfPath,
      firstPreviewPath,
      lastPreviewPath,
      createdAt,
      isSigned,
    ];
  }
}
