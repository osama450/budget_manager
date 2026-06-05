class CategoryModel {
  final String id;
  final String name;
  final double allocated;
  final int order;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.allocated,
    this.order = 0,
  });

  CategoryModel copyWith({String? name, double? allocated, int? order}) {
    return CategoryModel(
      id: id,
      name: name ?? this.name,
      allocated: allocated ?? this.allocated,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'allocated': allocated,
        'order': order,
      };

  factory CategoryModel.fromMap(Map map) => CategoryModel(
        id: map['id'] as String,
        name: map['name'] as String? ?? '',
        allocated: (map['allocated'] as num?)?.toDouble() ?? 0,
        order: (map['order'] as num?)?.toInt() ?? 0,
      );
}
