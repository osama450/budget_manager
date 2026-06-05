class TransactionModel {
  final String id;
  final String categoryId;
  final double amount;
  final DateTime date;
  final String? note;
  final String monthId; // owning cycle 'YYYY-MM'

  const TransactionModel({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.monthId,
    this.note,
  });

  TransactionModel copyWith({
    String? categoryId,
    double? amount,
    DateTime? date,
    String? note,
  }) {
    return TransactionModel(
      id: id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      monthId: monthId,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'categoryId': categoryId,
        'amount': amount,
        'date': date.millisecondsSinceEpoch,
        'note': note,
        'monthId': monthId,
      };

  factory TransactionModel.fromMap(Map map) => TransactionModel(
        id: map['id'] as String,
        categoryId: map['categoryId'] as String? ?? '',
        amount: (map['amount'] as num?)?.toDouble() ?? 0,
        date: DateTime.fromMillisecondsSinceEpoch(
            (map['date'] as num?)?.toInt() ?? 0),
        note: map['note'] as String?,
        monthId: map['monthId'] as String? ?? '',
      );
}
