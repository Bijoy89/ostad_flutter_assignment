import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';

class TransactionViewModel extends ChangeNotifier {
  List<TransactionModel> _transactions = [];
  static const String _storageKey = 'transactions';
  final Uuid _uuid = const Uuid();

  List<TransactionModel> get transactions =>
      List.unmodifiable(_transactions.reversed.toList());

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalBalance => totalIncome - totalExpense;

  TransactionViewModel() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      _transactions = TransactionModel.decodeList(jsonString);
      notifyListeners();
    }
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      TransactionModel.encodeList(_transactions),
    );
  }

  Future<void> addTransaction({
    required String title,
    required double amount,
    required DateTime date,
    required TransactionType type,
  }) async {
    final newTransaction = TransactionModel(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      date: date,
      type: type,
    );
    _transactions.add(newTransaction);
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _saveTransactions();
    notifyListeners();
  }
}