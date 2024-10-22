class LogisticItem {
  final String name;
  final String quantity;
  final bool isChecked;

  LogisticItem({
    required this.name,
    required this.quantity,
    this.isChecked = false,
  });

  LogisticItem copyWith({String? name, String? quantity, bool? isChecked}) {
    return LogisticItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
