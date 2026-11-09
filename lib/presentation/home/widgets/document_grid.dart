import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:test_task/domain/entities/app_document.dart';
import 'package:test_task/presentation/home/widgets/document_preview.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/durations.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

typedef DocumentLongPressCallback = void Function(int documentId, Offset globalPosition);

class DocumentGrid extends StatelessWidget {
  const DocumentGrid({
    super.key,
    required this.documents,
    required this.isSelectMode,
    required this.selectedDocumentIds,
    required this.documentContextMenuId,
    required this.onDocumentPressed,
    required this.onDocumentLongPressed,
  });

  static const _minColumns = 1;
  static const _inactiveOpacity = 0.2;

  final List<AppDocument> documents;
  final bool isSelectMode;
  final Set<int> selectedDocumentIds;
  final int? documentContextMenuId;
  final ValueChanged<int> onDocumentPressed;
  final DocumentLongPressCallback onDocumentLongPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - AppDimens.padding16 * 2;
        final columns = math.max(_minColumns, (availableWidth / AppDimens.documentCardDesignWidth).floor());

        return GridView.builder(
          padding: EdgeInsets.only(
            left: AppDimens.padding16,
            right: AppDimens.padding16,
            bottom:
                MediaQuery.paddingOf(context).bottom +
                AppDimens.floatingToolbarPadding +
                AppDimens.floatingToolbarHeight,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppDimens.padding12,
            mainAxisSpacing: AppDimens.padding16,
            childAspectRatio: AppDimens.documentCardAspectRatio,
          ),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index];
            return AnimatedOpacity(
              duration: AppDurations.animation,
              opacity: documentContextMenuId != null && documentContextMenuId != document.id ? _inactiveOpacity : 1,
              child: _DocumentCard(
                document: document,
                isSelectMode: isSelectMode,
                isSelected: selectedDocumentIds.contains(document.id),
                onPressed: () => onDocumentPressed(document.id),
                onLongPressStart: (globalPosition) {
                  onDocumentLongPressed(document.id, globalPosition);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.isSelectMode,
    required this.isSelected,
    required this.onPressed,
    required this.onLongPressStart,
  });

  static const _titleMaxLines = 1;
  static const _dateMaxLines = 1;
  static const _titleFontSize = 14.0;
  static const _dateFontSize = 11.0;
  static const _textHeight = 1.2;
  static const _letterSpacing = 0.0;
  static const _previewTitleGap = AppDimens.padding12;

  final AppDocument document;
  final bool isSelectMode;
  final bool isSelected;
  final VoidCallback onPressed;
  final ValueChanged<Offset> onLongPressStart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      onLongPressStart: isSelectMode ? null : (details) => onLongPressStart(details.globalPosition),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DocumentPreview(document: document, isSelectMode: isSelectMode, isSelected: isSelected),
          const SizedBox(height: _previewTitleGap),
          Text(
            document.title,
            maxLines: _titleMaxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.appColors.documentTitleText,
              fontSize: _titleFontSize,
              height: _textHeight,
              letterSpacing: _letterSpacing,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimens.padding4),
          Text(
            _formatDate(document.createdAt),
            maxLines: _dateMaxLines,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.appColors.documentDateText,
              fontSize: _dateFontSize,
              height: _textHeight,
              letterSpacing: _letterSpacing,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }
}
