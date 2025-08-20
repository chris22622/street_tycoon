import 'dart:math';

class Formatters {
  static String money(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toString();
    }
  }

  static String moneyFull(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  static String percentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  static String duration(int days) {
    if (days == 1) {
      return '1 day';
    } else {
      return '$days days';
    }
  }

  static String heatLevel(int heat) {
    if (heat <= 20) return 'Low';
    if (heat <= 50) return 'Medium';
    if (heat <= 75) return 'High';
    return 'Critical';
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
}
