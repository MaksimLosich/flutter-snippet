// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DocumentRecordsTable extends DocumentRecords
    with TableInfo<$DocumentRecordsTable, DocumentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pdfPathMeta = const VerificationMeta(
    'pdfPath',
  );
  @override
  late final GeneratedColumn<String> pdfPath = GeneratedColumn<String>(
    'pdf_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstPreviewPathMeta = const VerificationMeta(
    'firstPreviewPath',
  );
  @override
  late final GeneratedColumn<String> firstPreviewPath = GeneratedColumn<String>(
    'first_preview_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPreviewPathMeta = const VerificationMeta(
    'lastPreviewPath',
  );
  @override
  late final GeneratedColumn<String> lastPreviewPath = GeneratedColumn<String>(
    'last_preview_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSignedMeta = const VerificationMeta(
    'isSigned',
  );
  @override
  late final GeneratedColumn<bool> isSigned = GeneratedColumn<bool>(
    'is_signed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_signed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    pdfPath,
    firstPreviewPath,
    lastPreviewPath,
    isSigned,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('pdf_path')) {
      context.handle(
        _pdfPathMeta,
        pdfPath.isAcceptableOrUnknown(data['pdf_path']!, _pdfPathMeta),
      );
    } else if (isInserting) {
      context.missing(_pdfPathMeta);
    }
    if (data.containsKey('first_preview_path')) {
      context.handle(
        _firstPreviewPathMeta,
        firstPreviewPath.isAcceptableOrUnknown(
          data['first_preview_path']!,
          _firstPreviewPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstPreviewPathMeta);
    }
    if (data.containsKey('last_preview_path')) {
      context.handle(
        _lastPreviewPathMeta,
        lastPreviewPath.isAcceptableOrUnknown(
          data['last_preview_path']!,
          _lastPreviewPathMeta,
        ),
      );
    }
    if (data.containsKey('is_signed')) {
      context.handle(
        _isSignedMeta,
        isSigned.isAcceptableOrUnknown(data['is_signed']!, _isSignedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      pdfPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_path'],
      )!,
      firstPreviewPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_preview_path'],
      )!,
      lastPreviewPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_preview_path'],
      ),
      isSigned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_signed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DocumentRecordsTable createAlias(String alias) {
    return $DocumentRecordsTable(attachedDatabase, alias);
  }
}

