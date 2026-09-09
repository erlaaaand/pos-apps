// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $IngredientCategoriesTable extends IngredientCategories
    with TableInfo<$IngredientCategoriesTable, IngredientCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientCategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {name},
  ];
  @override
  IngredientCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $IngredientCategoriesTable createAlias(String alias) {
    return $IngredientCategoriesTable(attachedDatabase, alias);
  }
}

class IngredientCategory extends DataClass
    implements Insertable<IngredientCategory> {
  final int id;
  final String name;
  final DateTime createdAt;
  const IngredientCategory({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IngredientCategoriesCompanion toCompanion(bool nullToAbsent) {
    return IngredientCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory IngredientCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  IngredientCategory copyWith({int? id, String? name, DateTime? createdAt}) =>
      IngredientCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  IngredientCategory copyWithCompanion(IngredientCategoriesCompanion data) {
    return IngredientCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class IngredientCategoriesCompanion
    extends UpdateCompanion<IngredientCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const IngredientCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  IngredientCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<IngredientCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  IngredientCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return IngredientCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IngredientUnit, int> unit =
      GeneratedColumn<int>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<IngredientUnit>($IngredientsTable.$converterunit);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredient_categories (id)',
    ),
  );
  static const VerificationMeta _currentStockMeta = const VerificationMeta(
    'currentStock',
  );
  @override
  late final GeneratedColumn<double> currentStock = GeneratedColumn<double>(
    'current_stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentCostPerUnitMeta =
      const VerificationMeta('currentCostPerUnit');
  @override
  late final GeneratedColumn<double> currentCostPerUnit =
      GeneratedColumn<double>(
        'current_cost_per_unit',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    unit,
    categoryId,
    currentStock,
    currentCostPerUnit,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ingredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('current_stock')) {
      context.handle(
        _currentStockMeta,
        currentStock.isAcceptableOrUnknown(
          data['current_stock']!,
          _currentStockMeta,
        ),
      );
    }
    if (data.containsKey('current_cost_per_unit')) {
      context.handle(
        _currentCostPerUnitMeta,
        currentCostPerUnit.isAcceptableOrUnknown(
          data['current_cost_per_unit']!,
          _currentCostPerUnitMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {name},
  ];
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: $IngredientsTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}unit'],
        )!,
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      currentStock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_stock'],
      )!,
      currentCostPerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_cost_per_unit'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<IngredientUnit, int, int> $converterunit =
      const EnumIndexConverter<IngredientUnit>(IngredientUnit.values);
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final int id;
  final String name;
  final IngredientUnit unit;

  /// Pengelompokan opsional (update.md). Nullable karena bahan lama belum
  /// punya kategori dan pemilik boleh membiarkannya kosong.
  final int? categoryId;

  /// Quantity on hand, in [unit].
  final double currentStock;

  /// Weighted-average cost per [unit], in whole Rupiah. Stored as a double
  /// because it is a *ratio* (total Rupiah spent / quantity bought) and is
  /// only ever an intermediate figure for computing recipe HPP — every
  /// actually-recorded money amount derived from it (a purchase total, a
  /// sale's HPP snapshot) is rounded to a whole-Rupiah [int] at the point it
  /// becomes a real transaction. See ADR note in `PurchaseRepository`.
  final double currentCostPerUnit;
  final DateTime createdAt;
  const Ingredient({
    required this.id,
    required this.name,
    required this.unit,
    this.categoryId,
    required this.currentStock,
    required this.currentCostPerUnit,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['unit'] = Variable<int>($IngredientsTable.$converterunit.toSql(unit));
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['current_stock'] = Variable<double>(currentStock);
    map['current_cost_per_unit'] = Variable<double>(currentCostPerUnit);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      unit: Value(unit),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      currentStock: Value(currentStock),
      currentCostPerUnit: Value(currentCostPerUnit),
      createdAt: Value(createdAt),
    );
  }

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      unit: $IngredientsTable.$converterunit.fromJson(
        serializer.fromJson<int>(json['unit']),
      ),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      currentStock: serializer.fromJson<double>(json['currentStock']),
      currentCostPerUnit: serializer.fromJson<double>(
        json['currentCostPerUnit'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<int>(
        $IngredientsTable.$converterunit.toJson(unit),
      ),
      'categoryId': serializer.toJson<int?>(categoryId),
      'currentStock': serializer.toJson<double>(currentStock),
      'currentCostPerUnit': serializer.toJson<double>(currentCostPerUnit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Ingredient copyWith({
    int? id,
    String? name,
    IngredientUnit? unit,
    Value<int?> categoryId = const Value.absent(),
    double? currentStock,
    double? currentCostPerUnit,
    DateTime? createdAt,
  }) => Ingredient(
    id: id ?? this.id,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    currentStock: currentStock ?? this.currentStock,
    currentCostPerUnit: currentCostPerUnit ?? this.currentCostPerUnit,
    createdAt: createdAt ?? this.createdAt,
  );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      currentCostPerUnit: data.currentCostPerUnit.present
          ? data.currentCostPerUnit.value
          : this.currentCostPerUnit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('categoryId: $categoryId, ')
          ..write('currentStock: $currentStock, ')
          ..write('currentCostPerUnit: $currentCostPerUnit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    unit,
    categoryId,
    currentStock,
    currentCostPerUnit,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.categoryId == this.categoryId &&
          other.currentStock == this.currentStock &&
          other.currentCostPerUnit == this.currentCostPerUnit &&
          other.createdAt == this.createdAt);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<int> id;
  final Value<String> name;
  final Value<IngredientUnit> unit;
  final Value<int?> categoryId;
  final Value<double> currentStock;
  final Value<double> currentCostPerUnit;
  final Value<DateTime> createdAt;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.currentCostPerUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required IngredientUnit unit,
    this.categoryId = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.currentCostPerUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       unit = Value(unit);
  static Insertable<Ingredient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? unit,
    Expression<int>? categoryId,
    Expression<double>? currentStock,
    Expression<double>? currentCostPerUnit,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (categoryId != null) 'category_id': categoryId,
      if (currentStock != null) 'current_stock': currentStock,
      if (currentCostPerUnit != null)
        'current_cost_per_unit': currentCostPerUnit,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  IngredientsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<IngredientUnit>? unit,
    Value<int?>? categoryId,
    Value<double>? currentStock,
    Value<double>? currentCostPerUnit,
    Value<DateTime>? createdAt,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      categoryId: categoryId ?? this.categoryId,
      currentStock: currentStock ?? this.currentStock,
      currentCostPerUnit: currentCostPerUnit ?? this.currentCostPerUnit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<int>(
        $IngredientsTable.$converterunit.toSql(unit.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<double>(currentStock.value);
    }
    if (currentCostPerUnit.present) {
      map['current_cost_per_unit'] = Variable<double>(currentCostPerUnit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('categoryId: $categoryId, ')
          ..write('currentStock: $currentStock, ')
          ..write('currentCostPerUnit: $currentCostPerUnit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseBatchesTable extends PurchaseBatches
    with TableInfo<$PurchaseBatchesTable, PurchaseBatch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseBatchesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalPriceRupiahMeta = const VerificationMeta(
    'totalPriceRupiah',
  );
  @override
  late final GeneratedColumn<int> totalPriceRupiah = GeneratedColumn<int>(
    'total_price_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchasedAt,
    storeName,
    totalPriceRupiah,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseBatch> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    }
    if (data.containsKey('total_price_rupiah')) {
      context.handle(
        _totalPriceRupiahMeta,
        totalPriceRupiah.isAcceptableOrUnknown(
          data['total_price_rupiah']!,
          _totalPriceRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalPriceRupiahMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseBatch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseBatch(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      ),
      totalPriceRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_price_rupiah'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PurchaseBatchesTable createAlias(String alias) {
    return $PurchaseBatchesTable(attachedDatabase, alias);
  }
}

class PurchaseBatch extends DataClass implements Insertable<PurchaseBatch> {
  final int id;

  /// Tanggal belanja, diisi pemilik (boleh mundur, tidak dipaksa hari ini).
  final DateTime purchasedAt;
  final String? storeName;

  /// Total yang benar-benar dibayar untuk seluruh isi batch, dalam Rupiah
  /// bulat. Jumlah alokasi semua baris pembelian di batch ini harus persis
  /// sama dengan angka ini.
  final int totalPriceRupiah;
  final String? note;
  final DateTime createdAt;
  const PurchaseBatch({
    required this.id,
    required this.purchasedAt,
    this.storeName,
    required this.totalPriceRupiah,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    if (!nullToAbsent || storeName != null) {
      map['store_name'] = Variable<String>(storeName);
    }
    map['total_price_rupiah'] = Variable<int>(totalPriceRupiah);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchaseBatchesCompanion toCompanion(bool nullToAbsent) {
    return PurchaseBatchesCompanion(
      id: Value(id),
      purchasedAt: Value(purchasedAt),
      storeName: storeName == null && nullToAbsent
          ? const Value.absent()
          : Value(storeName),
      totalPriceRupiah: Value(totalPriceRupiah),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory PurchaseBatch.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseBatch(
      id: serializer.fromJson<int>(json['id']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
      storeName: serializer.fromJson<String?>(json['storeName']),
      totalPriceRupiah: serializer.fromJson<int>(json['totalPriceRupiah']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
      'storeName': serializer.toJson<String?>(storeName),
      'totalPriceRupiah': serializer.toJson<int>(totalPriceRupiah),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PurchaseBatch copyWith({
    int? id,
    DateTime? purchasedAt,
    Value<String?> storeName = const Value.absent(),
    int? totalPriceRupiah,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => PurchaseBatch(
    id: id ?? this.id,
    purchasedAt: purchasedAt ?? this.purchasedAt,
    storeName: storeName.present ? storeName.value : this.storeName,
    totalPriceRupiah: totalPriceRupiah ?? this.totalPriceRupiah,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  PurchaseBatch copyWithCompanion(PurchaseBatchesCompanion data) {
    return PurchaseBatch(
      id: data.id.present ? data.id.value : this.id,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      totalPriceRupiah: data.totalPriceRupiah.present
          ? data.totalPriceRupiah.value
          : this.totalPriceRupiah,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseBatch(')
          ..write('id: $id, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('storeName: $storeName, ')
          ..write('totalPriceRupiah: $totalPriceRupiah, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchasedAt,
    storeName,
    totalPriceRupiah,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseBatch &&
          other.id == this.id &&
          other.purchasedAt == this.purchasedAt &&
          other.storeName == this.storeName &&
          other.totalPriceRupiah == this.totalPriceRupiah &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class PurchaseBatchesCompanion extends UpdateCompanion<PurchaseBatch> {
  final Value<int> id;
  final Value<DateTime> purchasedAt;
  final Value<String?> storeName;
  final Value<int> totalPriceRupiah;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const PurchaseBatchesCompanion({
    this.id = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.storeName = const Value.absent(),
    this.totalPriceRupiah = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PurchaseBatchesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime purchasedAt,
    this.storeName = const Value.absent(),
    required int totalPriceRupiah,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : purchasedAt = Value(purchasedAt),
       totalPriceRupiah = Value(totalPriceRupiah);
  static Insertable<PurchaseBatch> custom({
    Expression<int>? id,
    Expression<DateTime>? purchasedAt,
    Expression<String>? storeName,
    Expression<int>? totalPriceRupiah,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (storeName != null) 'store_name': storeName,
      if (totalPriceRupiah != null) 'total_price_rupiah': totalPriceRupiah,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PurchaseBatchesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? purchasedAt,
    Value<String?>? storeName,
    Value<int>? totalPriceRupiah,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return PurchaseBatchesCompanion(
      id: id ?? this.id,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      storeName: storeName ?? this.storeName,
      totalPriceRupiah: totalPriceRupiah ?? this.totalPriceRupiah,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (totalPriceRupiah.present) {
      map['total_price_rupiah'] = Variable<int>(totalPriceRupiah.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseBatchesCompanion(')
          ..write('id: $id, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('storeName: $storeName, ')
          ..write('totalPriceRupiah: $totalPriceRupiah, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $IngredientPurchasesTable extends IngredientPurchases
    with TableInfo<$IngredientPurchasesTable, IngredientPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientPurchasesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<int> batchId = GeneratedColumn<int>(
    'batch_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase_batches (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPriceRupiahMeta = const VerificationMeta(
    'totalPriceRupiah',
  );
  @override
  late final GeneratedColumn<int> totalPriceRupiah = GeneratedColumn<int>(
    'total_price_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ingredientId,
    batchId,
    quantity,
    totalPriceRupiah,
    storeName,
    purchasedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientPurchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('total_price_rupiah')) {
      context.handle(
        _totalPriceRupiahMeta,
        totalPriceRupiah.isAcceptableOrUnknown(
          data['total_price_rupiah']!,
          _totalPriceRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalPriceRupiahMeta);
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientPurchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      totalPriceRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_price_rupiah'],
      )!,
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      ),
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $IngredientPurchasesTable createAlias(String alias) {
    return $IngredientPurchasesTable(attachedDatabase, alias);
  }
}

class IngredientPurchase extends DataClass
    implements Insertable<IngredientPurchase> {
  final int id;
  final int ingredientId;

  /// Batch belanja induk kalau pembelian ini bagian dari satu transaksi
  /// borongan (A.2). Nullable: pembelian satuan lama tidak punya batch.
  final int? batchId;

  /// Quantity bought, in the ingredient's unit.
  final double quantity;

  /// Total price actually paid, in whole Rupiah. This — not qty × unit price
  /// — is the authoritative money figure used for the weighted-average
  /// recalculation, since it's what the owner actually entered. Untuk baris
  /// yang berasal dari batch borongan, ini adalah porsi biaya yang dialokasi
  /// ke bahan tersebut.
  final int totalPriceRupiah;
  final String? storeName;

  /// Date the purchase happened (as entered by the owner).
  final DateTime purchasedAt;
  final DateTime createdAt;
  const IngredientPurchase({
    required this.id,
    required this.ingredientId,
    this.batchId,
    required this.quantity,
    required this.totalPriceRupiah,
    this.storeName,
    required this.purchasedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ingredient_id'] = Variable<int>(ingredientId);
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<int>(batchId);
    }
    map['quantity'] = Variable<double>(quantity);
    map['total_price_rupiah'] = Variable<int>(totalPriceRupiah);
    if (!nullToAbsent || storeName != null) {
      map['store_name'] = Variable<String>(storeName);
    }
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IngredientPurchasesCompanion toCompanion(bool nullToAbsent) {
    return IngredientPurchasesCompanion(
      id: Value(id),
      ingredientId: Value(ingredientId),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      quantity: Value(quantity),
      totalPriceRupiah: Value(totalPriceRupiah),
      storeName: storeName == null && nullToAbsent
          ? const Value.absent()
          : Value(storeName),
      purchasedAt: Value(purchasedAt),
      createdAt: Value(createdAt),
    );
  }

  factory IngredientPurchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientPurchase(
      id: serializer.fromJson<int>(json['id']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      batchId: serializer.fromJson<int?>(json['batchId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      totalPriceRupiah: serializer.fromJson<int>(json['totalPriceRupiah']),
      storeName: serializer.fromJson<String?>(json['storeName']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'batchId': serializer.toJson<int?>(batchId),
      'quantity': serializer.toJson<double>(quantity),
      'totalPriceRupiah': serializer.toJson<int>(totalPriceRupiah),
      'storeName': serializer.toJson<String?>(storeName),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  IngredientPurchase copyWith({
    int? id,
    int? ingredientId,
    Value<int?> batchId = const Value.absent(),
    double? quantity,
    int? totalPriceRupiah,
    Value<String?> storeName = const Value.absent(),
    DateTime? purchasedAt,
    DateTime? createdAt,
  }) => IngredientPurchase(
    id: id ?? this.id,
    ingredientId: ingredientId ?? this.ingredientId,
    batchId: batchId.present ? batchId.value : this.batchId,
    quantity: quantity ?? this.quantity,
    totalPriceRupiah: totalPriceRupiah ?? this.totalPriceRupiah,
    storeName: storeName.present ? storeName.value : this.storeName,
    purchasedAt: purchasedAt ?? this.purchasedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  IngredientPurchase copyWithCompanion(IngredientPurchasesCompanion data) {
    return IngredientPurchase(
      id: data.id.present ? data.id.value : this.id,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      totalPriceRupiah: data.totalPriceRupiah.present
          ? data.totalPriceRupiah.value
          : this.totalPriceRupiah,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientPurchase(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('batchId: $batchId, ')
          ..write('quantity: $quantity, ')
          ..write('totalPriceRupiah: $totalPriceRupiah, ')
          ..write('storeName: $storeName, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ingredientId,
    batchId,
    quantity,
    totalPriceRupiah,
    storeName,
    purchasedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientPurchase &&
          other.id == this.id &&
          other.ingredientId == this.ingredientId &&
          other.batchId == this.batchId &&
          other.quantity == this.quantity &&
          other.totalPriceRupiah == this.totalPriceRupiah &&
          other.storeName == this.storeName &&
          other.purchasedAt == this.purchasedAt &&
          other.createdAt == this.createdAt);
}

class IngredientPurchasesCompanion extends UpdateCompanion<IngredientPurchase> {
  final Value<int> id;
  final Value<int> ingredientId;
  final Value<int?> batchId;
  final Value<double> quantity;
  final Value<int> totalPriceRupiah;
  final Value<String?> storeName;
  final Value<DateTime> purchasedAt;
  final Value<DateTime> createdAt;
  const IngredientPurchasesCompanion({
    this.id = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.totalPriceRupiah = const Value.absent(),
    this.storeName = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  IngredientPurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int ingredientId,
    this.batchId = const Value.absent(),
    required double quantity,
    required int totalPriceRupiah,
    this.storeName = const Value.absent(),
    required DateTime purchasedAt,
    this.createdAt = const Value.absent(),
  }) : ingredientId = Value(ingredientId),
       quantity = Value(quantity),
       totalPriceRupiah = Value(totalPriceRupiah),
       purchasedAt = Value(purchasedAt);
  static Insertable<IngredientPurchase> custom({
    Expression<int>? id,
    Expression<int>? ingredientId,
    Expression<int>? batchId,
    Expression<double>? quantity,
    Expression<int>? totalPriceRupiah,
    Expression<String>? storeName,
    Expression<DateTime>? purchasedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (batchId != null) 'batch_id': batchId,
      if (quantity != null) 'quantity': quantity,
      if (totalPriceRupiah != null) 'total_price_rupiah': totalPriceRupiah,
      if (storeName != null) 'store_name': storeName,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  IngredientPurchasesCompanion copyWith({
    Value<int>? id,
    Value<int>? ingredientId,
    Value<int?>? batchId,
    Value<double>? quantity,
    Value<int>? totalPriceRupiah,
    Value<String?>? storeName,
    Value<DateTime>? purchasedAt,
    Value<DateTime>? createdAt,
  }) {
    return IngredientPurchasesCompanion(
      id: id ?? this.id,
      ingredientId: ingredientId ?? this.ingredientId,
      batchId: batchId ?? this.batchId,
      quantity: quantity ?? this.quantity,
      totalPriceRupiah: totalPriceRupiah ?? this.totalPriceRupiah,
      storeName: storeName ?? this.storeName,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<int>(batchId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (totalPriceRupiah.present) {
      map['total_price_rupiah'] = Variable<int>(totalPriceRupiah.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('batchId: $batchId, ')
          ..write('quantity: $quantity, ')
          ..write('totalPriceRupiah: $totalPriceRupiah, ')
          ..write('storeName: $storeName, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {name},
  ];
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;

  /// Only active products are selectable for new orders (B.2). Default true
  /// per erp.md A.3 ("default Aktif untuk produk baru").
  final bool isActive;
  final DateTime createdAt;
  const Product({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    bool? isActive,
    DateTime? createdAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _sellingPriceRupiahMeta =
      const VerificationMeta('sellingPriceRupiah');
  @override
  late final GeneratedColumn<int> sellingPriceRupiah = GeneratedColumn<int>(
    'selling_price_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    sellingPriceRupiah,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('selling_price_rupiah')) {
      context.handle(
        _sellingPriceRupiahMeta,
        sellingPriceRupiah.isAcceptableOrUnknown(
          data['selling_price_rupiah']!,
          _sellingPriceRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceRupiahMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      sellingPriceRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price_rupiah'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final int id;
  final int productId;

  /// Selling price at the time this recipe version was created, in whole
  /// Rupiah. Copied onto each [Orders] row at order time so a later recipe
  /// revision never retroactively changes an already-placed order's price.
  final int sellingPriceRupiah;

  /// At most one recipe per product should be active at a time — enforced
  /// by `RecipeRepository.addRecipe`, not by a DB constraint (SQLite can't
  /// express "unique where isActive" portably without a partial index).
  final bool isActive;
  final DateTime createdAt;
  const Recipe({
    required this.id,
    required this.productId,
    required this.sellingPriceRupiah,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['selling_price_rupiah'] = Variable<int>(sellingPriceRupiah);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      productId: Value(productId),
      sellingPriceRupiah: Value(sellingPriceRupiah),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      sellingPriceRupiah: serializer.fromJson<int>(json['sellingPriceRupiah']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'sellingPriceRupiah': serializer.toJson<int>(sellingPriceRupiah),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Recipe copyWith({
    int? id,
    int? productId,
    int? sellingPriceRupiah,
    bool? isActive,
    DateTime? createdAt,
  }) => Recipe(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    sellingPriceRupiah: sellingPriceRupiah ?? this.sellingPriceRupiah,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      sellingPriceRupiah: data.sellingPriceRupiah.present
          ? data.sellingPriceRupiah.value
          : this.sellingPriceRupiah,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('sellingPriceRupiah: $sellingPriceRupiah, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, sellingPriceRupiah, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.sellingPriceRupiah == this.sellingPriceRupiah &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> sellingPriceRupiah;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.sellingPriceRupiah = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int sellingPriceRupiah,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : productId = Value(productId),
       sellingPriceRupiah = Value(sellingPriceRupiah);
  static Insertable<Recipe> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? sellingPriceRupiah,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (sellingPriceRupiah != null)
        'selling_price_rupiah': sellingPriceRupiah,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecipesCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int>? sellingPriceRupiah,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sellingPriceRupiah: sellingPriceRupiah ?? this.sellingPriceRupiah,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (sellingPriceRupiah.present) {
      map['selling_price_rupiah'] = Variable<int>(sellingPriceRupiah.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('sellingPriceRupiah: $sellingPriceRupiah, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecipeItemsTable extends RecipeItems
    with TableInfo<$RecipeItemsTable, RecipeItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _quantityPerBatchMeta = const VerificationMeta(
    'quantityPerBatch',
  );
  @override
  late final GeneratedColumn<double> quantityPerBatch = GeneratedColumn<double>(
    'quantity_per_batch',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecipeItemKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<RecipeItemKind>($RecipeItemsTable.$converterkind);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    ingredientId,
    quantityPerBatch,
    kind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity_per_batch')) {
      context.handle(
        _quantityPerBatchMeta,
        quantityPerBatch.isAcceptableOrUnknown(
          data['quantity_per_batch']!,
          _quantityPerBatchMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityPerBatchMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_id'],
      )!,
      quantityPerBatch: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_per_batch'],
      )!,
      kind: $RecipeItemsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
    );
  }

  @override
  $RecipeItemsTable createAlias(String alias) {
    return $RecipeItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecipeItemKind, int, int> $converterkind =
      const EnumIndexConverter<RecipeItemKind>(RecipeItemKind.values);
}

class RecipeItem extends DataClass implements Insertable<RecipeItem> {
  final int id;
  final int recipeId;
  final int ingredientId;

  /// Quantity required per production batch, in the ingredient's unit.
  final double quantityPerBatch;

  /// Bahan baku atau kemasan. Default `ingredient` supaya resep yang dibuat
  /// sebelum pemisahan ini tetap valid tanpa perlu ditebak ulang.
  final RecipeItemKind kind;
  const RecipeItem({
    required this.id,
    required this.recipeId,
    required this.ingredientId,
    required this.quantityPerBatch,
    required this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['quantity_per_batch'] = Variable<double>(quantityPerBatch);
    {
      map['kind'] = Variable<int>($RecipeItemsTable.$converterkind.toSql(kind));
    }
    return map;
  }

  RecipeItemsCompanion toCompanion(bool nullToAbsent) {
    return RecipeItemsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      ingredientId: Value(ingredientId),
      quantityPerBatch: Value(quantityPerBatch),
      kind: Value(kind),
    );
  }

  factory RecipeItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeItem(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      quantityPerBatch: serializer.fromJson<double>(json['quantityPerBatch']),
      kind: $RecipeItemsTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'quantityPerBatch': serializer.toJson<double>(quantityPerBatch),
      'kind': serializer.toJson<int>(
        $RecipeItemsTable.$converterkind.toJson(kind),
      ),
    };
  }

  RecipeItem copyWith({
    int? id,
    int? recipeId,
    int? ingredientId,
    double? quantityPerBatch,
    RecipeItemKind? kind,
  }) => RecipeItem(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    ingredientId: ingredientId ?? this.ingredientId,
    quantityPerBatch: quantityPerBatch ?? this.quantityPerBatch,
    kind: kind ?? this.kind,
  );
  RecipeItem copyWithCompanion(RecipeItemsCompanion data) {
    return RecipeItem(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantityPerBatch: data.quantityPerBatch.present
          ? data.quantityPerBatch.value
          : this.quantityPerBatch,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItem(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityPerBatch: $quantityPerBatch, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, ingredientId, quantityPerBatch, kind);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeItem &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.ingredientId == this.ingredientId &&
          other.quantityPerBatch == this.quantityPerBatch &&
          other.kind == this.kind);
}

class RecipeItemsCompanion extends UpdateCompanion<RecipeItem> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> ingredientId;
  final Value<double> quantityPerBatch;
  final Value<RecipeItemKind> kind;
  const RecipeItemsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantityPerBatch = const Value.absent(),
    this.kind = const Value.absent(),
  });
  RecipeItemsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int ingredientId,
    required double quantityPerBatch,
    this.kind = const Value.absent(),
  }) : recipeId = Value(recipeId),
       ingredientId = Value(ingredientId),
       quantityPerBatch = Value(quantityPerBatch);
  static Insertable<RecipeItem> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? ingredientId,
    Expression<double>? quantityPerBatch,
    Expression<int>? kind,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantityPerBatch != null) 'quantity_per_batch': quantityPerBatch,
      if (kind != null) 'kind': kind,
    });
  }

  RecipeItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int>? ingredientId,
    Value<double>? quantityPerBatch,
    Value<RecipeItemKind>? kind,
  }) {
    return RecipeItemsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantityPerBatch: quantityPerBatch ?? this.quantityPerBatch,
      kind: kind ?? this.kind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (quantityPerBatch.present) {
      map['quantity_per_batch'] = Variable<double>(quantityPerBatch.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(
        $RecipeItemsTable.$converterkind.toSql(kind.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItemsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityPerBatch: $quantityPerBatch, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }
}

class $PurchaseOrdersTable extends PurchaseOrders
    with TableInfo<$PurchaseOrdersTable, PurchaseOrderBatch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseOrdersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PoStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<PoStatus>($PurchaseOrdersTable.$converterstatus);
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookedAtMeta = const VerificationMeta(
    'cookedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cookedAt = GeneratedColumn<DateTime>(
    'cooked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    status,
    openedAt,
    closedAt,
    cookedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseOrderBatch> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('cooked_at')) {
      context.handle(
        _cookedAtMeta,
        cookedAt.isAcceptableOrUnknown(data['cooked_at']!, _cookedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseOrderBatch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseOrderBatch(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      status: $PurchaseOrdersTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      ),
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
      cookedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cooked_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PurchaseOrdersTable createAlias(String alias) {
    return $PurchaseOrdersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PoStatus, int, int> $converterstatus =
      const EnumIndexConverter<PoStatus>(PoStatus.values);
}

class PurchaseOrderBatch extends DataClass
    implements Insertable<PurchaseOrderBatch> {
  final int id;
  final String label;
  final PoStatus status;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final DateTime? cookedAt;
  final DateTime createdAt;
  const PurchaseOrderBatch({
    required this.id,
    required this.label,
    required this.status,
    this.openedAt,
    this.closedAt,
    this.cookedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    {
      map['status'] = Variable<int>(
        $PurchaseOrdersTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || openedAt != null) {
      map['opened_at'] = Variable<DateTime>(openedAt);
    }
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    if (!nullToAbsent || cookedAt != null) {
      map['cooked_at'] = Variable<DateTime>(cookedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchaseOrdersCompanion toCompanion(bool nullToAbsent) {
    return PurchaseOrdersCompanion(
      id: Value(id),
      label: Value(label),
      status: Value(status),
      openedAt: openedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      cookedAt: cookedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cookedAt),
      createdAt: Value(createdAt),
    );
  }

  factory PurchaseOrderBatch.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseOrderBatch(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      status: $PurchaseOrdersTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      openedAt: serializer.fromJson<DateTime?>(json['openedAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      cookedAt: serializer.fromJson<DateTime?>(json['cookedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'status': serializer.toJson<int>(
        $PurchaseOrdersTable.$converterstatus.toJson(status),
      ),
      'openedAt': serializer.toJson<DateTime?>(openedAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'cookedAt': serializer.toJson<DateTime?>(cookedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PurchaseOrderBatch copyWith({
    int? id,
    String? label,
    PoStatus? status,
    Value<DateTime?> openedAt = const Value.absent(),
    Value<DateTime?> closedAt = const Value.absent(),
    Value<DateTime?> cookedAt = const Value.absent(),
    DateTime? createdAt,
  }) => PurchaseOrderBatch(
    id: id ?? this.id,
    label: label ?? this.label,
    status: status ?? this.status,
    openedAt: openedAt.present ? openedAt.value : this.openedAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    cookedAt: cookedAt.present ? cookedAt.value : this.cookedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  PurchaseOrderBatch copyWithCompanion(PurchaseOrdersCompanion data) {
    return PurchaseOrderBatch(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      status: data.status.present ? data.status.value : this.status,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      cookedAt: data.cookedAt.present ? data.cookedAt.value : this.cookedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrderBatch(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('cookedAt: $cookedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, status, openedAt, closedAt, cookedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseOrderBatch &&
          other.id == this.id &&
          other.label == this.label &&
          other.status == this.status &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt &&
          other.cookedAt == this.cookedAt &&
          other.createdAt == this.createdAt);
}

class PurchaseOrdersCompanion extends UpdateCompanion<PurchaseOrderBatch> {
  final Value<int> id;
  final Value<String> label;
  final Value<PoStatus> status;
  final Value<DateTime?> openedAt;
  final Value<DateTime?> closedAt;
  final Value<DateTime?> cookedAt;
  final Value<DateTime> createdAt;
  const PurchaseOrdersCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.cookedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PurchaseOrdersCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.cookedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : label = Value(label);
  static Insertable<PurchaseOrderBatch> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<int>? status,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? closedAt,
    Expression<DateTime>? cookedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (status != null) 'status': status,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (cookedAt != null) 'cooked_at': cookedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PurchaseOrdersCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<PoStatus>? status,
    Value<DateTime?>? openedAt,
    Value<DateTime?>? closedAt,
    Value<DateTime?>? cookedAt,
    Value<DateTime>? createdAt,
  }) {
    return PurchaseOrdersCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      status: status ?? this.status,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      cookedAt: cookedAt ?? this.cookedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $PurchaseOrdersTable.$converterstatus.toSql(status.value),
      );
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (cookedAt.present) {
      map['cooked_at'] = Variable<DateTime>(cookedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrdersCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('cookedAt: $cookedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PoProductQuotasTable extends PoProductQuotas
    with TableInfo<$PoProductQuotasTable, PoProductQuota> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PoProductQuotasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _purchaseOrderIdMeta = const VerificationMeta(
    'purchaseOrderId',
  );
  @override
  late final GeneratedColumn<int> purchaseOrderId = GeneratedColumn<int>(
    'purchase_order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase_orders (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quotaQuantityMeta = const VerificationMeta(
    'quotaQuantity',
  );
  @override
  late final GeneratedColumn<int> quotaQuantity = GeneratedColumn<int>(
    'quota_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseOrderId,
    productId,
    quotaQuantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'po_product_quotas';
  @override
  VerificationContext validateIntegrity(
    Insertable<PoProductQuota> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_order_id')) {
      context.handle(
        _purchaseOrderIdMeta,
        purchaseOrderId.isAcceptableOrUnknown(
          data['purchase_order_id']!,
          _purchaseOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseOrderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quota_quantity')) {
      context.handle(
        _quotaQuantityMeta,
        quotaQuantity.isAcceptableOrUnknown(
          data['quota_quantity']!,
          _quotaQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quotaQuantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {purchaseOrderId, productId},
  ];
  @override
  PoProductQuota map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PoProductQuota(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchaseOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      quotaQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quota_quantity'],
      )!,
    );
  }

  @override
  $PoProductQuotasTable createAlias(String alias) {
    return $PoProductQuotasTable(attachedDatabase, alias);
  }
}

class PoProductQuota extends DataClass implements Insertable<PoProductQuota> {
  final int id;
  final int purchaseOrderId;
  final int productId;
  final int quotaQuantity;
  const PoProductQuota({
    required this.id,
    required this.purchaseOrderId,
    required this.productId,
    required this.quotaQuantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_order_id'] = Variable<int>(purchaseOrderId);
    map['product_id'] = Variable<int>(productId);
    map['quota_quantity'] = Variable<int>(quotaQuantity);
    return map;
  }

  PoProductQuotasCompanion toCompanion(bool nullToAbsent) {
    return PoProductQuotasCompanion(
      id: Value(id),
      purchaseOrderId: Value(purchaseOrderId),
      productId: Value(productId),
      quotaQuantity: Value(quotaQuantity),
    );
  }

  factory PoProductQuota.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PoProductQuota(
      id: serializer.fromJson<int>(json['id']),
      purchaseOrderId: serializer.fromJson<int>(json['purchaseOrderId']),
      productId: serializer.fromJson<int>(json['productId']),
      quotaQuantity: serializer.fromJson<int>(json['quotaQuantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseOrderId': serializer.toJson<int>(purchaseOrderId),
      'productId': serializer.toJson<int>(productId),
      'quotaQuantity': serializer.toJson<int>(quotaQuantity),
    };
  }

  PoProductQuota copyWith({
    int? id,
    int? purchaseOrderId,
    int? productId,
    int? quotaQuantity,
  }) => PoProductQuota(
    id: id ?? this.id,
    purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
    productId: productId ?? this.productId,
    quotaQuantity: quotaQuantity ?? this.quotaQuantity,
  );
  PoProductQuota copyWithCompanion(PoProductQuotasCompanion data) {
    return PoProductQuota(
      id: data.id.present ? data.id.value : this.id,
      purchaseOrderId: data.purchaseOrderId.present
          ? data.purchaseOrderId.value
          : this.purchaseOrderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quotaQuantity: data.quotaQuantity.present
          ? data.quotaQuantity.value
          : this.quotaQuantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PoProductQuota(')
          ..write('id: $id, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('productId: $productId, ')
          ..write('quotaQuantity: $quotaQuantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purchaseOrderId, productId, quotaQuantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoProductQuota &&
          other.id == this.id &&
          other.purchaseOrderId == this.purchaseOrderId &&
          other.productId == this.productId &&
          other.quotaQuantity == this.quotaQuantity);
}

class PoProductQuotasCompanion extends UpdateCompanion<PoProductQuota> {
  final Value<int> id;
  final Value<int> purchaseOrderId;
  final Value<int> productId;
  final Value<int> quotaQuantity;
  const PoProductQuotasCompanion({
    this.id = const Value.absent(),
    this.purchaseOrderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quotaQuantity = const Value.absent(),
  });
  PoProductQuotasCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseOrderId,
    required int productId,
    required int quotaQuantity,
  }) : purchaseOrderId = Value(purchaseOrderId),
       productId = Value(productId),
       quotaQuantity = Value(quotaQuantity);
  static Insertable<PoProductQuota> custom({
    Expression<int>? id,
    Expression<int>? purchaseOrderId,
    Expression<int>? productId,
    Expression<int>? quotaQuantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseOrderId != null) 'purchase_order_id': purchaseOrderId,
      if (productId != null) 'product_id': productId,
      if (quotaQuantity != null) 'quota_quantity': quotaQuantity,
    });
  }

  PoProductQuotasCompanion copyWith({
    Value<int>? id,
    Value<int>? purchaseOrderId,
    Value<int>? productId,
    Value<int>? quotaQuantity,
  }) {
    return PoProductQuotasCompanion(
      id: id ?? this.id,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      productId: productId ?? this.productId,
      quotaQuantity: quotaQuantity ?? this.quotaQuantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseOrderId.present) {
      map['purchase_order_id'] = Variable<int>(purchaseOrderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quotaQuantity.present) {
      map['quota_quantity'] = Variable<int>(quotaQuantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PoProductQuotasCompanion(')
          ..write('id: $id, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('productId: $productId, ')
          ..write('quotaQuantity: $quotaQuantity')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, CustomerOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _purchaseOrderIdMeta = const VerificationMeta(
    'purchaseOrderId',
  );
  @override
  late final GeneratedColumn<int> purchaseOrderId = GeneratedColumn<int>(
    'purchase_order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase_orders (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _buyerContactMeta = const VerificationMeta(
    'buyerContact',
  );
  @override
  late final GeneratedColumn<String> buyerContact = GeneratedColumn<String>(
    'buyer_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceRupiahMeta = const VerificationMeta(
    'unitPriceRupiah',
  );
  @override
  late final GeneratedColumn<int> unitPriceRupiah = GeneratedColumn<int>(
    'unit_price_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OrderStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<OrderStatus>($OrdersTable.$converterstatus);
  static const VerificationMeta _cancellationReasonMeta =
      const VerificationMeta('cancellationReason');
  @override
  late final GeneratedColumn<String> cancellationReason =
      GeneratedColumn<String>(
        'cancellation_reason',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _hppSnapshotRupiahMeta = const VerificationMeta(
    'hppSnapshotRupiah',
  );
  @override
  late final GeneratedColumn<int> hppSnapshotRupiah = GeneratedColumn<int>(
    'hpp_snapshot_rupiah',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderedAtMeta = const VerificationMeta(
    'orderedAt',
  );
  @override
  late final GeneratedColumn<DateTime> orderedAt = GeneratedColumn<DateTime>(
    'ordered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseOrderId,
    productId,
    recipeId,
    quantity,
    buyerContact,
    note,
    unitPriceRupiah,
    status,
    cancellationReason,
    hppSnapshotRupiah,
    orderedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_order_id')) {
      context.handle(
        _purchaseOrderIdMeta,
        purchaseOrderId.isAcceptableOrUnknown(
          data['purchase_order_id']!,
          _purchaseOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseOrderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('buyer_contact')) {
      context.handle(
        _buyerContactMeta,
        buyerContact.isAcceptableOrUnknown(
          data['buyer_contact']!,
          _buyerContactMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('unit_price_rupiah')) {
      context.handle(
        _unitPriceRupiahMeta,
        unitPriceRupiah.isAcceptableOrUnknown(
          data['unit_price_rupiah']!,
          _unitPriceRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceRupiahMeta);
    }
    if (data.containsKey('cancellation_reason')) {
      context.handle(
        _cancellationReasonMeta,
        cancellationReason.isAcceptableOrUnknown(
          data['cancellation_reason']!,
          _cancellationReasonMeta,
        ),
      );
    }
    if (data.containsKey('hpp_snapshot_rupiah')) {
      context.handle(
        _hppSnapshotRupiahMeta,
        hppSnapshotRupiah.isAcceptableOrUnknown(
          data['hpp_snapshot_rupiah']!,
          _hppSnapshotRupiahMeta,
        ),
      );
    }
    if (data.containsKey('ordered_at')) {
      context.handle(
        _orderedAtMeta,
        orderedAt.isAcceptableOrUnknown(data['ordered_at']!, _orderedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchaseOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      buyerContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}buyer_contact'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      unitPriceRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_rupiah'],
      )!,
      status: $OrdersTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      cancellationReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancellation_reason'],
      ),
      hppSnapshotRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hpp_snapshot_rupiah'],
      ),
      orderedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ordered_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrderStatus, int, int> $converterstatus =
      const EnumIndexConverter<OrderStatus>(OrderStatus.values);
}

class CustomerOrder extends DataClass implements Insertable<CustomerOrder> {
  final int id;
  final int purchaseOrderId;
  final int productId;

  /// The exact recipe version active when this order was placed — fixes the
  /// BOM used for realized-ingredient calculation regardless of later recipe
  /// changes.
  final int recipeId;
  final int quantity;
  final String? buyerContact;
  final String? note;

  /// Snapshot of the recipe's selling price at order time, in whole Rupiah —
  /// so a later recipe price change never retroactively edits this order.
  final int unitPriceRupiah;
  final OrderStatus status;
  final String? cancellationReason;

  /// HPP for this order, snapshotted at production-confirmation time (B.3),
  /// using ingredient costs as of that moment — never recomputed later, so
  /// past P&L reports stay stable when ingredient costs move.
  final int? hppSnapshotRupiah;

  /// Needed for FIFO ordering when a PO must be partially cooked (B.3).
  final DateTime orderedAt;
  final DateTime? completedAt;
  const CustomerOrder({
    required this.id,
    required this.purchaseOrderId,
    required this.productId,
    required this.recipeId,
    required this.quantity,
    this.buyerContact,
    this.note,
    required this.unitPriceRupiah,
    required this.status,
    this.cancellationReason,
    this.hppSnapshotRupiah,
    required this.orderedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_order_id'] = Variable<int>(purchaseOrderId);
    map['product_id'] = Variable<int>(productId);
    map['recipe_id'] = Variable<int>(recipeId);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || buyerContact != null) {
      map['buyer_contact'] = Variable<String>(buyerContact);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['unit_price_rupiah'] = Variable<int>(unitPriceRupiah);
    {
      map['status'] = Variable<int>(
        $OrdersTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || cancellationReason != null) {
      map['cancellation_reason'] = Variable<String>(cancellationReason);
    }
    if (!nullToAbsent || hppSnapshotRupiah != null) {
      map['hpp_snapshot_rupiah'] = Variable<int>(hppSnapshotRupiah);
    }
    map['ordered_at'] = Variable<DateTime>(orderedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      purchaseOrderId: Value(purchaseOrderId),
      productId: Value(productId),
      recipeId: Value(recipeId),
      quantity: Value(quantity),
      buyerContact: buyerContact == null && nullToAbsent
          ? const Value.absent()
          : Value(buyerContact),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      unitPriceRupiah: Value(unitPriceRupiah),
      status: Value(status),
      cancellationReason: cancellationReason == null && nullToAbsent
          ? const Value.absent()
          : Value(cancellationReason),
      hppSnapshotRupiah: hppSnapshotRupiah == null && nullToAbsent
          ? const Value.absent()
          : Value(hppSnapshotRupiah),
      orderedAt: Value(orderedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory CustomerOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerOrder(
      id: serializer.fromJson<int>(json['id']),
      purchaseOrderId: serializer.fromJson<int>(json['purchaseOrderId']),
      productId: serializer.fromJson<int>(json['productId']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      buyerContact: serializer.fromJson<String?>(json['buyerContact']),
      note: serializer.fromJson<String?>(json['note']),
      unitPriceRupiah: serializer.fromJson<int>(json['unitPriceRupiah']),
      status: $OrdersTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      cancellationReason: serializer.fromJson<String?>(
        json['cancellationReason'],
      ),
      hppSnapshotRupiah: serializer.fromJson<int?>(json['hppSnapshotRupiah']),
      orderedAt: serializer.fromJson<DateTime>(json['orderedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseOrderId': serializer.toJson<int>(purchaseOrderId),
      'productId': serializer.toJson<int>(productId),
      'recipeId': serializer.toJson<int>(recipeId),
      'quantity': serializer.toJson<int>(quantity),
      'buyerContact': serializer.toJson<String?>(buyerContact),
      'note': serializer.toJson<String?>(note),
      'unitPriceRupiah': serializer.toJson<int>(unitPriceRupiah),
      'status': serializer.toJson<int>(
        $OrdersTable.$converterstatus.toJson(status),
      ),
      'cancellationReason': serializer.toJson<String?>(cancellationReason),
      'hppSnapshotRupiah': serializer.toJson<int?>(hppSnapshotRupiah),
      'orderedAt': serializer.toJson<DateTime>(orderedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  CustomerOrder copyWith({
    int? id,
    int? purchaseOrderId,
    int? productId,
    int? recipeId,
    int? quantity,
    Value<String?> buyerContact = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? unitPriceRupiah,
    OrderStatus? status,
    Value<String?> cancellationReason = const Value.absent(),
    Value<int?> hppSnapshotRupiah = const Value.absent(),
    DateTime? orderedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => CustomerOrder(
    id: id ?? this.id,
    purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
    productId: productId ?? this.productId,
    recipeId: recipeId ?? this.recipeId,
    quantity: quantity ?? this.quantity,
    buyerContact: buyerContact.present ? buyerContact.value : this.buyerContact,
    note: note.present ? note.value : this.note,
    unitPriceRupiah: unitPriceRupiah ?? this.unitPriceRupiah,
    status: status ?? this.status,
    cancellationReason: cancellationReason.present
        ? cancellationReason.value
        : this.cancellationReason,
    hppSnapshotRupiah: hppSnapshotRupiah.present
        ? hppSnapshotRupiah.value
        : this.hppSnapshotRupiah,
    orderedAt: orderedAt ?? this.orderedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  CustomerOrder copyWithCompanion(OrdersCompanion data) {
    return CustomerOrder(
      id: data.id.present ? data.id.value : this.id,
      purchaseOrderId: data.purchaseOrderId.present
          ? data.purchaseOrderId.value
          : this.purchaseOrderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      buyerContact: data.buyerContact.present
          ? data.buyerContact.value
          : this.buyerContact,
      note: data.note.present ? data.note.value : this.note,
      unitPriceRupiah: data.unitPriceRupiah.present
          ? data.unitPriceRupiah.value
          : this.unitPriceRupiah,
      status: data.status.present ? data.status.value : this.status,
      cancellationReason: data.cancellationReason.present
          ? data.cancellationReason.value
          : this.cancellationReason,
      hppSnapshotRupiah: data.hppSnapshotRupiah.present
          ? data.hppSnapshotRupiah.value
          : this.hppSnapshotRupiah,
      orderedAt: data.orderedAt.present ? data.orderedAt.value : this.orderedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerOrder(')
          ..write('id: $id, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('productId: $productId, ')
          ..write('recipeId: $recipeId, ')
          ..write('quantity: $quantity, ')
          ..write('buyerContact: $buyerContact, ')
          ..write('note: $note, ')
          ..write('unitPriceRupiah: $unitPriceRupiah, ')
          ..write('status: $status, ')
          ..write('cancellationReason: $cancellationReason, ')
          ..write('hppSnapshotRupiah: $hppSnapshotRupiah, ')
          ..write('orderedAt: $orderedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchaseOrderId,
    productId,
    recipeId,
    quantity,
    buyerContact,
    note,
    unitPriceRupiah,
    status,
    cancellationReason,
    hppSnapshotRupiah,
    orderedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerOrder &&
          other.id == this.id &&
          other.purchaseOrderId == this.purchaseOrderId &&
          other.productId == this.productId &&
          other.recipeId == this.recipeId &&
          other.quantity == this.quantity &&
          other.buyerContact == this.buyerContact &&
          other.note == this.note &&
          other.unitPriceRupiah == this.unitPriceRupiah &&
          other.status == this.status &&
          other.cancellationReason == this.cancellationReason &&
          other.hppSnapshotRupiah == this.hppSnapshotRupiah &&
          other.orderedAt == this.orderedAt &&
          other.completedAt == this.completedAt);
}

class OrdersCompanion extends UpdateCompanion<CustomerOrder> {
  final Value<int> id;
  final Value<int> purchaseOrderId;
  final Value<int> productId;
  final Value<int> recipeId;
  final Value<int> quantity;
  final Value<String?> buyerContact;
  final Value<String?> note;
  final Value<int> unitPriceRupiah;
  final Value<OrderStatus> status;
  final Value<String?> cancellationReason;
  final Value<int?> hppSnapshotRupiah;
  final Value<DateTime> orderedAt;
  final Value<DateTime?> completedAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.purchaseOrderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.buyerContact = const Value.absent(),
    this.note = const Value.absent(),
    this.unitPriceRupiah = const Value.absent(),
    this.status = const Value.absent(),
    this.cancellationReason = const Value.absent(),
    this.hppSnapshotRupiah = const Value.absent(),
    this.orderedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseOrderId,
    required int productId,
    required int recipeId,
    required int quantity,
    this.buyerContact = const Value.absent(),
    this.note = const Value.absent(),
    required int unitPriceRupiah,
    this.status = const Value.absent(),
    this.cancellationReason = const Value.absent(),
    this.hppSnapshotRupiah = const Value.absent(),
    this.orderedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : purchaseOrderId = Value(purchaseOrderId),
       productId = Value(productId),
       recipeId = Value(recipeId),
       quantity = Value(quantity),
       unitPriceRupiah = Value(unitPriceRupiah);
  static Insertable<CustomerOrder> custom({
    Expression<int>? id,
    Expression<int>? purchaseOrderId,
    Expression<int>? productId,
    Expression<int>? recipeId,
    Expression<int>? quantity,
    Expression<String>? buyerContact,
    Expression<String>? note,
    Expression<int>? unitPriceRupiah,
    Expression<int>? status,
    Expression<String>? cancellationReason,
    Expression<int>? hppSnapshotRupiah,
    Expression<DateTime>? orderedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseOrderId != null) 'purchase_order_id': purchaseOrderId,
      if (productId != null) 'product_id': productId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (quantity != null) 'quantity': quantity,
      if (buyerContact != null) 'buyer_contact': buyerContact,
      if (note != null) 'note': note,
      if (unitPriceRupiah != null) 'unit_price_rupiah': unitPriceRupiah,
      if (status != null) 'status': status,
      if (cancellationReason != null) 'cancellation_reason': cancellationReason,
      if (hppSnapshotRupiah != null) 'hpp_snapshot_rupiah': hppSnapshotRupiah,
      if (orderedAt != null) 'ordered_at': orderedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? id,
    Value<int>? purchaseOrderId,
    Value<int>? productId,
    Value<int>? recipeId,
    Value<int>? quantity,
    Value<String?>? buyerContact,
    Value<String?>? note,
    Value<int>? unitPriceRupiah,
    Value<OrderStatus>? status,
    Value<String?>? cancellationReason,
    Value<int?>? hppSnapshotRupiah,
    Value<DateTime>? orderedAt,
    Value<DateTime?>? completedAt,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      productId: productId ?? this.productId,
      recipeId: recipeId ?? this.recipeId,
      quantity: quantity ?? this.quantity,
      buyerContact: buyerContact ?? this.buyerContact,
      note: note ?? this.note,
      unitPriceRupiah: unitPriceRupiah ?? this.unitPriceRupiah,
      status: status ?? this.status,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      hppSnapshotRupiah: hppSnapshotRupiah ?? this.hppSnapshotRupiah,
      orderedAt: orderedAt ?? this.orderedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseOrderId.present) {
      map['purchase_order_id'] = Variable<int>(purchaseOrderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (buyerContact.present) {
      map['buyer_contact'] = Variable<String>(buyerContact.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (unitPriceRupiah.present) {
      map['unit_price_rupiah'] = Variable<int>(unitPriceRupiah.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $OrdersTable.$converterstatus.toSql(status.value),
      );
    }
    if (cancellationReason.present) {
      map['cancellation_reason'] = Variable<String>(cancellationReason.value);
    }
    if (hppSnapshotRupiah.present) {
      map['hpp_snapshot_rupiah'] = Variable<int>(hppSnapshotRupiah.value);
    }
    if (orderedAt.present) {
      map['ordered_at'] = Variable<DateTime>(orderedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('productId: $productId, ')
          ..write('recipeId: $recipeId, ')
          ..write('quantity: $quantity, ')
          ..write('buyerContact: $buyerContact, ')
          ..write('note: $note, ')
          ..write('unitPriceRupiah: $unitPriceRupiah, ')
          ..write('status: $status, ')
          ..write('cancellationReason: $cancellationReason, ')
          ..write('hppSnapshotRupiah: $hppSnapshotRupiah, ')
          ..write('orderedAt: $orderedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $OrderCancellationCausesTable extends OrderCancellationCauses
    with TableInfo<$OrderCancellationCausesTable, OrderCancellationCause> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderCancellationCausesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, orderId, ingredientId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_cancellation_causes';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderCancellationCause> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderCancellationCause map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderCancellationCause(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_id'],
      )!,
    );
  }

  @override
  $OrderCancellationCausesTable createAlias(String alias) {
    return $OrderCancellationCausesTable(attachedDatabase, alias);
  }
}

class OrderCancellationCause extends DataClass
    implements Insertable<OrderCancellationCause> {
  final int id;
  final int orderId;
  final int ingredientId;
  const OrderCancellationCause({
    required this.id,
    required this.orderId,
    required this.ingredientId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    return map;
  }

  OrderCancellationCausesCompanion toCompanion(bool nullToAbsent) {
    return OrderCancellationCausesCompanion(
      id: Value(id),
      orderId: Value(orderId),
      ingredientId: Value(ingredientId),
    );
  }

  factory OrderCancellationCause.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderCancellationCause(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'ingredientId': serializer.toJson<int>(ingredientId),
    };
  }

  OrderCancellationCause copyWith({int? id, int? orderId, int? ingredientId}) =>
      OrderCancellationCause(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        ingredientId: ingredientId ?? this.ingredientId,
      );
  OrderCancellationCause copyWithCompanion(
    OrderCancellationCausesCompanion data,
  ) {
    return OrderCancellationCause(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderCancellationCause(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('ingredientId: $ingredientId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, ingredientId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderCancellationCause &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.ingredientId == this.ingredientId);
}

class OrderCancellationCausesCompanion
    extends UpdateCompanion<OrderCancellationCause> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> ingredientId;
  const OrderCancellationCausesCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.ingredientId = const Value.absent(),
  });
  OrderCancellationCausesCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int ingredientId,
  }) : orderId = Value(orderId),
       ingredientId = Value(ingredientId);
  static Insertable<OrderCancellationCause> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? ingredientId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
    });
  }

  OrderCancellationCausesCompanion copyWith({
    Value<int>? id,
    Value<int>? orderId,
    Value<int>? ingredientId,
  }) {
    return OrderCancellationCausesCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      ingredientId: ingredientId ?? this.ingredientId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderCancellationCausesCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('ingredientId: $ingredientId')
          ..write(')'))
        .toString();
  }
}

class $ProductionSessionsTable extends ProductionSessions
    with TableInfo<$ProductionSessionsTable, ProductionSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductionSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _purchaseOrderIdMeta = const VerificationMeta(
    'purchaseOrderId',
  );
  @override
  late final GeneratedColumn<int> purchaseOrderId = GeneratedColumn<int>(
    'purchase_order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase_orders (id)',
    ),
  );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
    'confirmed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseOrderId,
    confirmedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'production_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductionSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_order_id')) {
      context.handle(
        _purchaseOrderIdMeta,
        purchaseOrderId.isAcceptableOrUnknown(
          data['purchase_order_id']!,
          _purchaseOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseOrderIdMeta);
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confirmedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {purchaseOrderId},
  ];
  @override
  ProductionSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductionSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchaseOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_order_id'],
      )!,
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}confirmed_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductionSessionsTable createAlias(String alias) {
    return $ProductionSessionsTable(attachedDatabase, alias);
  }
}

class ProductionSession extends DataClass
    implements Insertable<ProductionSession> {
  final int id;
  final int purchaseOrderId;
  final DateTime confirmedAt;
  final DateTime createdAt;
  const ProductionSession({
    required this.id,
    required this.purchaseOrderId,
    required this.confirmedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_order_id'] = Variable<int>(purchaseOrderId);
    map['confirmed_at'] = Variable<DateTime>(confirmedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductionSessionsCompanion toCompanion(bool nullToAbsent) {
    return ProductionSessionsCompanion(
      id: Value(id),
      purchaseOrderId: Value(purchaseOrderId),
      confirmedAt: Value(confirmedAt),
      createdAt: Value(createdAt),
    );
  }

  factory ProductionSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductionSession(
      id: serializer.fromJson<int>(json['id']),
      purchaseOrderId: serializer.fromJson<int>(json['purchaseOrderId']),
      confirmedAt: serializer.fromJson<DateTime>(json['confirmedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseOrderId': serializer.toJson<int>(purchaseOrderId),
      'confirmedAt': serializer.toJson<DateTime>(confirmedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductionSession copyWith({
    int? id,
    int? purchaseOrderId,
    DateTime? confirmedAt,
    DateTime? createdAt,
  }) => ProductionSession(
    id: id ?? this.id,
    purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
    confirmedAt: confirmedAt ?? this.confirmedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  ProductionSession copyWithCompanion(ProductionSessionsCompanion data) {
    return ProductionSession(
      id: data.id.present ? data.id.value : this.id,
      purchaseOrderId: data.purchaseOrderId.present
          ? data.purchaseOrderId.value
          : this.purchaseOrderId,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductionSession(')
          ..write('id: $id, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchaseOrderId, confirmedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductionSession &&
          other.id == this.id &&
          other.purchaseOrderId == this.purchaseOrderId &&
          other.confirmedAt == this.confirmedAt &&
          other.createdAt == this.createdAt);
}

class ProductionSessionsCompanion extends UpdateCompanion<ProductionSession> {
  final Value<int> id;
  final Value<int> purchaseOrderId;
  final Value<DateTime> confirmedAt;
  final Value<DateTime> createdAt;
  const ProductionSessionsCompanion({
    this.id = const Value.absent(),
    this.purchaseOrderId = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductionSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseOrderId,
    required DateTime confirmedAt,
    this.createdAt = const Value.absent(),
  }) : purchaseOrderId = Value(purchaseOrderId),
       confirmedAt = Value(confirmedAt);
  static Insertable<ProductionSession> custom({
    Expression<int>? id,
    Expression<int>? purchaseOrderId,
    Expression<DateTime>? confirmedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseOrderId != null) 'purchase_order_id': purchaseOrderId,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductionSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? purchaseOrderId,
    Value<DateTime>? confirmedAt,
    Value<DateTime>? createdAt,
  }) {
    return ProductionSessionsCompanion(
      id: id ?? this.id,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseOrderId.present) {
      map['purchase_order_id'] = Variable<int>(purchaseOrderId.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductionSessionsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProductionSessionCostsTable extends ProductionSessionCosts
    with TableInfo<$ProductionSessionCostsTable, ProductionSessionCost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductionSessionCostsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES production_sessions (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountRupiahMeta = const VerificationMeta(
    'amountRupiah',
  );
  @override
  late final GeneratedColumn<int> amountRupiah = GeneratedColumn<int>(
    'amount_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, name, amountRupiah];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'production_session_costs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductionSessionCost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_rupiah')) {
      context.handle(
        _amountRupiahMeta,
        amountRupiah.isAcceptableOrUnknown(
          data['amount_rupiah']!,
          _amountRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountRupiahMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductionSessionCost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductionSessionCost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_rupiah'],
      )!,
    );
  }

  @override
  $ProductionSessionCostsTable createAlias(String alias) {
    return $ProductionSessionCostsTable(attachedDatabase, alias);
  }
}

class ProductionSessionCost extends DataClass
    implements Insertable<ProductionSessionCost> {
  final int id;
  final int sessionId;
  final String name;
  final int amountRupiah;
  const ProductionSessionCost({
    required this.id,
    required this.sessionId,
    required this.name,
    required this.amountRupiah,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['name'] = Variable<String>(name);
    map['amount_rupiah'] = Variable<int>(amountRupiah);
    return map;
  }

  ProductionSessionCostsCompanion toCompanion(bool nullToAbsent) {
    return ProductionSessionCostsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      name: Value(name),
      amountRupiah: Value(amountRupiah),
    );
  }

  factory ProductionSessionCost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductionSessionCost(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      name: serializer.fromJson<String>(json['name']),
      amountRupiah: serializer.fromJson<int>(json['amountRupiah']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'name': serializer.toJson<String>(name),
      'amountRupiah': serializer.toJson<int>(amountRupiah),
    };
  }

  ProductionSessionCost copyWith({
    int? id,
    int? sessionId,
    String? name,
    int? amountRupiah,
  }) => ProductionSessionCost(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    name: name ?? this.name,
    amountRupiah: amountRupiah ?? this.amountRupiah,
  );
  ProductionSessionCost copyWithCompanion(
    ProductionSessionCostsCompanion data,
  ) {
    return ProductionSessionCost(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      name: data.name.present ? data.name.value : this.name,
      amountRupiah: data.amountRupiah.present
          ? data.amountRupiah.value
          : this.amountRupiah,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductionSessionCost(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('amountRupiah: $amountRupiah')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, name, amountRupiah);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductionSessionCost &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.name == this.name &&
          other.amountRupiah == this.amountRupiah);
}

class ProductionSessionCostsCompanion
    extends UpdateCompanion<ProductionSessionCost> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> name;
  final Value<int> amountRupiah;
  const ProductionSessionCostsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.name = const Value.absent(),
    this.amountRupiah = const Value.absent(),
  });
  ProductionSessionCostsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String name,
    required int amountRupiah,
  }) : sessionId = Value(sessionId),
       name = Value(name),
       amountRupiah = Value(amountRupiah);
  static Insertable<ProductionSessionCost> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? name,
    Expression<int>? amountRupiah,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (name != null) 'name': name,
      if (amountRupiah != null) 'amount_rupiah': amountRupiah,
    });
  }

  ProductionSessionCostsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? name,
    Value<int>? amountRupiah,
  }) {
    return ProductionSessionCostsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      name: name ?? this.name,
      amountRupiah: amountRupiah ?? this.amountRupiah,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountRupiah.present) {
      map['amount_rupiah'] = Variable<int>(amountRupiah.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductionSessionCostsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('amountRupiah: $amountRupiah')
          ..write(')'))
        .toString();
  }
}

class $IngredientUsagesTable extends IngredientUsages
    with TableInfo<$IngredientUsagesTable, IngredientUsage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientUsagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES production_sessions (id)',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _quantityUsedMeta = const VerificationMeta(
    'quantityUsed',
  );
  @override
  late final GeneratedColumn<double> quantityUsed = GeneratedColumn<double>(
    'quantity_used',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    ingredientId,
    quantityUsed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_usages';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientUsage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity_used')) {
      context.handle(
        _quantityUsedMeta,
        quantityUsed.isAcceptableOrUnknown(
          data['quantity_used']!,
          _quantityUsedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityUsedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientUsage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientUsage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_id'],
      )!,
      quantityUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_used'],
      )!,
    );
  }

  @override
  $IngredientUsagesTable createAlias(String alias) {
    return $IngredientUsagesTable(attachedDatabase, alias);
  }
}

class IngredientUsage extends DataClass implements Insertable<IngredientUsage> {
  final int id;
  final int sessionId;
  final int ingredientId;

  /// Realized quantity consumed, in the ingredient's unit.
  final double quantityUsed;
  const IngredientUsage({
    required this.id,
    required this.sessionId,
    required this.ingredientId,
    required this.quantityUsed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['quantity_used'] = Variable<double>(quantityUsed);
    return map;
  }

  IngredientUsagesCompanion toCompanion(bool nullToAbsent) {
    return IngredientUsagesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      ingredientId: Value(ingredientId),
      quantityUsed: Value(quantityUsed),
    );
  }

  factory IngredientUsage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientUsage(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      quantityUsed: serializer.fromJson<double>(json['quantityUsed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'quantityUsed': serializer.toJson<double>(quantityUsed),
    };
  }

  IngredientUsage copyWith({
    int? id,
    int? sessionId,
    int? ingredientId,
    double? quantityUsed,
  }) => IngredientUsage(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    ingredientId: ingredientId ?? this.ingredientId,
    quantityUsed: quantityUsed ?? this.quantityUsed,
  );
  IngredientUsage copyWithCompanion(IngredientUsagesCompanion data) {
    return IngredientUsage(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantityUsed: data.quantityUsed.present
          ? data.quantityUsed.value
          : this.quantityUsed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientUsage(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityUsed: $quantityUsed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, ingredientId, quantityUsed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientUsage &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.ingredientId == this.ingredientId &&
          other.quantityUsed == this.quantityUsed);
}

class IngredientUsagesCompanion extends UpdateCompanion<IngredientUsage> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> ingredientId;
  final Value<double> quantityUsed;
  const IngredientUsagesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantityUsed = const Value.absent(),
  });
  IngredientUsagesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int ingredientId,
    required double quantityUsed,
  }) : sessionId = Value(sessionId),
       ingredientId = Value(ingredientId),
       quantityUsed = Value(quantityUsed);
  static Insertable<IngredientUsage> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? ingredientId,
    Expression<double>? quantityUsed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantityUsed != null) 'quantity_used': quantityUsed,
    });
  }

  IngredientUsagesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? ingredientId,
    Value<double>? quantityUsed,
  }) {
    return IngredientUsagesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantityUsed: quantityUsed ?? this.quantityUsed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (quantityUsed.present) {
      map['quantity_used'] = Variable<double>(quantityUsed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientUsagesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityUsed: $quantityUsed')
          ..write(')'))
        .toString();
  }
}

class $DailyOperationalCostsTable extends DailyOperationalCosts
    with TableInfo<$DailyOperationalCostsTable, DailyOperationalCost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyOperationalCostsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountRupiahMeta = const VerificationMeta(
    'amountRupiah',
  );
  @override
  late final GeneratedColumn<int> amountRupiah = GeneratedColumn<int>(
    'amount_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    amountRupiah,
    date,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_operational_costs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyOperationalCost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_rupiah')) {
      context.handle(
        _amountRupiahMeta,
        amountRupiah.isAcceptableOrUnknown(
          data['amount_rupiah']!,
          _amountRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountRupiahMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyOperationalCost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyOperationalCost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_rupiah'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailyOperationalCostsTable createAlias(String alias) {
    return $DailyOperationalCostsTable(attachedDatabase, alias);
  }
}

class DailyOperationalCost extends DataClass
    implements Insertable<DailyOperationalCost> {
  final int id;
  final String name;
  final int amountRupiah;
  final DateTime date;
  final DateTime createdAt;
  const DailyOperationalCost({
    required this.id,
    required this.name,
    required this.amountRupiah,
    required this.date,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount_rupiah'] = Variable<int>(amountRupiah);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyOperationalCostsCompanion toCompanion(bool nullToAbsent) {
    return DailyOperationalCostsCompanion(
      id: Value(id),
      name: Value(name),
      amountRupiah: Value(amountRupiah),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory DailyOperationalCost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyOperationalCost(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amountRupiah: serializer.fromJson<int>(json['amountRupiah']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amountRupiah': serializer.toJson<int>(amountRupiah),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyOperationalCost copyWith({
    int? id,
    String? name,
    int? amountRupiah,
    DateTime? date,
    DateTime? createdAt,
  }) => DailyOperationalCost(
    id: id ?? this.id,
    name: name ?? this.name,
    amountRupiah: amountRupiah ?? this.amountRupiah,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
  );
  DailyOperationalCost copyWithCompanion(DailyOperationalCostsCompanion data) {
    return DailyOperationalCost(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amountRupiah: data.amountRupiah.present
          ? data.amountRupiah.value
          : this.amountRupiah,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyOperationalCost(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountRupiah: $amountRupiah, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amountRupiah, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyOperationalCost &&
          other.id == this.id &&
          other.name == this.name &&
          other.amountRupiah == this.amountRupiah &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class DailyOperationalCostsCompanion
    extends UpdateCompanion<DailyOperationalCost> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> amountRupiah;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const DailyOperationalCostsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amountRupiah = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyOperationalCostsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int amountRupiah,
    required DateTime date,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       amountRupiah = Value(amountRupiah),
       date = Value(date);
  static Insertable<DailyOperationalCost> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? amountRupiah,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amountRupiah != null) 'amount_rupiah': amountRupiah,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyOperationalCostsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? amountRupiah,
    Value<DateTime>? date,
    Value<DateTime>? createdAt,
  }) {
    return DailyOperationalCostsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amountRupiah: amountRupiah ?? this.amountRupiah,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountRupiah.present) {
      map['amount_rupiah'] = Variable<int>(amountRupiah.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyOperationalCostsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountRupiah: $amountRupiah, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DailyClosingsTable extends DailyClosings
    with TableInfo<$DailyClosingsTable, DailyClosing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyClosingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _totalRevenueRupiahMeta =
      const VerificationMeta('totalRevenueRupiah');
  @override
  late final GeneratedColumn<int> totalRevenueRupiah = GeneratedColumn<int>(
    'total_revenue_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalHppRupiahMeta = const VerificationMeta(
    'totalHppRupiah',
  );
  @override
  late final GeneratedColumn<int> totalHppRupiah = GeneratedColumn<int>(
    'total_hpp_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalOperationalCostRupiahMeta =
      const VerificationMeta('totalOperationalCostRupiah');
  @override
  late final GeneratedColumn<int> totalOperationalCostRupiah =
      GeneratedColumn<int>(
        'total_operational_cost_rupiah',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _totalWasteCostRupiahMeta =
      const VerificationMeta('totalWasteCostRupiah');
  @override
  late final GeneratedColumn<int> totalWasteCostRupiah = GeneratedColumn<int>(
    'total_waste_cost_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netProfitRupiahMeta = const VerificationMeta(
    'netProfitRupiah',
  );
  @override
  late final GeneratedColumn<int> netProfitRupiah = GeneratedColumn<int>(
    'net_profit_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    closedAt,
    totalRevenueRupiah,
    totalHppRupiah,
    totalOperationalCostRupiah,
    totalWasteCostRupiah,
    netProfitRupiah,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_closings';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyClosing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('total_revenue_rupiah')) {
      context.handle(
        _totalRevenueRupiahMeta,
        totalRevenueRupiah.isAcceptableOrUnknown(
          data['total_revenue_rupiah']!,
          _totalRevenueRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalRevenueRupiahMeta);
    }
    if (data.containsKey('total_hpp_rupiah')) {
      context.handle(
        _totalHppRupiahMeta,
        totalHppRupiah.isAcceptableOrUnknown(
          data['total_hpp_rupiah']!,
          _totalHppRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalHppRupiahMeta);
    }
    if (data.containsKey('total_operational_cost_rupiah')) {
      context.handle(
        _totalOperationalCostRupiahMeta,
        totalOperationalCostRupiah.isAcceptableOrUnknown(
          data['total_operational_cost_rupiah']!,
          _totalOperationalCostRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalOperationalCostRupiahMeta);
    }
    if (data.containsKey('total_waste_cost_rupiah')) {
      context.handle(
        _totalWasteCostRupiahMeta,
        totalWasteCostRupiah.isAcceptableOrUnknown(
          data['total_waste_cost_rupiah']!,
          _totalWasteCostRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalWasteCostRupiahMeta);
    }
    if (data.containsKey('net_profit_rupiah')) {
      context.handle(
        _netProfitRupiahMeta,
        netProfitRupiah.isAcceptableOrUnknown(
          data['net_profit_rupiah']!,
          _netProfitRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_netProfitRupiahMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date},
  ];
  @override
  DailyClosing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyClosing(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      )!,
      totalRevenueRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_revenue_rupiah'],
      )!,
      totalHppRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_hpp_rupiah'],
      )!,
      totalOperationalCostRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_operational_cost_rupiah'],
      )!,
      totalWasteCostRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_waste_cost_rupiah'],
      )!,
      netProfitRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}net_profit_rupiah'],
      )!,
    );
  }

  @override
  $DailyClosingsTable createAlias(String alias) {
    return $DailyClosingsTable(attachedDatabase, alias);
  }
}

class DailyClosing extends DataClass implements Insertable<DailyClosing> {
  final int id;
  final DateTime date;
  final DateTime closedAt;
  final int totalRevenueRupiah;
  final int totalHppRupiah;
  final int totalOperationalCostRupiah;
  final int totalWasteCostRupiah;
  final int netProfitRupiah;
  const DailyClosing({
    required this.id,
    required this.date,
    required this.closedAt,
    required this.totalRevenueRupiah,
    required this.totalHppRupiah,
    required this.totalOperationalCostRupiah,
    required this.totalWasteCostRupiah,
    required this.netProfitRupiah,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['closed_at'] = Variable<DateTime>(closedAt);
    map['total_revenue_rupiah'] = Variable<int>(totalRevenueRupiah);
    map['total_hpp_rupiah'] = Variable<int>(totalHppRupiah);
    map['total_operational_cost_rupiah'] = Variable<int>(
      totalOperationalCostRupiah,
    );
    map['total_waste_cost_rupiah'] = Variable<int>(totalWasteCostRupiah);
    map['net_profit_rupiah'] = Variable<int>(netProfitRupiah);
    return map;
  }

  DailyClosingsCompanion toCompanion(bool nullToAbsent) {
    return DailyClosingsCompanion(
      id: Value(id),
      date: Value(date),
      closedAt: Value(closedAt),
      totalRevenueRupiah: Value(totalRevenueRupiah),
      totalHppRupiah: Value(totalHppRupiah),
      totalOperationalCostRupiah: Value(totalOperationalCostRupiah),
      totalWasteCostRupiah: Value(totalWasteCostRupiah),
      netProfitRupiah: Value(netProfitRupiah),
    );
  }

  factory DailyClosing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyClosing(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      closedAt: serializer.fromJson<DateTime>(json['closedAt']),
      totalRevenueRupiah: serializer.fromJson<int>(json['totalRevenueRupiah']),
      totalHppRupiah: serializer.fromJson<int>(json['totalHppRupiah']),
      totalOperationalCostRupiah: serializer.fromJson<int>(
        json['totalOperationalCostRupiah'],
      ),
      totalWasteCostRupiah: serializer.fromJson<int>(
        json['totalWasteCostRupiah'],
      ),
      netProfitRupiah: serializer.fromJson<int>(json['netProfitRupiah']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'closedAt': serializer.toJson<DateTime>(closedAt),
      'totalRevenueRupiah': serializer.toJson<int>(totalRevenueRupiah),
      'totalHppRupiah': serializer.toJson<int>(totalHppRupiah),
      'totalOperationalCostRupiah': serializer.toJson<int>(
        totalOperationalCostRupiah,
      ),
      'totalWasteCostRupiah': serializer.toJson<int>(totalWasteCostRupiah),
      'netProfitRupiah': serializer.toJson<int>(netProfitRupiah),
    };
  }

  DailyClosing copyWith({
    int? id,
    DateTime? date,
    DateTime? closedAt,
    int? totalRevenueRupiah,
    int? totalHppRupiah,
    int? totalOperationalCostRupiah,
    int? totalWasteCostRupiah,
    int? netProfitRupiah,
  }) => DailyClosing(
    id: id ?? this.id,
    date: date ?? this.date,
    closedAt: closedAt ?? this.closedAt,
    totalRevenueRupiah: totalRevenueRupiah ?? this.totalRevenueRupiah,
    totalHppRupiah: totalHppRupiah ?? this.totalHppRupiah,
    totalOperationalCostRupiah:
        totalOperationalCostRupiah ?? this.totalOperationalCostRupiah,
    totalWasteCostRupiah: totalWasteCostRupiah ?? this.totalWasteCostRupiah,
    netProfitRupiah: netProfitRupiah ?? this.netProfitRupiah,
  );
  DailyClosing copyWithCompanion(DailyClosingsCompanion data) {
    return DailyClosing(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      totalRevenueRupiah: data.totalRevenueRupiah.present
          ? data.totalRevenueRupiah.value
          : this.totalRevenueRupiah,
      totalHppRupiah: data.totalHppRupiah.present
          ? data.totalHppRupiah.value
          : this.totalHppRupiah,
      totalOperationalCostRupiah: data.totalOperationalCostRupiah.present
          ? data.totalOperationalCostRupiah.value
          : this.totalOperationalCostRupiah,
      totalWasteCostRupiah: data.totalWasteCostRupiah.present
          ? data.totalWasteCostRupiah.value
          : this.totalWasteCostRupiah,
      netProfitRupiah: data.netProfitRupiah.present
          ? data.netProfitRupiah.value
          : this.netProfitRupiah,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyClosing(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('closedAt: $closedAt, ')
          ..write('totalRevenueRupiah: $totalRevenueRupiah, ')
          ..write('totalHppRupiah: $totalHppRupiah, ')
          ..write('totalOperationalCostRupiah: $totalOperationalCostRupiah, ')
          ..write('totalWasteCostRupiah: $totalWasteCostRupiah, ')
          ..write('netProfitRupiah: $netProfitRupiah')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    closedAt,
    totalRevenueRupiah,
    totalHppRupiah,
    totalOperationalCostRupiah,
    totalWasteCostRupiah,
    netProfitRupiah,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyClosing &&
          other.id == this.id &&
          other.date == this.date &&
          other.closedAt == this.closedAt &&
          other.totalRevenueRupiah == this.totalRevenueRupiah &&
          other.totalHppRupiah == this.totalHppRupiah &&
          other.totalOperationalCostRupiah == this.totalOperationalCostRupiah &&
          other.totalWasteCostRupiah == this.totalWasteCostRupiah &&
          other.netProfitRupiah == this.netProfitRupiah);
}

class DailyClosingsCompanion extends UpdateCompanion<DailyClosing> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime> closedAt;
  final Value<int> totalRevenueRupiah;
  final Value<int> totalHppRupiah;
  final Value<int> totalOperationalCostRupiah;
  final Value<int> totalWasteCostRupiah;
  final Value<int> netProfitRupiah;
  const DailyClosingsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.totalRevenueRupiah = const Value.absent(),
    this.totalHppRupiah = const Value.absent(),
    this.totalOperationalCostRupiah = const Value.absent(),
    this.totalWasteCostRupiah = const Value.absent(),
    this.netProfitRupiah = const Value.absent(),
  });
  DailyClosingsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.closedAt = const Value.absent(),
    required int totalRevenueRupiah,
    required int totalHppRupiah,
    required int totalOperationalCostRupiah,
    required int totalWasteCostRupiah,
    required int netProfitRupiah,
  }) : date = Value(date),
       totalRevenueRupiah = Value(totalRevenueRupiah),
       totalHppRupiah = Value(totalHppRupiah),
       totalOperationalCostRupiah = Value(totalOperationalCostRupiah),
       totalWasteCostRupiah = Value(totalWasteCostRupiah),
       netProfitRupiah = Value(netProfitRupiah);
  static Insertable<DailyClosing> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<DateTime>? closedAt,
    Expression<int>? totalRevenueRupiah,
    Expression<int>? totalHppRupiah,
    Expression<int>? totalOperationalCostRupiah,
    Expression<int>? totalWasteCostRupiah,
    Expression<int>? netProfitRupiah,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (closedAt != null) 'closed_at': closedAt,
      if (totalRevenueRupiah != null)
        'total_revenue_rupiah': totalRevenueRupiah,
      if (totalHppRupiah != null) 'total_hpp_rupiah': totalHppRupiah,
      if (totalOperationalCostRupiah != null)
        'total_operational_cost_rupiah': totalOperationalCostRupiah,
      if (totalWasteCostRupiah != null)
        'total_waste_cost_rupiah': totalWasteCostRupiah,
      if (netProfitRupiah != null) 'net_profit_rupiah': netProfitRupiah,
    });
  }

  DailyClosingsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<DateTime>? closedAt,
    Value<int>? totalRevenueRupiah,
    Value<int>? totalHppRupiah,
    Value<int>? totalOperationalCostRupiah,
    Value<int>? totalWasteCostRupiah,
    Value<int>? netProfitRupiah,
  }) {
    return DailyClosingsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      closedAt: closedAt ?? this.closedAt,
      totalRevenueRupiah: totalRevenueRupiah ?? this.totalRevenueRupiah,
      totalHppRupiah: totalHppRupiah ?? this.totalHppRupiah,
      totalOperationalCostRupiah:
          totalOperationalCostRupiah ?? this.totalOperationalCostRupiah,
      totalWasteCostRupiah: totalWasteCostRupiah ?? this.totalWasteCostRupiah,
      netProfitRupiah: netProfitRupiah ?? this.netProfitRupiah,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (totalRevenueRupiah.present) {
      map['total_revenue_rupiah'] = Variable<int>(totalRevenueRupiah.value);
    }
    if (totalHppRupiah.present) {
      map['total_hpp_rupiah'] = Variable<int>(totalHppRupiah.value);
    }
    if (totalOperationalCostRupiah.present) {
      map['total_operational_cost_rupiah'] = Variable<int>(
        totalOperationalCostRupiah.value,
      );
    }
    if (totalWasteCostRupiah.present) {
      map['total_waste_cost_rupiah'] = Variable<int>(
        totalWasteCostRupiah.value,
      );
    }
    if (netProfitRupiah.present) {
      map['net_profit_rupiah'] = Variable<int>(netProfitRupiah.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyClosingsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('closedAt: $closedAt, ')
          ..write('totalRevenueRupiah: $totalRevenueRupiah, ')
          ..write('totalHppRupiah: $totalHppRupiah, ')
          ..write('totalOperationalCostRupiah: $totalOperationalCostRupiah, ')
          ..write('totalWasteCostRupiah: $totalWasteCostRupiah, ')
          ..write('netProfitRupiah: $netProfitRupiah')
          ..write(')'))
        .toString();
  }
}

class $CapitalEntriesTable extends CapitalEntries
    with TableInfo<$CapitalEntriesTable, CapitalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CapitalEntriesTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<CapitalEntryKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<CapitalEntryKind>($CapitalEntriesTable.$converterkind);
  static const VerificationMeta _amountRupiahMeta = const VerificationMeta(
    'amountRupiah',
  );
  @override
  late final GeneratedColumn<int> amountRupiah = GeneratedColumn<int>(
    'amount_rupiah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    amountRupiah,
    note,
    recordedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'capital_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CapitalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_rupiah')) {
      context.handle(
        _amountRupiahMeta,
        amountRupiah.isAcceptableOrUnknown(
          data['amount_rupiah']!,
          _amountRupiahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountRupiahMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CapitalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CapitalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $CapitalEntriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
      amountRupiah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_rupiah'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CapitalEntriesTable createAlias(String alias) {
    return $CapitalEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CapitalEntryKind, int, int> $converterkind =
      const EnumIndexConverter<CapitalEntryKind>(CapitalEntryKind.values);
}

class CapitalEntry extends DataClass implements Insertable<CapitalEntry> {
  final int id;
  final CapitalEntryKind kind;
  final int amountRupiah;
  final String? note;
  final DateTime recordedAt;
  final DateTime createdAt;
  const CapitalEntry({
    required this.id,
    required this.kind,
    required this.amountRupiah,
    this.note,
    required this.recordedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<int>(
        $CapitalEntriesTable.$converterkind.toSql(kind),
      );
    }
    map['amount_rupiah'] = Variable<int>(amountRupiah);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CapitalEntriesCompanion toCompanion(bool nullToAbsent) {
    return CapitalEntriesCompanion(
      id: Value(id),
      kind: Value(kind),
      amountRupiah: Value(amountRupiah),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      recordedAt: Value(recordedAt),
      createdAt: Value(createdAt),
    );
  }

  factory CapitalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CapitalEntry(
      id: serializer.fromJson<int>(json['id']),
      kind: $CapitalEntriesTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
      amountRupiah: serializer.fromJson<int>(json['amountRupiah']),
      note: serializer.fromJson<String?>(json['note']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<int>(
        $CapitalEntriesTable.$converterkind.toJson(kind),
      ),
      'amountRupiah': serializer.toJson<int>(amountRupiah),
      'note': serializer.toJson<String?>(note),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CapitalEntry copyWith({
    int? id,
    CapitalEntryKind? kind,
    int? amountRupiah,
    Value<String?> note = const Value.absent(),
    DateTime? recordedAt,
    DateTime? createdAt,
  }) => CapitalEntry(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    amountRupiah: amountRupiah ?? this.amountRupiah,
    note: note.present ? note.value : this.note,
    recordedAt: recordedAt ?? this.recordedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  CapitalEntry copyWithCompanion(CapitalEntriesCompanion data) {
    return CapitalEntry(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountRupiah: data.amountRupiah.present
          ? data.amountRupiah.value
          : this.amountRupiah,
      note: data.note.present ? data.note.value : this.note,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CapitalEntry(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('amountRupiah: $amountRupiah, ')
          ..write('note: $note, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, amountRupiah, note, recordedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CapitalEntry &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.amountRupiah == this.amountRupiah &&
          other.note == this.note &&
          other.recordedAt == this.recordedAt &&
          other.createdAt == this.createdAt);
}

class CapitalEntriesCompanion extends UpdateCompanion<CapitalEntry> {
  final Value<int> id;
  final Value<CapitalEntryKind> kind;
  final Value<int> amountRupiah;
  final Value<String?> note;
  final Value<DateTime> recordedAt;
  final Value<DateTime> createdAt;
  const CapitalEntriesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountRupiah = const Value.absent(),
    this.note = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CapitalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required CapitalEntryKind kind,
    required int amountRupiah,
    this.note = const Value.absent(),
    required DateTime recordedAt,
    this.createdAt = const Value.absent(),
  }) : kind = Value(kind),
       amountRupiah = Value(amountRupiah),
       recordedAt = Value(recordedAt);
  static Insertable<CapitalEntry> custom({
    Expression<int>? id,
    Expression<int>? kind,
    Expression<int>? amountRupiah,
    Expression<String>? note,
    Expression<DateTime>? recordedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (amountRupiah != null) 'amount_rupiah': amountRupiah,
      if (note != null) 'note': note,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CapitalEntriesCompanion copyWith({
    Value<int>? id,
    Value<CapitalEntryKind>? kind,
    Value<int>? amountRupiah,
    Value<String?>? note,
    Value<DateTime>? recordedAt,
    Value<DateTime>? createdAt,
  }) {
    return CapitalEntriesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      amountRupiah: amountRupiah ?? this.amountRupiah,
      note: note ?? this.note,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(
        $CapitalEntriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (amountRupiah.present) {
      map['amount_rupiah'] = Variable<int>(amountRupiah.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CapitalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('amountRupiah: $amountRupiah, ')
          ..write('note: $note, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BackupLogsTable extends BackupLogs
    with TableInfo<$BackupLogsTable, BackupLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BackupFormat, int> format =
      GeneratedColumn<int>(
        'format',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<BackupFormat>($BackupLogsTable.$converterformat);
  @override
  late final GeneratedColumnWithTypeConverter<BackupTrigger, int> trigger =
      GeneratedColumn<int>(
        'trigger',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<BackupTrigger>($BackupLogsTable.$convertertrigger);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    filePath,
    format,
    trigger,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<BackupLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackupLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      format: $BackupLogsTable.$converterformat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}format'],
        )!,
      ),
      trigger: $BackupLogsTable.$convertertrigger.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}trigger'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BackupLogsTable createAlias(String alias) {
    return $BackupLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BackupFormat, int, int> $converterformat =
      const EnumIndexConverter<BackupFormat>(BackupFormat.values);
  static JsonTypeConverter2<BackupTrigger, int, int> $convertertrigger =
      const EnumIndexConverter<BackupTrigger>(BackupTrigger.values);
}

class BackupLog extends DataClass implements Insertable<BackupLog> {
  final int id;
  final String filePath;
  final BackupFormat format;
  final BackupTrigger trigger;
  final DateTime createdAt;
  const BackupLog({
    required this.id,
    required this.filePath,
    required this.format,
    required this.trigger,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_path'] = Variable<String>(filePath);
    {
      map['format'] = Variable<int>(
        $BackupLogsTable.$converterformat.toSql(format),
      );
    }
    {
      map['trigger'] = Variable<int>(
        $BackupLogsTable.$convertertrigger.toSql(trigger),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BackupLogsCompanion toCompanion(bool nullToAbsent) {
    return BackupLogsCompanion(
      id: Value(id),
      filePath: Value(filePath),
      format: Value(format),
      trigger: Value(trigger),
      createdAt: Value(createdAt),
    );
  }

  factory BackupLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupLog(
      id: serializer.fromJson<int>(json['id']),
      filePath: serializer.fromJson<String>(json['filePath']),
      format: $BackupLogsTable.$converterformat.fromJson(
        serializer.fromJson<int>(json['format']),
      ),
      trigger: $BackupLogsTable.$convertertrigger.fromJson(
        serializer.fromJson<int>(json['trigger']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'filePath': serializer.toJson<String>(filePath),
      'format': serializer.toJson<int>(
        $BackupLogsTable.$converterformat.toJson(format),
      ),
      'trigger': serializer.toJson<int>(
        $BackupLogsTable.$convertertrigger.toJson(trigger),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BackupLog copyWith({
    int? id,
    String? filePath,
    BackupFormat? format,
    BackupTrigger? trigger,
    DateTime? createdAt,
  }) => BackupLog(
    id: id ?? this.id,
    filePath: filePath ?? this.filePath,
    format: format ?? this.format,
    trigger: trigger ?? this.trigger,
    createdAt: createdAt ?? this.createdAt,
  );
  BackupLog copyWithCompanion(BackupLogsCompanion data) {
    return BackupLog(
      id: data.id.present ? data.id.value : this.id,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      format: data.format.present ? data.format.value : this.format,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupLog(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('format: $format, ')
          ..write('trigger: $trigger, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, filePath, format, trigger, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupLog &&
          other.id == this.id &&
          other.filePath == this.filePath &&
          other.format == this.format &&
          other.trigger == this.trigger &&
          other.createdAt == this.createdAt);
}

class BackupLogsCompanion extends UpdateCompanion<BackupLog> {
  final Value<int> id;
  final Value<String> filePath;
  final Value<BackupFormat> format;
  final Value<BackupTrigger> trigger;
  final Value<DateTime> createdAt;
  const BackupLogsCompanion({
    this.id = const Value.absent(),
    this.filePath = const Value.absent(),
    this.format = const Value.absent(),
    this.trigger = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BackupLogsCompanion.insert({
    this.id = const Value.absent(),
    required String filePath,
    required BackupFormat format,
    required BackupTrigger trigger,
    this.createdAt = const Value.absent(),
  }) : filePath = Value(filePath),
       format = Value(format),
       trigger = Value(trigger);
  static Insertable<BackupLog> custom({
    Expression<int>? id,
    Expression<String>? filePath,
    Expression<int>? format,
    Expression<int>? trigger,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (filePath != null) 'file_path': filePath,
      if (format != null) 'format': format,
      if (trigger != null) 'trigger': trigger,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BackupLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? filePath,
    Value<BackupFormat>? format,
    Value<BackupTrigger>? trigger,
    Value<DateTime>? createdAt,
  }) {
    return BackupLogsCompanion(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      format: format ?? this.format,
      trigger: trigger ?? this.trigger,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (format.present) {
      map['format'] = Variable<int>(
        $BackupLogsTable.$converterformat.toSql(format.value),
      );
    }
    if (trigger.present) {
      map['trigger'] = Variable<int>(
        $BackupLogsTable.$convertertrigger.toSql(trigger.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupLogsCompanion(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('format: $format, ')
          ..write('trigger: $trigger, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IngredientCategoriesTable ingredientCategories =
      $IngredientCategoriesTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $PurchaseBatchesTable purchaseBatches = $PurchaseBatchesTable(
    this,
  );
  late final $IngredientPurchasesTable ingredientPurchases =
      $IngredientPurchasesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeItemsTable recipeItems = $RecipeItemsTable(this);
  late final $PurchaseOrdersTable purchaseOrders = $PurchaseOrdersTable(this);
  late final $PoProductQuotasTable poProductQuotas = $PoProductQuotasTable(
    this,
  );
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderCancellationCausesTable orderCancellationCauses =
      $OrderCancellationCausesTable(this);
  late final $ProductionSessionsTable productionSessions =
      $ProductionSessionsTable(this);
  late final $ProductionSessionCostsTable productionSessionCosts =
      $ProductionSessionCostsTable(this);
  late final $IngredientUsagesTable ingredientUsages = $IngredientUsagesTable(
    this,
  );
  late final $DailyOperationalCostsTable dailyOperationalCosts =
      $DailyOperationalCostsTable(this);
  late final $DailyClosingsTable dailyClosings = $DailyClosingsTable(this);
  late final $CapitalEntriesTable capitalEntries = $CapitalEntriesTable(this);
  late final $BackupLogsTable backupLogs = $BackupLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    ingredientCategories,
    ingredients,
    purchaseBatches,
    ingredientPurchases,
    products,
    recipes,
    recipeItems,
    purchaseOrders,
    poProductQuotas,
    orders,
    orderCancellationCauses,
    productionSessions,
    productionSessionCosts,
    ingredientUsages,
    dailyOperationalCosts,
    dailyClosings,
    capitalEntries,
    backupLogs,
  ];
}

typedef $$IngredientCategoriesTableCreateCompanionBuilder =
    IngredientCategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
    });
typedef $$IngredientCategoriesTableUpdateCompanionBuilder =
    IngredientCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

final class $$IngredientCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IngredientCategoriesTable,
          IngredientCategory
        > {
  $$IngredientCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$IngredientsTable, List<Ingredient>>
  _ingredientsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredients,
    aliasName: 'ingredient_categories__id__ingredients__category_id',
  );

  $$IngredientsTableProcessedTableManager get ingredientsRefs {
    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngredientCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientCategoriesTable> {
  $$IngredientCategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ingredientsRefs(
    Expression<bool> Function($$IngredientsTableFilterComposer f) f,
  ) {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientCategoriesTable> {
  $$IngredientCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientCategoriesTable> {
  $$IngredientCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> ingredientsRefs<T extends Object>(
    Expression<T> Function($$IngredientsTableAnnotationComposer a) f,
  ) {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientCategoriesTable,
          IngredientCategory,
          $$IngredientCategoriesTableFilterComposer,
          $$IngredientCategoriesTableOrderingComposer,
          $$IngredientCategoriesTableAnnotationComposer,
          $$IngredientCategoriesTableCreateCompanionBuilder,
          $$IngredientCategoriesTableUpdateCompanionBuilder,
          (IngredientCategory, $$IngredientCategoriesTableReferences),
          IngredientCategory,
          PrefetchHooks Function({bool ingredientsRefs})
        > {
  $$IngredientCategoriesTableTableManager(
    _$AppDatabase db,
    $IngredientCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IngredientCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => IngredientCategoriesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
              }) => IngredientCategoriesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IngredientCategoriesTable, IngredientCategory>(
                    table,
                  ),
                  $$IngredientCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ingredientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ingredientsRefs) db.ingredients],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ingredientsRefs)
                    await $_getPrefetchedData<
                      IngredientCategory,
                      $IngredientCategoriesTable,
                      Ingredient
                    >(
                      currentTable: table,
                      referencedTable: $$IngredientCategoriesTableReferences
                          ._ingredientsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$IngredientCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).ingredientsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$IngredientCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientCategoriesTable,
      IngredientCategory,
      $$IngredientCategoriesTableFilterComposer,
      $$IngredientCategoriesTableOrderingComposer,
      $$IngredientCategoriesTableAnnotationComposer,
      $$IngredientCategoriesTableCreateCompanionBuilder,
      $$IngredientCategoriesTableUpdateCompanionBuilder,
      (IngredientCategory, $$IngredientCategoriesTableReferences),
      IngredientCategory,
      PrefetchHooks Function({bool ingredientsRefs})
    >;
typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      required String name,
      required IngredientUnit unit,
      Value<int?> categoryId,
      Value<double> currentStock,
      Value<double> currentCostPerUnit,
      Value<DateTime> createdAt,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<IngredientUnit> unit,
      Value<int?> categoryId,
      Value<double> currentStock,
      Value<double> currentCostPerUnit,
      Value<DateTime> createdAt,
    });

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IngredientCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .ingredientCategories
      .createAlias('ingredients__category_id__ingredient_categories__id');

  $$IngredientCategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$IngredientCategoriesTableTableManager(
      $_db,
      $_db.ingredientCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $IngredientPurchasesTable,
    List<IngredientPurchase>
  >
  _ingredientPurchasesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ingredientPurchases,
        aliasName: 'ingredients__id__ingredient_purchases__ingredient_id',
      );

  $$IngredientPurchasesTableProcessedTableManager get ingredientPurchasesRefs {
    final manager = $$IngredientPurchasesTableTableManager(
      $_db,
      $_db.ingredientPurchases,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ingredientPurchasesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeItemsTable, List<RecipeItem>>
  _recipeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeItems,
    aliasName: 'ingredients__id__recipe_items__ingredient_id',
  );

  $$RecipeItemsTableProcessedTableManager get recipeItemsRefs {
    final manager = $$RecipeItemsTableTableManager(
      $_db,
      $_db.recipeItems,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $OrderCancellationCausesTable,
    List<OrderCancellationCause>
  >
  _orderCancellationCausesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderCancellationCauses,
        aliasName: 'ingredients__id__order_cancellation_causes__ingredient_id',
      );

  $$OrderCancellationCausesTableProcessedTableManager
  get orderCancellationCausesRefs {
    final manager = $$OrderCancellationCausesTableTableManager(
      $_db,
      $_db.orderCancellationCauses,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderCancellationCausesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IngredientUsagesTable, List<IngredientUsage>>
  _ingredientUsagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredientUsages,
    aliasName: 'ingredients__id__ingredient_usages__ingredient_id',
  );

  $$IngredientUsagesTableProcessedTableManager get ingredientUsagesRefs {
    final manager = $$IngredientUsagesTableTableManager(
      $_db,
      $_db.ingredientUsages,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ingredientUsagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IngredientUnit, IngredientUnit, int>
  get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentCostPerUnit => $composableBuilder(
    column: $table.currentCostPerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$IngredientCategoriesTableFilterComposer get categoryId {
    final $$IngredientCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.ingredientCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.ingredientCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ingredientPurchasesRefs(
    Expression<bool> Function($$IngredientPurchasesTableFilterComposer f) f,
  ) {
    final $$IngredientPurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientPurchases,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientPurchasesTableFilterComposer(
            $db: $db,
            $table: $db.ingredientPurchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeItemsRefs(
    Expression<bool> Function($$RecipeItemsTableFilterComposer f) f,
  ) {
    final $$RecipeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableFilterComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderCancellationCausesRefs(
    Expression<bool> Function($$OrderCancellationCausesTableFilterComposer f) f,
  ) {
    final $$OrderCancellationCausesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.orderCancellationCauses,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrderCancellationCausesTableFilterComposer(
                $db: $db,
                $table: $db.orderCancellationCauses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> ingredientUsagesRefs(
    Expression<bool> Function($$IngredientUsagesTableFilterComposer f) f,
  ) {
    final $$IngredientUsagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientUsages,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientUsagesTableFilterComposer(
            $db: $db,
            $table: $db.ingredientUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentCostPerUnit => $composableBuilder(
    column: $table.currentCostPerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngredientCategoriesTableOrderingComposer get categoryId {
    final $$IngredientCategoriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.ingredientCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientCategoriesTableOrderingComposer(
                $db: $db,
                $table: $db.ingredientCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IngredientUnit, int> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentCostPerUnit => $composableBuilder(
    column: $table.currentCostPerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$IngredientCategoriesTableAnnotationComposer get categoryId {
    final $$IngredientCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.ingredientCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> ingredientPurchasesRefs<T extends Object>(
    Expression<T> Function($$IngredientPurchasesTableAnnotationComposer a) f,
  ) {
    final $$IngredientPurchasesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientPurchases,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientPurchasesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientPurchases,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recipeItemsRefs<T extends Object>(
    Expression<T> Function($$RecipeItemsTableAnnotationComposer a) f,
  ) {
    final $$RecipeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderCancellationCausesRefs<T extends Object>(
    Expression<T> Function($$OrderCancellationCausesTableAnnotationComposer a)
    f,
  ) {
    final $$OrderCancellationCausesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.orderCancellationCauses,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrderCancellationCausesTableAnnotationComposer(
                $db: $db,
                $table: $db.orderCancellationCauses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> ingredientUsagesRefs<T extends Object>(
    Expression<T> Function($$IngredientUsagesTableAnnotationComposer a) f,
  ) {
    final $$IngredientUsagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientUsages,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientUsagesTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredientUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          Ingredient,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (Ingredient, $$IngredientsTableReferences),
          Ingredient,
          PrefetchHooks Function({
            bool categoryId,
            bool ingredientPurchasesRefs,
            bool recipeItemsRefs,
            bool orderCancellationCausesRefs,
            bool ingredientUsagesRefs,
          })
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<IngredientUnit> unit = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<double> currentStock = const Value.absent(),
                Value<double> currentCostPerUnit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                name: name,
                unit: unit,
                categoryId: categoryId,
                currentStock: currentStock,
                currentCostPerUnit: currentCostPerUnit,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required IngredientUnit unit,
                Value<int?> categoryId = const Value.absent(),
                Value<double> currentStock = const Value.absent(),
                Value<double> currentCostPerUnit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => IngredientsCompanion.insert(
                id: id,
                name: name,
                unit: unit,
                categoryId: categoryId,
                currentStock: currentStock,
                currentCostPerUnit: currentCostPerUnit,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IngredientsTable, Ingredient>(table),
                  $$IngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                ingredientPurchasesRefs = false,
                recipeItemsRefs = false,
                orderCancellationCausesRefs = false,
                ingredientUsagesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ingredientPurchasesRefs) db.ingredientPurchases,
                    if (recipeItemsRefs) db.recipeItems,
                    if (orderCancellationCausesRefs) db.orderCancellationCauses,
                    if (ingredientUsagesRefs) db.ingredientUsages,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$IngredientsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$IngredientsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingredientPurchasesRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          IngredientPurchase
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._ingredientPurchasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientPurchasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeItemsRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          RecipeItem
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._recipeItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderCancellationCausesRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          OrderCancellationCause
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._orderCancellationCausesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderCancellationCausesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ingredientUsagesRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          IngredientUsage
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._ingredientUsagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientUsagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      Ingredient,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (Ingredient, $$IngredientsTableReferences),
      Ingredient,
      PrefetchHooks Function({
        bool categoryId,
        bool ingredientPurchasesRefs,
        bool recipeItemsRefs,
        bool orderCancellationCausesRefs,
        bool ingredientUsagesRefs,
      })
    >;
typedef $$PurchaseBatchesTableCreateCompanionBuilder =
    PurchaseBatchesCompanion Function({
      Value<int> id,
      required DateTime purchasedAt,
      Value<String?> storeName,
      required int totalPriceRupiah,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$PurchaseBatchesTableUpdateCompanionBuilder =
    PurchaseBatchesCompanion Function({
      Value<int> id,
      Value<DateTime> purchasedAt,
      Value<String?> storeName,
      Value<int> totalPriceRupiah,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$PurchaseBatchesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PurchaseBatchesTable, PurchaseBatch> {
  $$PurchaseBatchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $IngredientPurchasesTable,
    List<IngredientPurchase>
  >
  _ingredientPurchasesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ingredientPurchases,
        aliasName: 'purchase_batches__id__ingredient_purchases__batch_id',
      );

  $$IngredientPurchasesTableProcessedTableManager get ingredientPurchasesRefs {
    final manager = $$IngredientPurchasesTableTableManager(
      $_db,
      $_db.ingredientPurchases,
    ).filter((f) => f.batchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ingredientPurchasesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PurchaseBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseBatchesTable> {
  $$PurchaseBatchesTableFilterComposer({
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

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPriceRupiah => $composableBuilder(
    column: $table.totalPriceRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ingredientPurchasesRefs(
    Expression<bool> Function($$IngredientPurchasesTableFilterComposer f) f,
  ) {
    final $$IngredientPurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientPurchases,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientPurchasesTableFilterComposer(
            $db: $db,
            $table: $db.ingredientPurchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchaseBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseBatchesTable> {
  $$PurchaseBatchesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPriceRupiah => $composableBuilder(
    column: $table.totalPriceRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseBatchesTable> {
  $$PurchaseBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<int> get totalPriceRupiah => $composableBuilder(
    column: $table.totalPriceRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> ingredientPurchasesRefs<T extends Object>(
    Expression<T> Function($$IngredientPurchasesTableAnnotationComposer a) f,
  ) {
    final $$IngredientPurchasesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientPurchases,
          getReferencedColumn: (t) => t.batchId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientPurchasesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientPurchases,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PurchaseBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseBatchesTable,
          PurchaseBatch,
          $$PurchaseBatchesTableFilterComposer,
          $$PurchaseBatchesTableOrderingComposer,
          $$PurchaseBatchesTableAnnotationComposer,
          $$PurchaseBatchesTableCreateCompanionBuilder,
          $$PurchaseBatchesTableUpdateCompanionBuilder,
          (PurchaseBatch, $$PurchaseBatchesTableReferences),
          PurchaseBatch,
          PrefetchHooks Function({bool ingredientPurchasesRefs})
        > {
  $$PurchaseBatchesTableTableManager(
    _$AppDatabase db,
    $PurchaseBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<String?> storeName = const Value.absent(),
                Value<int> totalPriceRupiah = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PurchaseBatchesCompanion(
                id: id,
                purchasedAt: purchasedAt,
                storeName: storeName,
                totalPriceRupiah: totalPriceRupiah,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime purchasedAt,
                Value<String?> storeName = const Value.absent(),
                required int totalPriceRupiah,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PurchaseBatchesCompanion.insert(
                id: id,
                purchasedAt: purchasedAt,
                storeName: storeName,
                totalPriceRupiah: totalPriceRupiah,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchaseBatchesTable, PurchaseBatch>(table),
                  $$PurchaseBatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ingredientPurchasesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ingredientPurchasesRefs) db.ingredientPurchases,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ingredientPurchasesRefs)
                    await $_getPrefetchedData<
                      PurchaseBatch,
                      $PurchaseBatchesTable,
                      IngredientPurchase
                    >(
                      currentTable: table,
                      referencedTable: $$PurchaseBatchesTableReferences
                          ._ingredientPurchasesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PurchaseBatchesTableReferences(
                            db,
                            table,
                            p0,
                          ).ingredientPurchasesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.batchId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PurchaseBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseBatchesTable,
      PurchaseBatch,
      $$PurchaseBatchesTableFilterComposer,
      $$PurchaseBatchesTableOrderingComposer,
      $$PurchaseBatchesTableAnnotationComposer,
      $$PurchaseBatchesTableCreateCompanionBuilder,
      $$PurchaseBatchesTableUpdateCompanionBuilder,
      (PurchaseBatch, $$PurchaseBatchesTableReferences),
      PurchaseBatch,
      PrefetchHooks Function({bool ingredientPurchasesRefs})
    >;
typedef $$IngredientPurchasesTableCreateCompanionBuilder =
    IngredientPurchasesCompanion Function({
      Value<int> id,
      required int ingredientId,
      Value<int?> batchId,
      required double quantity,
      required int totalPriceRupiah,
      Value<String?> storeName,
      required DateTime purchasedAt,
      Value<DateTime> createdAt,
    });
typedef $$IngredientPurchasesTableUpdateCompanionBuilder =
    IngredientPurchasesCompanion Function({
      Value<int> id,
      Value<int> ingredientId,
      Value<int?> batchId,
      Value<double> quantity,
      Value<int> totalPriceRupiah,
      Value<String?> storeName,
      Value<DateTime> purchasedAt,
      Value<DateTime> createdAt,
    });

final class $$IngredientPurchasesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IngredientPurchasesTable,
          IngredientPurchase
        > {
  $$IngredientPurchasesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) => db
      .ingredients
      .createAlias('ingredient_purchases__ingredient_id__ingredients__id');

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PurchaseBatchesTable _batchIdTable(_$AppDatabase db) => db
      .purchaseBatches
      .createAlias('ingredient_purchases__batch_id__purchase_batches__id');

  $$PurchaseBatchesTableProcessedTableManager? get batchId {
    final $_column = $_itemColumn<int>('batch_id');
    if ($_column == null) return null;
    final manager = $$PurchaseBatchesTableTableManager(
      $_db,
      $_db.purchaseBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngredientPurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientPurchasesTable> {
  $$IngredientPurchasesTableFilterComposer({
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

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPriceRupiah => $composableBuilder(
    column: $table.totalPriceRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchaseBatchesTableFilterComposer get batchId {
    final $$PurchaseBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.purchaseBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseBatchesTableFilterComposer(
            $db: $db,
            $table: $db.purchaseBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientPurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientPurchasesTable> {
  $$IngredientPurchasesTableOrderingComposer({
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

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPriceRupiah => $composableBuilder(
    column: $table.totalPriceRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchaseBatchesTableOrderingComposer get batchId {
    final $$PurchaseBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.purchaseBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.purchaseBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientPurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientPurchasesTable> {
  $$IngredientPurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get totalPriceRupiah => $composableBuilder(
    column: $table.totalPriceRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchaseBatchesTableAnnotationComposer get batchId {
    final $$PurchaseBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.purchaseBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientPurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientPurchasesTable,
          IngredientPurchase,
          $$IngredientPurchasesTableFilterComposer,
          $$IngredientPurchasesTableOrderingComposer,
          $$IngredientPurchasesTableAnnotationComposer,
          $$IngredientPurchasesTableCreateCompanionBuilder,
          $$IngredientPurchasesTableUpdateCompanionBuilder,
          (IngredientPurchase, $$IngredientPurchasesTableReferences),
          IngredientPurchase,
          PrefetchHooks Function({bool ingredientId, bool batchId})
        > {
  $$IngredientPurchasesTableTableManager(
    _$AppDatabase db,
    $IngredientPurchasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientPurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientPurchasesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IngredientPurchasesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ingredientId = const Value.absent(),
                Value<int?> batchId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<int> totalPriceRupiah = const Value.absent(),
                Value<String?> storeName = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => IngredientPurchasesCompanion(
                id: id,
                ingredientId: ingredientId,
                batchId: batchId,
                quantity: quantity,
                totalPriceRupiah: totalPriceRupiah,
                storeName: storeName,
                purchasedAt: purchasedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ingredientId,
                Value<int?> batchId = const Value.absent(),
                required double quantity,
                required int totalPriceRupiah,
                Value<String?> storeName = const Value.absent(),
                required DateTime purchasedAt,
                Value<DateTime> createdAt = const Value.absent(),
              }) => IngredientPurchasesCompanion.insert(
                id: id,
                ingredientId: ingredientId,
                batchId: batchId,
                quantity: quantity,
                totalPriceRupiah: totalPriceRupiah,
                storeName: storeName,
                purchasedAt: purchasedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IngredientPurchasesTable, IngredientPurchase>(
                    table,
                  ),
                  $$IngredientPurchasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ingredientId = false, batchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ingredientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ingredientId,
                        referencedTable: $$IngredientPurchasesTableReferences
                            ._ingredientIdTable(db),
                        referencedColumn: $$IngredientPurchasesTableReferences
                            ._ingredientIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (batchId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.batchId,
                        referencedTable: $$IngredientPurchasesTableReferences
                            ._batchIdTable(db),
                        referencedColumn: $$IngredientPurchasesTableReferences
                            ._batchIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IngredientPurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientPurchasesTable,
      IngredientPurchase,
      $$IngredientPurchasesTableFilterComposer,
      $$IngredientPurchasesTableOrderingComposer,
      $$IngredientPurchasesTableAnnotationComposer,
      $$IngredientPurchasesTableCreateCompanionBuilder,
      $$IngredientPurchasesTableUpdateCompanionBuilder,
      (IngredientPurchase, $$IngredientPurchasesTableReferences),
      IngredientPurchase,
      PrefetchHooks Function({bool ingredientId, bool batchId})
    >;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipesTable, List<Recipe>> _recipesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.recipes,
    aliasName: 'products__id__recipes__product_id',
  );

  $$RecipesTableProcessedTableManager get recipesRefs {
    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PoProductQuotasTable, List<PoProductQuota>>
  _poProductQuotasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.poProductQuotas,
    aliasName: 'products__id__po_product_quotas__product_id',
  );

  $$PoProductQuotasTableProcessedTableManager get poProductQuotasRefs {
    final manager = $$PoProductQuotasTableTableManager(
      $_db,
      $_db.poProductQuotas,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _poProductQuotasRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<CustomerOrder>>
  _ordersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: 'products__id__orders__product_id',
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recipesRefs(
    Expression<bool> Function($$RecipesTableFilterComposer f) f,
  ) {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> poProductQuotasRefs(
    Expression<bool> Function($$PoProductQuotasTableFilterComposer f) f,
  ) {
    final $$PoProductQuotasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.poProductQuotas,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PoProductQuotasTableFilterComposer(
            $db: $db,
            $table: $db.poProductQuotas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> recipesRefs<T extends Object>(
    Expression<T> Function($$RecipesTableAnnotationComposer a) f,
  ) {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> poProductQuotasRefs<T extends Object>(
    Expression<T> Function($$PoProductQuotasTableAnnotationComposer a) f,
  ) {
    final $$PoProductQuotasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.poProductQuotas,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PoProductQuotasTableAnnotationComposer(
            $db: $db,
            $table: $db.poProductQuotas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool recipesRefs,
            bool poProductQuotasRefs,
            bool ordersRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductsTable, Product>(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recipesRefs = false,
                poProductQuotasRefs = false,
                ordersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipesRefs) db.recipes,
                    if (poProductQuotasRefs) db.poProductQuotas,
                    if (ordersRefs) db.orders,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          Recipe
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._recipesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (poProductQuotasRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          PoProductQuota
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._poProductQuotasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).poProductQuotasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordersRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          CustomerOrder
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._ordersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).ordersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool recipesRefs,
        bool poProductQuotasRefs,
        bool ordersRefs,
      })
    >;
typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required int productId,
  required int sellingPriceRupiah,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<int> productId,
  Value<int> sellingPriceRupiah,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('recipes__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecipeItemsTable, List<RecipeItem>>
  _recipeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeItems,
    aliasName: 'recipes__id__recipe_items__recipe_id',
  );

  $$RecipeItemsTableProcessedTableManager get recipeItemsRefs {
    final manager = $$RecipeItemsTableTableManager(
      $_db,
      $_db.recipeItems,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<CustomerOrder>>
  _ordersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: 'recipes__id__orders__recipe_id',
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
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

  ColumnFilters<int> get sellingPriceRupiah => $composableBuilder(
    column: $table.sellingPriceRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recipeItemsRefs(
    Expression<bool> Function($$RecipeItemsTableFilterComposer f) f,
  ) {
    final $$RecipeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableFilterComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
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

  ColumnOrderings<int> get sellingPriceRupiah => $composableBuilder(
    column: $table.sellingPriceRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sellingPriceRupiah => $composableBuilder(
    column: $table.sellingPriceRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recipeItemsRefs<T extends Object>(
    Expression<T> Function($$RecipeItemsTableAnnotationComposer a) f,
  ) {
    final $$RecipeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, $$RecipesTableReferences),
          Recipe,
          PrefetchHooks Function({
            bool productId,
            bool recipeItemsRefs,
            bool ordersRefs,
          })
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> sellingPriceRupiah = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                productId: productId,
                sellingPriceRupiah: sellingPriceRupiah,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required int sellingPriceRupiah,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                productId: productId,
                sellingPriceRupiah: sellingPriceRupiah,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipesTable, Recipe>(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productId = false,
                recipeItemsRefs = false,
                ordersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipeItemsRefs) db.recipeItems,
                    if (ordersRefs) db.orders,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.productId,
                            referencedTable: $$RecipesTableReferences
                                ._productIdTable(db),
                            referencedColumn: $$RecipesTableReferences
                                ._productIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipeItemsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeItem
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._recipeItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordersRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          CustomerOrder
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._ordersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).ordersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, $$RecipesTableReferences),
      Recipe,
      PrefetchHooks Function({
        bool productId,
        bool recipeItemsRefs,
        bool ordersRefs,
      })
    >;
typedef $$RecipeItemsTableCreateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<int> id,
      required int recipeId,
      required int ingredientId,
      required double quantityPerBatch,
      Value<RecipeItemKind> kind,
    });
typedef $$RecipeItemsTableUpdateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int> ingredientId,
      Value<double> quantityPerBatch,
      Value<RecipeItemKind> kind,
    });

final class $$RecipeItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeItemsTable, RecipeItem> {
  $$RecipeItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('recipe_items__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) => db
      .ingredients
      .createAlias('recipe_items__ingredient_id__ingredients__id');

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableFilterComposer({
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

  ColumnFilters<double> get quantityPerBatch => $composableBuilder(
    column: $table.quantityPerBatch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecipeItemKind, RecipeItemKind, int>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableOrderingComposer({
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

  ColumnOrderings<double> get quantityPerBatch => $composableBuilder(
    column: $table.quantityPerBatch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantityPerBatch => $composableBuilder(
    column: $table.quantityPerBatch,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RecipeItemKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeItemsTable,
          RecipeItem,
          $$RecipeItemsTableFilterComposer,
          $$RecipeItemsTableOrderingComposer,
          $$RecipeItemsTableAnnotationComposer,
          $$RecipeItemsTableCreateCompanionBuilder,
          $$RecipeItemsTableUpdateCompanionBuilder,
          (RecipeItem, $$RecipeItemsTableReferences),
          RecipeItem,
          PrefetchHooks Function({bool recipeId, bool ingredientId})
        > {
  $$RecipeItemsTableTableManager(_$AppDatabase db, $RecipeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> ingredientId = const Value.absent(),
                Value<double> quantityPerBatch = const Value.absent(),
                Value<RecipeItemKind> kind = const Value.absent(),
              }) => RecipeItemsCompanion(
                id: id,
                recipeId: recipeId,
                ingredientId: ingredientId,
                quantityPerBatch: quantityPerBatch,
                kind: kind,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required int ingredientId,
                required double quantityPerBatch,
                Value<RecipeItemKind> kind = const Value.absent(),
              }) => RecipeItemsCompanion.insert(
                id: id,
                recipeId: recipeId,
                ingredientId: ingredientId,
                quantityPerBatch: quantityPerBatch,
                kind: kind,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeItemsTable, RecipeItem>(table),
                  $$RecipeItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recipeId,
                        referencedTable: $$RecipeItemsTableReferences
                            ._recipeIdTable(db),
                        referencedColumn: $$RecipeItemsTableReferences
                            ._recipeIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (ingredientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ingredientId,
                        referencedTable: $$RecipeItemsTableReferences
                            ._ingredientIdTable(db),
                        referencedColumn: $$RecipeItemsTableReferences
                            ._ingredientIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeItemsTable,
      RecipeItem,
      $$RecipeItemsTableFilterComposer,
      $$RecipeItemsTableOrderingComposer,
      $$RecipeItemsTableAnnotationComposer,
      $$RecipeItemsTableCreateCompanionBuilder,
      $$RecipeItemsTableUpdateCompanionBuilder,
      (RecipeItem, $$RecipeItemsTableReferences),
      RecipeItem,
      PrefetchHooks Function({bool recipeId, bool ingredientId})
    >;
typedef $$PurchaseOrdersTableCreateCompanionBuilder =
    PurchaseOrdersCompanion Function({
      Value<int> id,
      required String label,
      Value<PoStatus> status,
      Value<DateTime?> openedAt,
      Value<DateTime?> closedAt,
      Value<DateTime?> cookedAt,
      Value<DateTime> createdAt,
    });
typedef $$PurchaseOrdersTableUpdateCompanionBuilder =
    PurchaseOrdersCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<PoStatus> status,
      Value<DateTime?> openedAt,
      Value<DateTime?> closedAt,
      Value<DateTime?> cookedAt,
      Value<DateTime> createdAt,
    });

final class $$PurchaseOrdersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PurchaseOrdersTable,
          PurchaseOrderBatch
        > {
  $$PurchaseOrdersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PoProductQuotasTable, List<PoProductQuota>>
  _poProductQuotasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.poProductQuotas,
    aliasName: 'purchase_orders__id__po_product_quotas__purchase_order_id',
  );

  $$PoProductQuotasTableProcessedTableManager get poProductQuotasRefs {
    final manager = $$PoProductQuotasTableTableManager(
      $_db,
      $_db.poProductQuotas,
    ).filter((f) => f.purchaseOrderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _poProductQuotasRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<CustomerOrder>>
  _ordersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: 'purchase_orders__id__orders__purchase_order_id',
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.purchaseOrderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductionSessionsTable, List<ProductionSession>>
  _productionSessionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.productionSessions,
        aliasName:
            'purchase_orders__id__production_sessions__purchase_order_id',
      );

  $$ProductionSessionsTableProcessedTableManager get productionSessionsRefs {
    final manager = $$ProductionSessionsTableTableManager(
      $_db,
      $_db.productionSessions,
    ).filter((f) => f.purchaseOrderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productionSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PurchaseOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseOrdersTable> {
  $$PurchaseOrdersTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PoStatus, PoStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cookedAt => $composableBuilder(
    column: $table.cookedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> poProductQuotasRefs(
    Expression<bool> Function($$PoProductQuotasTableFilterComposer f) f,
  ) {
    final $$PoProductQuotasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.poProductQuotas,
      getReferencedColumn: (t) => t.purchaseOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PoProductQuotasTableFilterComposer(
            $db: $db,
            $table: $db.poProductQuotas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.purchaseOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productionSessionsRefs(
    Expression<bool> Function($$ProductionSessionsTableFilterComposer f) f,
  ) {
    final $$ProductionSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productionSessions,
      getReferencedColumn: (t) => t.purchaseOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionSessionsTableFilterComposer(
            $db: $db,
            $table: $db.productionSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchaseOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseOrdersTable> {
  $$PurchaseOrdersTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cookedAt => $composableBuilder(
    column: $table.cookedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseOrdersTable> {
  $$PurchaseOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PoStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cookedAt =>
      $composableBuilder(column: $table.cookedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> poProductQuotasRefs<T extends Object>(
    Expression<T> Function($$PoProductQuotasTableAnnotationComposer a) f,
  ) {
    final $$PoProductQuotasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.poProductQuotas,
      getReferencedColumn: (t) => t.purchaseOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PoProductQuotasTableAnnotationComposer(
            $db: $db,
            $table: $db.poProductQuotas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.purchaseOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productionSessionsRefs<T extends Object>(
    Expression<T> Function($$ProductionSessionsTableAnnotationComposer a) f,
  ) {
    final $$ProductionSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productionSessions,
          getReferencedColumn: (t) => t.purchaseOrderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductionSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.productionSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PurchaseOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseOrdersTable,
          PurchaseOrderBatch,
          $$PurchaseOrdersTableFilterComposer,
          $$PurchaseOrdersTableOrderingComposer,
          $$PurchaseOrdersTableAnnotationComposer,
          $$PurchaseOrdersTableCreateCompanionBuilder,
          $$PurchaseOrdersTableUpdateCompanionBuilder,
          (PurchaseOrderBatch, $$PurchaseOrdersTableReferences),
          PurchaseOrderBatch,
          PrefetchHooks Function({
            bool poProductQuotasRefs,
            bool ordersRefs,
            bool productionSessionsRefs,
          })
        > {
  $$PurchaseOrdersTableTableManager(
    _$AppDatabase db,
    $PurchaseOrdersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<PoStatus> status = const Value.absent(),
                Value<DateTime?> openedAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<DateTime?> cookedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PurchaseOrdersCompanion(
                id: id,
                label: label,
                status: status,
                openedAt: openedAt,
                closedAt: closedAt,
                cookedAt: cookedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                Value<PoStatus> status = const Value.absent(),
                Value<DateTime?> openedAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<DateTime?> cookedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PurchaseOrdersCompanion.insert(
                id: id,
                label: label,
                status: status,
                openedAt: openedAt,
                closedAt: closedAt,
                cookedAt: cookedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchaseOrdersTable, PurchaseOrderBatch>(table),
                  $$PurchaseOrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                poProductQuotasRefs = false,
                ordersRefs = false,
                productionSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (poProductQuotasRefs) db.poProductQuotas,
                    if (ordersRefs) db.orders,
                    if (productionSessionsRefs) db.productionSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (poProductQuotasRefs)
                        await $_getPrefetchedData<
                          PurchaseOrderBatch,
                          $PurchaseOrdersTable,
                          PoProductQuota
                        >(
                          currentTable: table,
                          referencedTable: $$PurchaseOrdersTableReferences
                              ._poProductQuotasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PurchaseOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).poProductQuotasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.purchaseOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordersRefs)
                        await $_getPrefetchedData<
                          PurchaseOrderBatch,
                          $PurchaseOrdersTable,
                          CustomerOrder
                        >(
                          currentTable: table,
                          referencedTable: $$PurchaseOrdersTableReferences
                              ._ordersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PurchaseOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).ordersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.purchaseOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productionSessionsRefs)
                        await $_getPrefetchedData<
                          PurchaseOrderBatch,
                          $PurchaseOrdersTable,
                          ProductionSession
                        >(
                          currentTable: table,
                          referencedTable: $$PurchaseOrdersTableReferences
                              ._productionSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PurchaseOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).productionSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.purchaseOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PurchaseOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseOrdersTable,
      PurchaseOrderBatch,
      $$PurchaseOrdersTableFilterComposer,
      $$PurchaseOrdersTableOrderingComposer,
      $$PurchaseOrdersTableAnnotationComposer,
      $$PurchaseOrdersTableCreateCompanionBuilder,
      $$PurchaseOrdersTableUpdateCompanionBuilder,
      (PurchaseOrderBatch, $$PurchaseOrdersTableReferences),
      PurchaseOrderBatch,
      PrefetchHooks Function({
        bool poProductQuotasRefs,
        bool ordersRefs,
        bool productionSessionsRefs,
      })
    >;
typedef $$PoProductQuotasTableCreateCompanionBuilder =
    PoProductQuotasCompanion Function({
      Value<int> id,
      required int purchaseOrderId,
      required int productId,
      required int quotaQuantity,
    });
typedef $$PoProductQuotasTableUpdateCompanionBuilder =
    PoProductQuotasCompanion Function({
      Value<int> id,
      Value<int> purchaseOrderId,
      Value<int> productId,
      Value<int> quotaQuantity,
    });

final class $$PoProductQuotasTableReferences
    extends
        BaseReferences<_$AppDatabase, $PoProductQuotasTable, PoProductQuota> {
  $$PoProductQuotasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PurchaseOrdersTable _purchaseOrderIdTable(_$AppDatabase db) => db
      .purchaseOrders
      .createAlias('po_product_quotas__purchase_order_id__purchase_orders__id');

  $$PurchaseOrdersTableProcessedTableManager get purchaseOrderId {
    final $_column = $_itemColumn<int>('purchase_order_id')!;

    final manager = $$PurchaseOrdersTableTableManager(
      $_db,
      $_db.purchaseOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('po_product_quotas__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PoProductQuotasTableFilterComposer
    extends Composer<_$AppDatabase, $PoProductQuotasTable> {
  $$PoProductQuotasTableFilterComposer({
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

  ColumnFilters<int> get quotaQuantity => $composableBuilder(
    column: $table.quotaQuantity,
    builder: (column) => ColumnFilters(column),
  );

  $$PurchaseOrdersTableFilterComposer get purchaseOrderId {
    final $$PurchaseOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableFilterComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PoProductQuotasTableOrderingComposer
    extends Composer<_$AppDatabase, $PoProductQuotasTable> {
  $$PoProductQuotasTableOrderingComposer({
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

  ColumnOrderings<int> get quotaQuantity => $composableBuilder(
    column: $table.quotaQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  $$PurchaseOrdersTableOrderingComposer get purchaseOrderId {
    final $$PurchaseOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PoProductQuotasTableAnnotationComposer
    extends Composer<_$AppDatabase, $PoProductQuotasTable> {
  $$PoProductQuotasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quotaQuantity => $composableBuilder(
    column: $table.quotaQuantity,
    builder: (column) => column,
  );

  $$PurchaseOrdersTableAnnotationComposer get purchaseOrderId {
    final $$PurchaseOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PoProductQuotasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PoProductQuotasTable,
          PoProductQuota,
          $$PoProductQuotasTableFilterComposer,
          $$PoProductQuotasTableOrderingComposer,
          $$PoProductQuotasTableAnnotationComposer,
          $$PoProductQuotasTableCreateCompanionBuilder,
          $$PoProductQuotasTableUpdateCompanionBuilder,
          (PoProductQuota, $$PoProductQuotasTableReferences),
          PoProductQuota,
          PrefetchHooks Function({bool purchaseOrderId, bool productId})
        > {
  $$PoProductQuotasTableTableManager(
    _$AppDatabase db,
    $PoProductQuotasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PoProductQuotasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PoProductQuotasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PoProductQuotasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> purchaseOrderId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> quotaQuantity = const Value.absent(),
              }) => PoProductQuotasCompanion(
                id: id,
                purchaseOrderId: purchaseOrderId,
                productId: productId,
                quotaQuantity: quotaQuantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int purchaseOrderId,
                required int productId,
                required int quotaQuantity,
              }) => PoProductQuotasCompanion.insert(
                id: id,
                purchaseOrderId: purchaseOrderId,
                productId: productId,
                quotaQuantity: quotaQuantity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PoProductQuotasTable, PoProductQuota>(table),
                  $$PoProductQuotasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({purchaseOrderId = false, productId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (purchaseOrderId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.purchaseOrderId,
                            referencedTable: $$PoProductQuotasTableReferences
                                ._purchaseOrderIdTable(db),
                            referencedColumn: $$PoProductQuotasTableReferences
                                ._purchaseOrderIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (productId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.productId,
                            referencedTable: $$PoProductQuotasTableReferences
                                ._productIdTable(db),
                            referencedColumn: $$PoProductQuotasTableReferences
                                ._productIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PoProductQuotasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PoProductQuotasTable,
      PoProductQuota,
      $$PoProductQuotasTableFilterComposer,
      $$PoProductQuotasTableOrderingComposer,
      $$PoProductQuotasTableAnnotationComposer,
      $$PoProductQuotasTableCreateCompanionBuilder,
      $$PoProductQuotasTableUpdateCompanionBuilder,
      (PoProductQuota, $$PoProductQuotasTableReferences),
      PoProductQuota,
      PrefetchHooks Function({bool purchaseOrderId, bool productId})
    >;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  required int purchaseOrderId,
  required int productId,
  required int recipeId,
  required int quantity,
  Value<String?> buyerContact,
  Value<String?> note,
  required int unitPriceRupiah,
  Value<OrderStatus> status,
  Value<String?> cancellationReason,
  Value<int?> hppSnapshotRupiah,
  Value<DateTime> orderedAt,
  Value<DateTime?> completedAt,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<int> purchaseOrderId,
  Value<int> productId,
  Value<int> recipeId,
  Value<int> quantity,
  Value<String?> buyerContact,
  Value<String?> note,
  Value<int> unitPriceRupiah,
  Value<OrderStatus> status,
  Value<String?> cancellationReason,
  Value<int?> hppSnapshotRupiah,
  Value<DateTime> orderedAt,
  Value<DateTime?> completedAt,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, CustomerOrder> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PurchaseOrdersTable _purchaseOrderIdTable(_$AppDatabase db) => db
      .purchaseOrders
      .createAlias('orders__purchase_order_id__purchase_orders__id');

  $$PurchaseOrdersTableProcessedTableManager get purchaseOrderId {
    final $_column = $_itemColumn<int>('purchase_order_id')!;

    final manager = $$PurchaseOrdersTableTableManager(
      $_db,
      $_db.purchaseOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('orders__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('orders__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $OrderCancellationCausesTable,
    List<OrderCancellationCause>
  >
  _orderCancellationCausesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderCancellationCauses,
        aliasName: 'orders__id__order_cancellation_causes__order_id',
      );

  $$OrderCancellationCausesTableProcessedTableManager
  get orderCancellationCausesRefs {
    final manager = $$OrderCancellationCausesTableTableManager(
      $_db,
      $_db.orderCancellationCauses,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderCancellationCausesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
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

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get buyerContact => $composableBuilder(
    column: $table.buyerContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceRupiah => $composableBuilder(
    column: $table.unitPriceRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OrderStatus, OrderStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get cancellationReason => $composableBuilder(
    column: $table.cancellationReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hppSnapshotRupiah => $composableBuilder(
    column: $table.hppSnapshotRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get orderedAt => $composableBuilder(
    column: $table.orderedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PurchaseOrdersTableFilterComposer get purchaseOrderId {
    final $$PurchaseOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableFilterComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderCancellationCausesRefs(
    Expression<bool> Function($$OrderCancellationCausesTableFilterComposer f) f,
  ) {
    final $$OrderCancellationCausesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.orderCancellationCauses,
          getReferencedColumn: (t) => t.orderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrderCancellationCausesTableFilterComposer(
                $db: $db,
                $table: $db.orderCancellationCauses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
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

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get buyerContact => $composableBuilder(
    column: $table.buyerContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceRupiah => $composableBuilder(
    column: $table.unitPriceRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancellationReason => $composableBuilder(
    column: $table.cancellationReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hppSnapshotRupiah => $composableBuilder(
    column: $table.hppSnapshotRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get orderedAt => $composableBuilder(
    column: $table.orderedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PurchaseOrdersTableOrderingComposer get purchaseOrderId {
    final $$PurchaseOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get buyerContact => $composableBuilder(
    column: $table.buyerContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get unitPriceRupiah => $composableBuilder(
    column: $table.unitPriceRupiah,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<OrderStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get cancellationReason => $composableBuilder(
    column: $table.cancellationReason,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hppSnapshotRupiah => $composableBuilder(
    column: $table.hppSnapshotRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get orderedAt =>
      $composableBuilder(column: $table.orderedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$PurchaseOrdersTableAnnotationComposer get purchaseOrderId {
    final $$PurchaseOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderCancellationCausesRefs<T extends Object>(
    Expression<T> Function($$OrderCancellationCausesTableAnnotationComposer a)
    f,
  ) {
    final $$OrderCancellationCausesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.orderCancellationCauses,
          getReferencedColumn: (t) => t.orderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrderCancellationCausesTableAnnotationComposer(
                $db: $db,
                $table: $db.orderCancellationCauses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          CustomerOrder,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (CustomerOrder, $$OrdersTableReferences),
          CustomerOrder,
          PrefetchHooks Function({
            bool purchaseOrderId,
            bool productId,
            bool recipeId,
            bool orderCancellationCausesRefs,
          })
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> purchaseOrderId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> buyerContact = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> unitPriceRupiah = const Value.absent(),
                Value<OrderStatus> status = const Value.absent(),
                Value<String?> cancellationReason = const Value.absent(),
                Value<int?> hppSnapshotRupiah = const Value.absent(),
                Value<DateTime> orderedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                purchaseOrderId: purchaseOrderId,
                productId: productId,
                recipeId: recipeId,
                quantity: quantity,
                buyerContact: buyerContact,
                note: note,
                unitPriceRupiah: unitPriceRupiah,
                status: status,
                cancellationReason: cancellationReason,
                hppSnapshotRupiah: hppSnapshotRupiah,
                orderedAt: orderedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int purchaseOrderId,
                required int productId,
                required int recipeId,
                required int quantity,
                Value<String?> buyerContact = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int unitPriceRupiah,
                Value<OrderStatus> status = const Value.absent(),
                Value<String?> cancellationReason = const Value.absent(),
                Value<int?> hppSnapshotRupiah = const Value.absent(),
                Value<DateTime> orderedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                purchaseOrderId: purchaseOrderId,
                productId: productId,
                recipeId: recipeId,
                quantity: quantity,
                buyerContact: buyerContact,
                note: note,
                unitPriceRupiah: unitPriceRupiah,
                status: status,
                cancellationReason: cancellationReason,
                hppSnapshotRupiah: hppSnapshotRupiah,
                orderedAt: orderedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrdersTable, CustomerOrder>(table),
                  $$OrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                purchaseOrderId = false,
                productId = false,
                recipeId = false,
                orderCancellationCausesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderCancellationCausesRefs) db.orderCancellationCauses,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (purchaseOrderId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.purchaseOrderId,
                            referencedTable: $$OrdersTableReferences
                                ._purchaseOrderIdTable(db),
                            referencedColumn: $$OrdersTableReferences
                                ._purchaseOrderIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (productId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.productId,
                            referencedTable: $$OrdersTableReferences
                                ._productIdTable(db),
                            referencedColumn: $$OrdersTableReferences
                                ._productIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (recipeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.recipeId,
                            referencedTable: $$OrdersTableReferences
                                ._recipeIdTable(db),
                            referencedColumn: $$OrdersTableReferences
                                ._recipeIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderCancellationCausesRefs)
                        await $_getPrefetchedData<
                          CustomerOrder,
                          $OrdersTable,
                          OrderCancellationCause
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderCancellationCausesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderCancellationCausesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      CustomerOrder,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (CustomerOrder, $$OrdersTableReferences),
      CustomerOrder,
      PrefetchHooks Function({
        bool purchaseOrderId,
        bool productId,
        bool recipeId,
        bool orderCancellationCausesRefs,
      })
    >;
typedef $$OrderCancellationCausesTableCreateCompanionBuilder =
    OrderCancellationCausesCompanion Function({
      Value<int> id,
      required int orderId,
      required int ingredientId,
    });
typedef $$OrderCancellationCausesTableUpdateCompanionBuilder =
    OrderCancellationCausesCompanion Function({
      Value<int> id,
      Value<int> orderId,
      Value<int> ingredientId,
    });

final class $$OrderCancellationCausesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OrderCancellationCausesTable,
          OrderCancellationCause
        > {
  $$OrderCancellationCausesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdersTable _orderIdTable(_$AppDatabase db) =>
      db.orders.createAlias('order_cancellation_causes__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) => db
      .ingredients
      .createAlias('order_cancellation_causes__ingredient_id__ingredients__id');

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderCancellationCausesTableFilterComposer
    extends Composer<_$AppDatabase, $OrderCancellationCausesTable> {
  $$OrderCancellationCausesTableFilterComposer({
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

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderCancellationCausesTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderCancellationCausesTable> {
  $$OrderCancellationCausesTableOrderingComposer({
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

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderCancellationCausesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderCancellationCausesTable> {
  $$OrderCancellationCausesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderCancellationCausesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderCancellationCausesTable,
          OrderCancellationCause,
          $$OrderCancellationCausesTableFilterComposer,
          $$OrderCancellationCausesTableOrderingComposer,
          $$OrderCancellationCausesTableAnnotationComposer,
          $$OrderCancellationCausesTableCreateCompanionBuilder,
          $$OrderCancellationCausesTableUpdateCompanionBuilder,
          (OrderCancellationCause, $$OrderCancellationCausesTableReferences),
          OrderCancellationCause,
          PrefetchHooks Function({bool orderId, bool ingredientId})
        > {
  $$OrderCancellationCausesTableTableManager(
    _$AppDatabase db,
    $OrderCancellationCausesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderCancellationCausesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$OrderCancellationCausesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OrderCancellationCausesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<int> ingredientId = const Value.absent(),
              }) => OrderCancellationCausesCompanion(
                id: id,
                orderId: orderId,
                ingredientId: ingredientId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderId,
                required int ingredientId,
              }) => OrderCancellationCausesCompanion.insert(
                id: id,
                orderId: orderId,
                ingredientId: ingredientId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $OrderCancellationCausesTable,
                    OrderCancellationCause
                  >(table),
                  $$OrderCancellationCausesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.orderId,
                        referencedTable:
                            $$OrderCancellationCausesTableReferences
                                ._orderIdTable(db),
                        referencedColumn:
                            $$OrderCancellationCausesTableReferences
                                ._orderIdTable(db)
                                .id,
                      ) as T;
                    }
                    if (ingredientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ingredientId,
                        referencedTable:
                            $$OrderCancellationCausesTableReferences
                                ._ingredientIdTable(db),
                        referencedColumn:
                            $$OrderCancellationCausesTableReferences
                                ._ingredientIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderCancellationCausesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderCancellationCausesTable,
      OrderCancellationCause,
      $$OrderCancellationCausesTableFilterComposer,
      $$OrderCancellationCausesTableOrderingComposer,
      $$OrderCancellationCausesTableAnnotationComposer,
      $$OrderCancellationCausesTableCreateCompanionBuilder,
      $$OrderCancellationCausesTableUpdateCompanionBuilder,
      (OrderCancellationCause, $$OrderCancellationCausesTableReferences),
      OrderCancellationCause,
      PrefetchHooks Function({bool orderId, bool ingredientId})
    >;
typedef $$ProductionSessionsTableCreateCompanionBuilder =
    ProductionSessionsCompanion Function({
      Value<int> id,
      required int purchaseOrderId,
      required DateTime confirmedAt,
      Value<DateTime> createdAt,
    });
typedef $$ProductionSessionsTableUpdateCompanionBuilder =
    ProductionSessionsCompanion Function({
      Value<int> id,
      Value<int> purchaseOrderId,
      Value<DateTime> confirmedAt,
      Value<DateTime> createdAt,
    });

final class $$ProductionSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProductionSessionsTable,
          ProductionSession
        > {
  $$ProductionSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PurchaseOrdersTable _purchaseOrderIdTable(_$AppDatabase db) =>
      db.purchaseOrders.createAlias(
        'production_sessions__purchase_order_id__purchase_orders__id',
      );

  $$PurchaseOrdersTableProcessedTableManager get purchaseOrderId {
    final $_column = $_itemColumn<int>('purchase_order_id')!;

    final manager = $$PurchaseOrdersTableTableManager(
      $_db,
      $_db.purchaseOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ProductionSessionCostsTable,
    List<ProductionSessionCost>
  >
  _productionSessionCostsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.productionSessionCosts,
        aliasName:
            'production_sessions__id__production_session_costs__session_id',
      );

  $$ProductionSessionCostsTableProcessedTableManager
  get productionSessionCostsRefs {
    final manager = $$ProductionSessionCostsTableTableManager(
      $_db,
      $_db.productionSessionCosts,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productionSessionCostsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IngredientUsagesTable, List<IngredientUsage>>
  _ingredientUsagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredientUsages,
    aliasName: 'production_sessions__id__ingredient_usages__session_id',
  );

  $$IngredientUsagesTableProcessedTableManager get ingredientUsagesRefs {
    final manager = $$IngredientUsagesTableTableManager(
      $_db,
      $_db.ingredientUsages,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ingredientUsagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductionSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductionSessionsTable> {
  $$ProductionSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PurchaseOrdersTableFilterComposer get purchaseOrderId {
    final $$PurchaseOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableFilterComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> productionSessionCostsRefs(
    Expression<bool> Function($$ProductionSessionCostsTableFilterComposer f) f,
  ) {
    final $$ProductionSessionCostsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productionSessionCosts,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductionSessionCostsTableFilterComposer(
                $db: $db,
                $table: $db.productionSessionCosts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> ingredientUsagesRefs(
    Expression<bool> Function($$IngredientUsagesTableFilterComposer f) f,
  ) {
    final $$IngredientUsagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientUsages,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientUsagesTableFilterComposer(
            $db: $db,
            $table: $db.ingredientUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductionSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductionSessionsTable> {
  $$ProductionSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PurchaseOrdersTableOrderingComposer get purchaseOrderId {
    final $$PurchaseOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductionSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductionSessionsTable> {
  $$ProductionSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PurchaseOrdersTableAnnotationComposer get purchaseOrderId {
    final $$PurchaseOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> productionSessionCostsRefs<T extends Object>(
    Expression<T> Function($$ProductionSessionCostsTableAnnotationComposer a) f,
  ) {
    final $$ProductionSessionCostsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productionSessionCosts,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductionSessionCostsTableAnnotationComposer(
                $db: $db,
                $table: $db.productionSessionCosts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> ingredientUsagesRefs<T extends Object>(
    Expression<T> Function($$IngredientUsagesTableAnnotationComposer a) f,
  ) {
    final $$IngredientUsagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientUsages,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientUsagesTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredientUsages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductionSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductionSessionsTable,
          ProductionSession,
          $$ProductionSessionsTableFilterComposer,
          $$ProductionSessionsTableOrderingComposer,
          $$ProductionSessionsTableAnnotationComposer,
          $$ProductionSessionsTableCreateCompanionBuilder,
          $$ProductionSessionsTableUpdateCompanionBuilder,
          (ProductionSession, $$ProductionSessionsTableReferences),
          ProductionSession,
          PrefetchHooks Function({
            bool purchaseOrderId,
            bool productionSessionCostsRefs,
            bool ingredientUsagesRefs,
          })
        > {
  $$ProductionSessionsTableTableManager(
    _$AppDatabase db,
    $ProductionSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductionSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductionSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductionSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> purchaseOrderId = const Value.absent(),
                Value<DateTime> confirmedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductionSessionsCompanion(
                id: id,
                purchaseOrderId: purchaseOrderId,
                confirmedAt: confirmedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int purchaseOrderId,
                required DateTime confirmedAt,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductionSessionsCompanion.insert(
                id: id,
                purchaseOrderId: purchaseOrderId,
                confirmedAt: confirmedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductionSessionsTable, ProductionSession>(
                    table,
                  ),
                  $$ProductionSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                purchaseOrderId = false,
                productionSessionCostsRefs = false,
                ingredientUsagesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productionSessionCostsRefs) db.productionSessionCosts,
                    if (ingredientUsagesRefs) db.ingredientUsages,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (purchaseOrderId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.purchaseOrderId,
                            referencedTable: $$ProductionSessionsTableReferences
                                ._purchaseOrderIdTable(db),
                            referencedColumn:
                                $$ProductionSessionsTableReferences
                                    ._purchaseOrderIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productionSessionCostsRefs)
                        await $_getPrefetchedData<
                          ProductionSession,
                          $ProductionSessionsTable,
                          ProductionSessionCost
                        >(
                          currentTable: table,
                          referencedTable: $$ProductionSessionsTableReferences
                              ._productionSessionCostsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductionSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).productionSessionCostsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ingredientUsagesRefs)
                        await $_getPrefetchedData<
                          ProductionSession,
                          $ProductionSessionsTable,
                          IngredientUsage
                        >(
                          currentTable: table,
                          referencedTable: $$ProductionSessionsTableReferences
                              ._ingredientUsagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductionSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientUsagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductionSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductionSessionsTable,
      ProductionSession,
      $$ProductionSessionsTableFilterComposer,
      $$ProductionSessionsTableOrderingComposer,
      $$ProductionSessionsTableAnnotationComposer,
      $$ProductionSessionsTableCreateCompanionBuilder,
      $$ProductionSessionsTableUpdateCompanionBuilder,
      (ProductionSession, $$ProductionSessionsTableReferences),
      ProductionSession,
      PrefetchHooks Function({
        bool purchaseOrderId,
        bool productionSessionCostsRefs,
        bool ingredientUsagesRefs,
      })
    >;
typedef $$ProductionSessionCostsTableCreateCompanionBuilder =
    ProductionSessionCostsCompanion Function({
      Value<int> id,
      required int sessionId,
      required String name,
      required int amountRupiah,
    });
typedef $$ProductionSessionCostsTableUpdateCompanionBuilder =
    ProductionSessionCostsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> name,
      Value<int> amountRupiah,
    });

final class $$ProductionSessionCostsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProductionSessionCostsTable,
          ProductionSessionCost
        > {
  $$ProductionSessionCostsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductionSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.productionSessions.createAlias(
        'production_session_costs__session_id__production_sessions__id',
      );

  $$ProductionSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$ProductionSessionsTableTableManager(
      $_db,
      $_db.productionSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductionSessionCostsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductionSessionCostsTable> {
  $$ProductionSessionCostsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountRupiah => $composableBuilder(
    column: $table.amountRupiah,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductionSessionsTableFilterComposer get sessionId {
    final $$ProductionSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.productionSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionSessionsTableFilterComposer(
            $db: $db,
            $table: $db.productionSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductionSessionCostsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductionSessionCostsTable> {
  $$ProductionSessionCostsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountRupiah => $composableBuilder(
    column: $table.amountRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductionSessionsTableOrderingComposer get sessionId {
    final $$ProductionSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.productionSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.productionSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductionSessionCostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductionSessionCostsTable> {
  $$ProductionSessionCostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountRupiah => $composableBuilder(
    column: $table.amountRupiah,
    builder: (column) => column,
  );

  $$ProductionSessionsTableAnnotationComposer get sessionId {
    final $$ProductionSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.productionSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductionSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.productionSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ProductionSessionCostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductionSessionCostsTable,
          ProductionSessionCost,
          $$ProductionSessionCostsTableFilterComposer,
          $$ProductionSessionCostsTableOrderingComposer,
          $$ProductionSessionCostsTableAnnotationComposer,
          $$ProductionSessionCostsTableCreateCompanionBuilder,
          $$ProductionSessionCostsTableUpdateCompanionBuilder,
          (ProductionSessionCost, $$ProductionSessionCostsTableReferences),
          ProductionSessionCost,
          PrefetchHooks Function({bool sessionId})
        > {
  $$ProductionSessionCostsTableTableManager(
    _$AppDatabase db,
    $ProductionSessionCostsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductionSessionCostsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ProductionSessionCostsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProductionSessionCostsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amountRupiah = const Value.absent(),
              }) => ProductionSessionCostsCompanion(
                id: id,
                sessionId: sessionId,
                name: name,
                amountRupiah: amountRupiah,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String name,
                required int amountRupiah,
              }) => ProductionSessionCostsCompanion.insert(
                id: id,
                sessionId: sessionId,
                name: name,
                amountRupiah: amountRupiah,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ProductionSessionCostsTable,
                    ProductionSessionCost
                  >(table),
                  $$ProductionSessionCostsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$ProductionSessionCostsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn:
                            $$ProductionSessionCostsTableReferences
                                ._sessionIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductionSessionCostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductionSessionCostsTable,
      ProductionSessionCost,
      $$ProductionSessionCostsTableFilterComposer,
      $$ProductionSessionCostsTableOrderingComposer,
      $$ProductionSessionCostsTableAnnotationComposer,
      $$ProductionSessionCostsTableCreateCompanionBuilder,
      $$ProductionSessionCostsTableUpdateCompanionBuilder,
      (ProductionSessionCost, $$ProductionSessionCostsTableReferences),
      ProductionSessionCost,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$IngredientUsagesTableCreateCompanionBuilder =
    IngredientUsagesCompanion Function({
      Value<int> id,
      required int sessionId,
      required int ingredientId,
      required double quantityUsed,
    });
typedef $$IngredientUsagesTableUpdateCompanionBuilder =
    IngredientUsagesCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> ingredientId,
      Value<double> quantityUsed,
    });

final class $$IngredientUsagesTableReferences
    extends
        BaseReferences<_$AppDatabase, $IngredientUsagesTable, IngredientUsage> {
  $$IngredientUsagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductionSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .productionSessions
      .createAlias('ingredient_usages__session_id__production_sessions__id');

  $$ProductionSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$ProductionSessionsTableTableManager(
      $_db,
      $_db.productionSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) => db
      .ingredients
      .createAlias('ingredient_usages__ingredient_id__ingredients__id');

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngredientUsagesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientUsagesTable> {
  $$IngredientUsagesTableFilterComposer({
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

  ColumnFilters<double> get quantityUsed => $composableBuilder(
    column: $table.quantityUsed,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductionSessionsTableFilterComposer get sessionId {
    final $$ProductionSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.productionSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionSessionsTableFilterComposer(
            $db: $db,
            $table: $db.productionSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientUsagesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientUsagesTable> {
  $$IngredientUsagesTableOrderingComposer({
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

  ColumnOrderings<double> get quantityUsed => $composableBuilder(
    column: $table.quantityUsed,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductionSessionsTableOrderingComposer get sessionId {
    final $$ProductionSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.productionSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductionSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.productionSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientUsagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientUsagesTable> {
  $$IngredientUsagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantityUsed => $composableBuilder(
    column: $table.quantityUsed,
    builder: (column) => column,
  );

  $$ProductionSessionsTableAnnotationComposer get sessionId {
    final $$ProductionSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.productionSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductionSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.productionSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientUsagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientUsagesTable,
          IngredientUsage,
          $$IngredientUsagesTableFilterComposer,
          $$IngredientUsagesTableOrderingComposer,
          $$IngredientUsagesTableAnnotationComposer,
          $$IngredientUsagesTableCreateCompanionBuilder,
          $$IngredientUsagesTableUpdateCompanionBuilder,
          (IngredientUsage, $$IngredientUsagesTableReferences),
          IngredientUsage,
          PrefetchHooks Function({bool sessionId, bool ingredientId})
        > {
  $$IngredientUsagesTableTableManager(
    _$AppDatabase db,
    $IngredientUsagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientUsagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientUsagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientUsagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> ingredientId = const Value.absent(),
                Value<double> quantityUsed = const Value.absent(),
              }) => IngredientUsagesCompanion(
                id: id,
                sessionId: sessionId,
                ingredientId: ingredientId,
                quantityUsed: quantityUsed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int ingredientId,
                required double quantityUsed,
              }) => IngredientUsagesCompanion.insert(
                id: id,
                sessionId: sessionId,
                ingredientId: ingredientId,
                quantityUsed: quantityUsed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IngredientUsagesTable, IngredientUsage>(table),
                  $$IngredientUsagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$IngredientUsagesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$IngredientUsagesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (ingredientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ingredientId,
                        referencedTable: $$IngredientUsagesTableReferences
                            ._ingredientIdTable(db),
                        referencedColumn: $$IngredientUsagesTableReferences
                            ._ingredientIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IngredientUsagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientUsagesTable,
      IngredientUsage,
      $$IngredientUsagesTableFilterComposer,
      $$IngredientUsagesTableOrderingComposer,
      $$IngredientUsagesTableAnnotationComposer,
      $$IngredientUsagesTableCreateCompanionBuilder,
      $$IngredientUsagesTableUpdateCompanionBuilder,
      (IngredientUsage, $$IngredientUsagesTableReferences),
      IngredientUsage,
      PrefetchHooks Function({bool sessionId, bool ingredientId})
    >;
typedef $$DailyOperationalCostsTableCreateCompanionBuilder =
    DailyOperationalCostsCompanion Function({
      Value<int> id,
      required String name,
      required int amountRupiah,
      required DateTime date,
      Value<DateTime> createdAt,
    });
typedef $$DailyOperationalCostsTableUpdateCompanionBuilder =
    DailyOperationalCostsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> amountRupiah,
      Value<DateTime> date,
      Value<DateTime> createdAt,
    });

class $$DailyOperationalCostsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyOperationalCostsTable> {
  $$DailyOperationalCostsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountRupiah => $composableBuilder(
    column: $table.amountRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyOperationalCostsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyOperationalCostsTable> {
  $$DailyOperationalCostsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountRupiah => $composableBuilder(
    column: $table.amountRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyOperationalCostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyOperationalCostsTable> {
  $$DailyOperationalCostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountRupiah => $composableBuilder(
    column: $table.amountRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DailyOperationalCostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyOperationalCostsTable,
          DailyOperationalCost,
          $$DailyOperationalCostsTableFilterComposer,
          $$DailyOperationalCostsTableOrderingComposer,
          $$DailyOperationalCostsTableAnnotationComposer,
          $$DailyOperationalCostsTableCreateCompanionBuilder,
          $$DailyOperationalCostsTableUpdateCompanionBuilder,
          (
            DailyOperationalCost,
            BaseReferences<
              _$AppDatabase,
              $DailyOperationalCostsTable,
              DailyOperationalCost
            >,
          ),
          DailyOperationalCost,
          PrefetchHooks Function()
        > {
  $$DailyOperationalCostsTableTableManager(
    _$AppDatabase db,
    $DailyOperationalCostsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyOperationalCostsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DailyOperationalCostsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyOperationalCostsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amountRupiah = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyOperationalCostsCompanion(
                id: id,
                name: name,
                amountRupiah: amountRupiah,
                date: date,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int amountRupiah,
                required DateTime date,
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyOperationalCostsCompanion.insert(
                id: id,
                name: name,
                amountRupiah: amountRupiah,
                date: date,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $DailyOperationalCostsTable,
                    DailyOperationalCost
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyOperationalCostsTable,
                    DailyOperationalCost
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyOperationalCostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyOperationalCostsTable,
      DailyOperationalCost,
      $$DailyOperationalCostsTableFilterComposer,
      $$DailyOperationalCostsTableOrderingComposer,
      $$DailyOperationalCostsTableAnnotationComposer,
      $$DailyOperationalCostsTableCreateCompanionBuilder,
      $$DailyOperationalCostsTableUpdateCompanionBuilder,
      (
        DailyOperationalCost,
        BaseReferences<
          _$AppDatabase,
          $DailyOperationalCostsTable,
          DailyOperationalCost
        >,
      ),
      DailyOperationalCost,
      PrefetchHooks Function()
    >;
typedef $$DailyClosingsTableCreateCompanionBuilder =
    DailyClosingsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<DateTime> closedAt,
      required int totalRevenueRupiah,
      required int totalHppRupiah,
      required int totalOperationalCostRupiah,
      required int totalWasteCostRupiah,
      required int netProfitRupiah,
    });
typedef $$DailyClosingsTableUpdateCompanionBuilder =
    DailyClosingsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<DateTime> closedAt,
      Value<int> totalRevenueRupiah,
      Value<int> totalHppRupiah,
      Value<int> totalOperationalCostRupiah,
      Value<int> totalWasteCostRupiah,
      Value<int> netProfitRupiah,
    });

class $$DailyClosingsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyClosingsTable> {
  $$DailyClosingsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRevenueRupiah => $composableBuilder(
    column: $table.totalRevenueRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalHppRupiah => $composableBuilder(
    column: $table.totalHppRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalOperationalCostRupiah => $composableBuilder(
    column: $table.totalOperationalCostRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalWasteCostRupiah => $composableBuilder(
    column: $table.totalWasteCostRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get netProfitRupiah => $composableBuilder(
    column: $table.netProfitRupiah,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyClosingsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyClosingsTable> {
  $$DailyClosingsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRevenueRupiah => $composableBuilder(
    column: $table.totalRevenueRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalHppRupiah => $composableBuilder(
    column: $table.totalHppRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalOperationalCostRupiah => $composableBuilder(
    column: $table.totalOperationalCostRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalWasteCostRupiah => $composableBuilder(
    column: $table.totalWasteCostRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get netProfitRupiah => $composableBuilder(
    column: $table.netProfitRupiah,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyClosingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyClosingsTable> {
  $$DailyClosingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<int> get totalRevenueRupiah => $composableBuilder(
    column: $table.totalRevenueRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalHppRupiah => $composableBuilder(
    column: $table.totalHppRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalOperationalCostRupiah => $composableBuilder(
    column: $table.totalOperationalCostRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalWasteCostRupiah => $composableBuilder(
    column: $table.totalWasteCostRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<int> get netProfitRupiah => $composableBuilder(
    column: $table.netProfitRupiah,
    builder: (column) => column,
  );
}

class $$DailyClosingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyClosingsTable,
          DailyClosing,
          $$DailyClosingsTableFilterComposer,
          $$DailyClosingsTableOrderingComposer,
          $$DailyClosingsTableAnnotationComposer,
          $$DailyClosingsTableCreateCompanionBuilder,
          $$DailyClosingsTableUpdateCompanionBuilder,
          (
            DailyClosing,
            BaseReferences<_$AppDatabase, $DailyClosingsTable, DailyClosing>,
          ),
          DailyClosing,
          PrefetchHooks Function()
        > {
  $$DailyClosingsTableTableManager(_$AppDatabase db, $DailyClosingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyClosingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyClosingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyClosingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> closedAt = const Value.absent(),
                Value<int> totalRevenueRupiah = const Value.absent(),
                Value<int> totalHppRupiah = const Value.absent(),
                Value<int> totalOperationalCostRupiah = const Value.absent(),
                Value<int> totalWasteCostRupiah = const Value.absent(),
                Value<int> netProfitRupiah = const Value.absent(),
              }) => DailyClosingsCompanion(
                id: id,
                date: date,
                closedAt: closedAt,
                totalRevenueRupiah: totalRevenueRupiah,
                totalHppRupiah: totalHppRupiah,
                totalOperationalCostRupiah: totalOperationalCostRupiah,
                totalWasteCostRupiah: totalWasteCostRupiah,
                netProfitRupiah: netProfitRupiah,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<DateTime> closedAt = const Value.absent(),
                required int totalRevenueRupiah,
                required int totalHppRupiah,
                required int totalOperationalCostRupiah,
                required int totalWasteCostRupiah,
                required int netProfitRupiah,
              }) => DailyClosingsCompanion.insert(
                id: id,
                date: date,
                closedAt: closedAt,
                totalRevenueRupiah: totalRevenueRupiah,
                totalHppRupiah: totalHppRupiah,
                totalOperationalCostRupiah: totalOperationalCostRupiah,
                totalWasteCostRupiah: totalWasteCostRupiah,
                netProfitRupiah: netProfitRupiah,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyClosingsTable, DailyClosing>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyClosingsTable,
                    DailyClosing
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyClosingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyClosingsTable,
      DailyClosing,
      $$DailyClosingsTableFilterComposer,
      $$DailyClosingsTableOrderingComposer,
      $$DailyClosingsTableAnnotationComposer,
      $$DailyClosingsTableCreateCompanionBuilder,
      $$DailyClosingsTableUpdateCompanionBuilder,
      (
        DailyClosing,
        BaseReferences<_$AppDatabase, $DailyClosingsTable, DailyClosing>,
      ),
      DailyClosing,
      PrefetchHooks Function()
    >;
typedef $$CapitalEntriesTableCreateCompanionBuilder =
    CapitalEntriesCompanion Function({
      Value<int> id,
      required CapitalEntryKind kind,
      required int amountRupiah,
      Value<String?> note,
      required DateTime recordedAt,
      Value<DateTime> createdAt,
    });
typedef $$CapitalEntriesTableUpdateCompanionBuilder =
    CapitalEntriesCompanion Function({
      Value<int> id,
      Value<CapitalEntryKind> kind,
      Value<int> amountRupiah,
      Value<String?> note,
      Value<DateTime> recordedAt,
      Value<DateTime> createdAt,
    });

class $$CapitalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CapitalEntriesTable> {
  $$CapitalEntriesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<CapitalEntryKind, CapitalEntryKind, int>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amountRupiah => $composableBuilder(
    column: $table.amountRupiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CapitalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CapitalEntriesTable> {
  $$CapitalEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountRupiah => $composableBuilder(
    column: $table.amountRupiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CapitalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CapitalEntriesTable> {
  $$CapitalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CapitalEntryKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amountRupiah => $composableBuilder(
    column: $table.amountRupiah,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CapitalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CapitalEntriesTable,
          CapitalEntry,
          $$CapitalEntriesTableFilterComposer,
          $$CapitalEntriesTableOrderingComposer,
          $$CapitalEntriesTableAnnotationComposer,
          $$CapitalEntriesTableCreateCompanionBuilder,
          $$CapitalEntriesTableUpdateCompanionBuilder,
          (
            CapitalEntry,
            BaseReferences<_$AppDatabase, $CapitalEntriesTable, CapitalEntry>,
          ),
          CapitalEntry,
          PrefetchHooks Function()
        > {
  $$CapitalEntriesTableTableManager(
    _$AppDatabase db,
    $CapitalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CapitalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CapitalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CapitalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<CapitalEntryKind> kind = const Value.absent(),
                Value<int> amountRupiah = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CapitalEntriesCompanion(
                id: id,
                kind: kind,
                amountRupiah: amountRupiah,
                note: note,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required CapitalEntryKind kind,
                required int amountRupiah,
                Value<String?> note = const Value.absent(),
                required DateTime recordedAt,
                Value<DateTime> createdAt = const Value.absent(),
              }) => CapitalEntriesCompanion.insert(
                id: id,
                kind: kind,
                amountRupiah: amountRupiah,
                note: note,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CapitalEntriesTable, CapitalEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CapitalEntriesTable,
                    CapitalEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CapitalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CapitalEntriesTable,
      CapitalEntry,
      $$CapitalEntriesTableFilterComposer,
      $$CapitalEntriesTableOrderingComposer,
      $$CapitalEntriesTableAnnotationComposer,
      $$CapitalEntriesTableCreateCompanionBuilder,
      $$CapitalEntriesTableUpdateCompanionBuilder,
      (
        CapitalEntry,
        BaseReferences<_$AppDatabase, $CapitalEntriesTable, CapitalEntry>,
      ),
      CapitalEntry,
      PrefetchHooks Function()
    >;
typedef $$BackupLogsTableCreateCompanionBuilder = BackupLogsCompanion Function({
  Value<int> id,
  required String filePath,
  required BackupFormat format,
  required BackupTrigger trigger,
  Value<DateTime> createdAt,
});
typedef $$BackupLogsTableUpdateCompanionBuilder = BackupLogsCompanion Function({
  Value<int> id,
  Value<String> filePath,
  Value<BackupFormat> format,
  Value<BackupTrigger> trigger,
  Value<DateTime> createdAt,
});

class $$BackupLogsTableFilterComposer
    extends Composer<_$AppDatabase, $BackupLogsTable> {
  $$BackupLogsTableFilterComposer({
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

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BackupFormat, BackupFormat, int> get format =>
      $composableBuilder(
        column: $table.format,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<BackupTrigger, BackupTrigger, int>
  get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BackupLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupLogsTable> {
  $$BackupLogsTableOrderingComposer({
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

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BackupLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupLogsTable> {
  $$BackupLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BackupFormat, int> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BackupTrigger, int> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BackupLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BackupLogsTable,
          BackupLog,
          $$BackupLogsTableFilterComposer,
          $$BackupLogsTableOrderingComposer,
          $$BackupLogsTableAnnotationComposer,
          $$BackupLogsTableCreateCompanionBuilder,
          $$BackupLogsTableUpdateCompanionBuilder,
          (
            BackupLog,
            BaseReferences<_$AppDatabase, $BackupLogsTable, BackupLog>,
          ),
          BackupLog,
          PrefetchHooks Function()
        > {
  $$BackupLogsTableTableManager(_$AppDatabase db, $BackupLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<BackupFormat> format = const Value.absent(),
                Value<BackupTrigger> trigger = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BackupLogsCompanion(
                id: id,
                filePath: filePath,
                format: format,
                trigger: trigger,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String filePath,
                required BackupFormat format,
                required BackupTrigger trigger,
                Value<DateTime> createdAt = const Value.absent(),
              }) => BackupLogsCompanion.insert(
                id: id,
                filePath: filePath,
                format: format,
                trigger: trigger,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BackupLogsTable, BackupLog>(table),
                  BaseReferences<_$AppDatabase, $BackupLogsTable, BackupLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BackupLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BackupLogsTable,
      BackupLog,
      $$BackupLogsTableFilterComposer,
      $$BackupLogsTableOrderingComposer,
      $$BackupLogsTableAnnotationComposer,
      $$BackupLogsTableCreateCompanionBuilder,
      $$BackupLogsTableUpdateCompanionBuilder,
      (BackupLog, BaseReferences<_$AppDatabase, $BackupLogsTable, BackupLog>),
      BackupLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IngredientCategoriesTableTableManager get ingredientCategories =>
      $$IngredientCategoriesTableTableManager(_db, _db.ingredientCategories);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$PurchaseBatchesTableTableManager get purchaseBatches =>
      $$PurchaseBatchesTableTableManager(_db, _db.purchaseBatches);
  $$IngredientPurchasesTableTableManager get ingredientPurchases =>
      $$IngredientPurchasesTableTableManager(_db, _db.ingredientPurchases);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeItemsTableTableManager get recipeItems =>
      $$RecipeItemsTableTableManager(_db, _db.recipeItems);
  $$PurchaseOrdersTableTableManager get purchaseOrders =>
      $$PurchaseOrdersTableTableManager(_db, _db.purchaseOrders);
  $$PoProductQuotasTableTableManager get poProductQuotas =>
      $$PoProductQuotasTableTableManager(_db, _db.poProductQuotas);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderCancellationCausesTableTableManager get orderCancellationCauses =>
      $$OrderCancellationCausesTableTableManager(
        _db,
        _db.orderCancellationCauses,
      );
  $$ProductionSessionsTableTableManager get productionSessions =>
      $$ProductionSessionsTableTableManager(_db, _db.productionSessions);
  $$ProductionSessionCostsTableTableManager get productionSessionCosts =>
      $$ProductionSessionCostsTableTableManager(
        _db,
        _db.productionSessionCosts,
      );
  $$IngredientUsagesTableTableManager get ingredientUsages =>
      $$IngredientUsagesTableTableManager(_db, _db.ingredientUsages);
  $$DailyOperationalCostsTableTableManager get dailyOperationalCosts =>
      $$DailyOperationalCostsTableTableManager(_db, _db.dailyOperationalCosts);
  $$DailyClosingsTableTableManager get dailyClosings =>
      $$DailyClosingsTableTableManager(_db, _db.dailyClosings);
  $$CapitalEntriesTableTableManager get capitalEntries =>
      $$CapitalEntriesTableTableManager(_db, _db.capitalEntries);
  $$BackupLogsTableTableManager get backupLogs =>
      $$BackupLogsTableTableManager(_db, _db.backupLogs);
}
