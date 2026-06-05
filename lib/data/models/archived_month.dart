class ArchivedCategory {
  final String name;
  final double allocated;
  final double spent;
  final double suggested;

  const ArchivedCategory({
    required this.name,
    required this.allocated,
    required this.spent,
    required this.suggested,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'allocated': allocated,
        'spent': spent,
        'suggested': suggested,
      };

  factory ArchivedCategory.fromMap(Map map) => ArchivedCategory(
        name: map['name'] as String? ?? '',
        allocated: (map['allocated'] as num?)?.toDouble() ?? 0,
        spent: (map['spent'] as num?)?.toDouble() ?? 0,
        suggested: (map['suggested'] as num?)?.toDouble() ?? 0,
      );
}

class ArchivedMonth {
  final String id; // 'YYYY-MM'
  final double openingBalance;
  final double totalAllocated;
  final double totalSpent;
  final double remaining;
  final List<ArchivedCategory> categories;
  final int transactionCount;
  final int archivedAtMillis;

  const ArchivedMonth({
    required this.id,
    required this.openingBalance,
    required this.totalAllocated,
    required this.totalSpent,
    required this.remaining,
    required this.categories,
    required this.transactionCount,
    required this.archivedAtMillis,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'openingBalance': openingBalance,
        'totalAllocated': totalAllocated,
        'totalSpent': totalSpent,
        'remaining': remaining,
        'categories': categories.map((c) => c.toMap()).toList(),
        'transactionCount': transactionCount,
        'archivedAtMillis': archivedAtMillis,
      };

  factory ArchivedMonth.fromMap(Map map) => ArchivedMonth(
        id: map['id'] as String? ?? '',
        openingBalance: (map['openingBalance'] as num?)?.toDouble() ?? 0,
        totalAllocated: (map['totalAllocated'] as num?)?.toDouble() ?? 0,
        totalSpent: (map['totalSpent'] as num?)?.toDouble() ?? 0,
        remaining: (map['remaining'] as num?)?.toDouble() ?? 0,
        categories: ((map['categories'] as List?) ?? const [])
            .map((e) => ArchivedCategory.fromMap(e as Map))
            .toList(),
        transactionCount: (map['transactionCount'] as num?)?.toInt() ?? 0,
        archivedAtMillis: (map['archivedAtMillis'] as num?)?.toInt() ?? 0,
      );
}