class DocumentRecord extends DataClass implements Insertable<DocumentRecord> {
  final int id;
  final String title;
  final String pdfPath;
  final String firstPreviewPath;
  final String? lastPreviewPath;
  final bool isSigned;
  final DateTime createdAt;
  const DocumentRecord({
    required this.id,
    required this.title,
    required this.pdfPath,
    required this.firstPreviewPath,
    this.lastPreviewPath,
    required this.isSigned,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['pdf_path'] = Variable<String>(pdfPath);
    map['first_preview_path'] = Variable<String>(firstPreviewPath);
    if (!nullToAbsent || lastPreviewPath != null) {
      map['last_preview_path'] = Variable<String>(lastPreviewPath);
    }
    map['is_signed'] = Variable<bool>(isSigned);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DocumentRecordsCompanion toCompanion(bool nullToAbsent) {
    return DocumentRecordsCompanion(
      id: Value(id),
      title: Value(title),
      pdfPath: Value(pdfPath),
      firstPreviewPath: Value(firstPreviewPath),
      lastPreviewPath: lastPreviewPath == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPreviewPath),
      isSigned: Value(isSigned),
      createdAt: Value(createdAt),
    );
  }

  factory DocumentRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentRecord(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      pdfPath: serializer.fromJson<String>(json['pdfPath']),
      firstPreviewPath: serializer.fromJson<String>(json['firstPreviewPath']),
      lastPreviewPath: serializer.fromJson<String?>(json['lastPreviewPath']),
      isSigned: serializer.fromJson<bool>(json['isSigned']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'pdfPath': serializer.toJson<String>(pdfPath),
      'firstPreviewPath': serializer.toJson<String>(firstPreviewPath),
      'lastPreviewPath': serializer.toJson<String?>(lastPreviewPath),
      'isSigned': serializer.toJson<bool>(isSigned),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DocumentRecord copyWith({
    int? id,
    String? title,
    String? pdfPath,
    String? firstPreviewPath,
    Value<String?> lastPreviewPath = const Value.absent(),
    bool? isSigned,
    DateTime? createdAt,
  }) => DocumentRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    pdfPath: pdfPath ?? this.pdfPath,
    firstPreviewPath: firstPreviewPath ?? this.firstPreviewPath,
    lastPreviewPath: lastPreviewPath.present
        ? lastPreviewPath.value
        : this.lastPreviewPath,
    isSigned: isSigned ?? this.isSigned,
    createdAt: createdAt ?? this.createdAt,
  );
  DocumentRecord copyWithCompanion(DocumentRecordsCompanion data) {
    return DocumentRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      pdfPath: data.pdfPath.present ? data.pdfPath.value : this.pdfPath,
      firstPreviewPath: data.firstPreviewPath.present
          ? data.firstPreviewPath.value
          : this.firstPreviewPath,
      lastPreviewPath: data.lastPreviewPath.present
          ? data.lastPreviewPath.value
          : this.lastPreviewPath,
      isSigned: data.isSigned.present ? data.isSigned.value : this.isSigned,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('firstPreviewPath: $firstPreviewPath, ')
          ..write('lastPreviewPath: $lastPreviewPath, ')
          ..write('isSigned: $isSigned, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    pdfPath,
    firstPreviewPath,
    lastPreviewPath,
    isSigned,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.pdfPath == this.pdfPath &&
          other.firstPreviewPath == this.firstPreviewPath &&
          other.lastPreviewPath == this.lastPreviewPath &&
          other.isSigned == this.isSigned &&
          other.createdAt == this.createdAt);
}

class DocumentRecordsCompanion extends UpdateCompanion<DocumentRecord> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> pdfPath;
  final Value<String> firstPreviewPath;
  final Value<String?> lastPreviewPath;
  final Value<bool> isSigned;
  final Value<DateTime> createdAt;
  const DocumentRecordsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.pdfPath = const Value.absent(),
    this.firstPreviewPath = const Value.absent(),
    this.lastPreviewPath = const Value.absent(),
    this.isSigned = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DocumentRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String pdfPath,
    required String firstPreviewPath,
    this.lastPreviewPath = const Value.absent(),
    this.isSigned = const Value.absent(),
    required DateTime createdAt,
  }) : title = Value(title),
       pdfPath = Value(pdfPath),
       firstPreviewPath = Value(firstPreviewPath),
       createdAt = Value(createdAt);
  static Insertable<DocumentRecord> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? pdfPath,
    Expression<String>? firstPreviewPath,
    Expression<String>? lastPreviewPath,
    Expression<bool>? isSigned,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (pdfPath != null) 'pdf_path': pdfPath,
      if (firstPreviewPath != null) 'first_preview_path': firstPreviewPath,
      if (lastPreviewPath != null) 'last_preview_path': lastPreviewPath,
      if (isSigned != null) 'is_signed': isSigned,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DocumentRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? pdfPath,
    Value<String>? firstPreviewPath,
    Value<String?>? lastPreviewPath,
    Value<bool>? isSigned,
    Value<DateTime>? createdAt,
  }) {
    return DocumentRecordsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      pdfPath: pdfPath ?? this.pdfPath,
      firstPreviewPath: firstPreviewPath ?? this.firstPreviewPath,
      lastPreviewPath: lastPreviewPath ?? this.lastPreviewPath,
      isSigned: isSigned ?? this.isSigned,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (pdfPath.present) {
      map['pdf_path'] = Variable<String>(pdfPath.value);
    }
    if (firstPreviewPath.present) {
      map['first_preview_path'] = Variable<String>(firstPreviewPath.value);
    }
    if (lastPreviewPath.present) {
      map['last_preview_path'] = Variable<String>(lastPreviewPath.value);
    }
    if (isSigned.present) {
      map['is_signed'] = Variable<bool>(isSigned.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('firstPreviewPath: $firstPreviewPath, ')
          ..write('lastPreviewPath: $lastPreviewPath, ')
          ..write('isSigned: $isSigned, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DocumentRecordsTable documentRecords = $DocumentRecordsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [documentRecords];
}

typedef $$DocumentRecordsTableCreateCompanionBuilder =
    DocumentRecordsCompanion Function({
      Value<int> id,
      required String title,
      required String pdfPath,
      required String firstPreviewPath,
      Value<String?> lastPreviewPath,
      Value<bool> isSigned,
      required DateTime createdAt,
    });
typedef $$DocumentRecordsTableUpdateCompanionBuilder =
    DocumentRecordsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> pdfPath,
      Value<String> firstPreviewPath,
      Value<String?> lastPreviewPath,
      Value<bool> isSigned,
      Value<DateTime> createdAt,
    });

class $$DocumentRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentRecordsTable> {
  $$DocumentRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfPath => $composableBuilder(
    column: $table.pdfPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstPreviewPath => $composableBuilder(
    column: $table.firstPreviewPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastPreviewPath => $composableBuilder(
    column: $table.lastPreviewPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSigned => $composableBuilder(
    column: $table.isSigned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentRecordsTable> {
  $$DocumentRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfPath => $composableBuilder(
    column: $table.pdfPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstPreviewPath => $composableBuilder(
    column: $table.firstPreviewPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastPreviewPath => $composableBuilder(
    column: $table.lastPreviewPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSigned => $composableBuilder(
    column: $table.isSigned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentRecordsTable> {
  $$DocumentRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get pdfPath =>
      $composableBuilder(column: $table.pdfPath, builder: (column) => column);

  GeneratedColumn<String> get firstPreviewPath => $composableBuilder(
    column: $table.firstPreviewPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastPreviewPath => $composableBuilder(
    column: $table.lastPreviewPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSigned =>
      $composableBuilder(column: $table.isSigned, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DocumentRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentRecordsTable,
          DocumentRecord,
          $$DocumentRecordsTableFilterComposer,
          $$DocumentRecordsTableOrderingComposer,
          $$DocumentRecordsTableAnnotationComposer,
          $$DocumentRecordsTableCreateCompanionBuilder,
          $$DocumentRecordsTableUpdateCompanionBuilder,
          (
            DocumentRecord,
            BaseReferences<
              _$AppDatabase,
              $DocumentRecordsTable,
              DocumentRecord
            >,
          ),
          DocumentRecord,
          PrefetchHooks Function()
        > {
  $$DocumentRecordsTableTableManager(
    _$AppDatabase db,
    $DocumentRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> pdfPath = const Value.absent(),
                Value<String> firstPreviewPath = const Value.absent(),
                Value<String?> lastPreviewPath = const Value.absent(),
                Value<bool> isSigned = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DocumentRecordsCompanion(
                id: id,
                title: title,
                pdfPath: pdfPath,
                firstPreviewPath: firstPreviewPath,
                lastPreviewPath: lastPreviewPath,
                isSigned: isSigned,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String pdfPath,
                required String firstPreviewPath,
                Value<String?> lastPreviewPath = const Value.absent(),
                Value<bool> isSigned = const Value.absent(),
                required DateTime createdAt,
              }) => DocumentRecordsCompanion.insert(
                id: id,
                title: title,
                pdfPath: pdfPath,
                firstPreviewPath: firstPreviewPath,
                lastPreviewPath: lastPreviewPath,
                isSigned: isSigned,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentRecordsTable,
      DocumentRecord,
      $$DocumentRecordsTableFilterComposer,
      $$DocumentRecordsTableOrderingComposer,
      $$DocumentRecordsTableAnnotationComposer,
      $$DocumentRecordsTableCreateCompanionBuilder,
      $$DocumentRecordsTableUpdateCompanionBuilder,
      (
        DocumentRecord,
        BaseReferences<_$AppDatabase, $DocumentRecordsTable, DocumentRecord>,
      ),
      DocumentRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DocumentRecordsTableTableManager get documentRecords =>
      $$DocumentRecordsTableTableManager(_db, _db.documentRecords);
}
