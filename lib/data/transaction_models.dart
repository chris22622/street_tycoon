class TransactionHistory {
  final List<Transaction> transactions;

  const TransactionHistory({
    required this.transactions,
  });

  factory TransactionHistory.initial() {
    return const TransactionHistory(transactions: []);
  }

  TransactionHistory addTransaction(Transaction transaction) {
    final newTransactions = [transaction, ...transactions];
    // Keep only the last 100 transactions to prevent memory issues
    final limitedTransactions = newTransactions.take(100).toList();
    return TransactionHistory(transactions: limitedTransactions);
  }

  List<Transaction> get recentTransactions => transactions.take(20).toList();

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((t) => Transaction.fromJson(t))
          .toList() ?? [],
    );
  }
}

class Transaction {
  final String id;
  final String type; // 'buy' or 'sell'
  final String item;
  final int quantity;
  final int pricePerUnit;
  final int totalAmount;
  final String area;
  final DateTime timestamp;

  const Transaction({
    required this.id,
    required this.type,
    required this.item,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalAmount,
    required this.area,
    required this.timestamp,
  });

  String get emoji {
    switch (item.toLowerCase()) {
      case 'weed': return '🌿';
      case 'speed': return '⚡';
      case 'ludes': return '💊';
      case 'acid': return '🧪';
      case 'pcp': return '☠️';
      case 'heroin': return '💉';
      case 'cocaine': return '❄️';
      case 'ecstasy': return '💙';
      default: return '📦';
    }
  }

  String get displayText {
    final action = type == 'buy' ? 'Bought' : 'Sold';
    return '$emoji $action ${quantity}x $item @ \$${pricePerUnit.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} each';
  }

  String get totalText {
    final sign = type == 'buy' ? '-' : '+';
    return '$sign\$${totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'item': item,
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
      'totalAmount': totalAmount,
      'area': area,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      item: json['item'],
      quantity: json['quantity'],
      pricePerUnit: json['pricePerUnit'],
      totalAmount: json['totalAmount'],
      area: json['area'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}
