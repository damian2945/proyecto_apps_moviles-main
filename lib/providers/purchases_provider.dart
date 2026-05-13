import 'package:flutter/foundation.dart';
import '../models/purchase.dart';

class PurchasesProvider with ChangeNotifier {
  final List<Purchase> _purchases = [];

  List<Purchase> get purchases => [..._purchases];

  // Obtener compras de un cliente específico
  List<Purchase> getPurchasesByEmail(String email) {
    return _purchases.where((purchase) => purchase.clienteEmail == email).toList();
  }

  // Obtener todas las compras (para el admin)
  List<Purchase> get allPurchases => [..._purchases];

  int get purchasesCount => _purchases.length;

  double get totalAmount {
    return _purchases.fold(0.0, (sum, purchase) => sum + purchase.total);
  }

  void addPurchase(Purchase purchase) {
    _purchases.insert(0, purchase); // Agregar al inicio
    notifyListeners();
  }

  // Actualizar estado de un pedido (solo admin)
  void updatePurchaseStatus(String purchaseId, String newStatus) {
    final index = _purchases.indexWhere((purchase) => purchase.id == purchaseId);
    if (index != -1) {
      _purchases[index].updateEstado(newStatus);
      notifyListeners();
    }
  }

  // Obtener compra por ID
  Purchase? getPurchaseById(String id) {
    try {
      return _purchases.firstWhere((purchase) => purchase.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtener compras por estado
  List<Purchase> getPurchasesByStatus(String status) {
    return _purchases.where((purchase) => purchase.estado == status).toList();
  }

  void clearPurchases() {
    _purchases.clear();
    notifyListeners();
  }
}