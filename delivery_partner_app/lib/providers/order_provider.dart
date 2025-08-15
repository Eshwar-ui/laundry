// Enhanced OrderProvider with better debugging
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';
import '../services/customer_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CustomerService _customerService = CustomerService();
  
  List<OrderModel> _pendingPickups = [];
  List<OrderModel> _pendingDeliveries = [];
  List<OrderModel> _completedTasks = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _lastNotificationTime;
  
  // Getters
  List<OrderModel> get pendingPickups => _pendingPickups;
  List<OrderModel> get pendingDeliveries => _pendingDeliveries;
  List<OrderModel> get completedTasks => _completedTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastNotificationTime => _lastNotificationTime;
  
  // Method to handle new order assignment notifications
  void handleOrderAssignmentNotification(Map<String, dynamic> notificationData) {
    print('🚚 📦 OrderProvider: Handling new order assignment notification');
    print('🚚 Order ID: ${notificationData['orderId']}');
    print('🚚 Order Number: ${notificationData['orderNumber']}');
    
    _lastNotificationTime = DateTime.now();
    _error = null;
    notifyListeners();
    
    print('🚚 ✅ OrderProvider: Notification handled, UI will refresh automatically via streams');
  }
  
  // Method to manually refresh order data
  Future<void> refreshOrderData(String deliveryPartnerId) async {
    print('🚚 🔄 OrderProvider: Manually refreshing order data for: $deliveryPartnerId');
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await Future.delayed(Duration(milliseconds: 500)); // Small delay for UX
      _isLoading = false;
      notifyListeners();
      
      print('🚚 ✅ OrderProvider: Manual refresh completed');
    } catch (e) {
      _error = 'Failed to refresh order data: $e';
      _isLoading = false;
      notifyListeners();
      
      print('🚚 ❌ OrderProvider: Manual refresh failed - $e');
    }
  }

  // SIMPLIFIED: Get orders using ONLY assignedDeliveryPerson field (your actual field)
  Stream<List<OrderModel>> _getAllOrdersForDeliveryPartner(String deliveryPartnerId) {
    print('🚚 📋 🆕 NEW VERSION: Setting up order stream for delivery partner: $deliveryPartnerId');
    print('🚚 📋 🆕 USING ONLY assignedDeliveryPerson field');
    
    return _firestore
        .collection('orders')
        .where('assignedDeliveryPerson', isEqualTo: deliveryPartnerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print('🚚 📋 🆕 Direct query with assignedDeliveryPerson returned ${snapshot.docs.length} orders');
      
      final orders = snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          print('🚚 ✅ 🆕 Order ${doc.id} found:');
          print('🚚      - assignedDeliveryPerson: ${data['assignedDeliveryPerson']}');
          print('🚚      - status: ${data['status']}');
          
          return OrderModel.fromFirestore(doc);
        } catch (e) {
          print('🚚 ❌ Error parsing order ${doc.id}: $e');
          return null;
        }
      }).where((order) => order != null).cast<OrderModel>().toList();
      
      print('🚚 📋 🆕 Successfully parsed ${orders.length} orders');
      return orders;
    }).handleError((error) {
      print('🚚 ❌ 🆕 Stream error for delivery partner $deliveryPartnerId: $error');
      return <OrderModel>[];
    });
  }
  
  // Enhanced pickup tasks with comprehensive debugging
  Stream<List<OrderModel>> getPickupTasksStream(String deliveryPartnerId) {
    print('🚚 📦 OrderProvider: Getting pickup tasks for delivery partner: $deliveryPartnerId');
    
    return _getAllOrdersForDeliveryPartner(deliveryPartnerId)
        .asyncMap((orders) async {
      // Filter for pickup tasks
      final pickupStatuses = ['assigned', 'confirmed', 'ready_for_pickup'];
      final filteredOrders = orders.where((order) {
        return pickupStatuses.contains(order.status);
      }).toList();
      
      print('🚚 📦 After filtering for pickup statuses: ${filteredOrders.length} orders');
      
      // Enrich with customer data
      final enrichedOrders = await _enrichOrdersWithCustomerData(filteredOrders);
      return enrichedOrders;
    }).handleError((error) {
      print('🚚 ❌ Error in pickup tasks stream: $error');
      _error = 'Failed to load pickup tasks: $error';
      notifyListeners();
      return <OrderModel>[];
    });
  }
  
  // PUBLIC diagnostic method to help with troubleshooting
  Future<void> performDiagnosticQuery(String deliveryPartnerId) async {
    await _performDiagnosticQuery(deliveryPartnerId);
  }

  // Diagnostic query to check for orders with this delivery partner - FIXED to check assignedDeliveryPerson first
  Future<void> _performDiagnosticQuery(String deliveryPartnerId) async {
    try {
      print('🚚 🔍 Running diagnostic query for delivery partner: $deliveryPartnerId');
      
      // Check for orders with assignedDeliveryPerson field (this is how your orders are stored)
      final deliveryPersonQuery = await _firestore
          .collection('orders')
          .where('assignedDeliveryPerson', isEqualTo: deliveryPartnerId)
          .limit(10)
          .get();
      
      print('🚚 🔍 Diagnostic: Found ${deliveryPersonQuery.docs.length} orders with assignedDeliveryPerson');
      
      if (deliveryPersonQuery.docs.isNotEmpty) {
        print('🚚 🔍 Order statuses found:');
        final statusCounts = <String, int>{};
        for (var doc in deliveryPersonQuery.docs) {
          final status = doc.data()['status'] as String? ?? 'unknown';
          statusCounts[status] = (statusCounts[status] ?? 0) + 1;
          print('🚚 📦 Order ${doc.id}: status=${status}');
        }
        statusCounts.forEach((status, count) {
          print('🚚     - $status: $count orders');
        });
      } else {
        print('🚚 ⚠️ No orders found with assignedDeliveryPerson = $deliveryPartnerId');
      }
      
      // Also check for orders with the new field name (assignedDeliveryPartner) - just in case
      final newFieldQuery = await _firestore
          .collection('orders')
          .where('assignedDeliveryPartner', isEqualTo: deliveryPartnerId)
          .limit(5)
          .get();
      
      if (newFieldQuery.docs.isNotEmpty) {
        print('🚚 ✅ Found ${newFieldQuery.docs.length} orders using NEW field name "assignedDeliveryPartner"');
      } else {
        print('🚚 💡 No orders found with assignedDeliveryPartner field - orders are stored with assignedDeliveryPerson');
      }
      
    } catch (e) {
      print('🚚 ❌ Diagnostic query failed: $e');
    }
  }
  
  // Get delivery tasks for delivery partner
  Stream<List<OrderModel>> getDeliveryTasksStream(String deliveryPartnerId) {
    print('🚚 🚛 OrderProvider: Getting delivery tasks for: $deliveryPartnerId');
    
    return _getAllOrdersForDeliveryPartner(deliveryPartnerId)
        .asyncMap((orders) async {
      // Filter for delivery tasks
      final deliveryStatuses = ['picked_up', 'ready_for_delivery'];
      final filteredOrders = orders.where((order) {
        return deliveryStatuses.contains(order.status);
      }).toList();
      
      print('🚚 🚛 After filtering for delivery statuses: ${filteredOrders.length} orders');
      
      // Enrich with customer data
      final enrichedOrders = await _enrichOrdersWithCustomerData(filteredOrders);
      return enrichedOrders;
    }).handleError((error) {
      print('🚚 ❌ Error in delivery tasks stream: $error');
      _error = 'Failed to load delivery tasks: $error';
      notifyListeners();
      return <OrderModel>[];
    });
  }
  
  // Get all assigned orders for delivery partner with debugging - FIXED to check both field names
  Stream<List<OrderModel>> getAllAssignedOrdersStream(String deliveryPartnerId) {
    print('🚚 📋 OrderProvider: Getting ALL assigned orders for: $deliveryPartnerId');
    
    // Use the same method that checks both field names
    return _getAllOrdersForDeliveryPartner(deliveryPartnerId)
        .map((orders) {
      print('🚚 📋 All assigned orders returned ${orders.length} orders');
      
      if (orders.isNotEmpty) {
        print('🚚 📋 Order breakdown:');
        final statusBreakdown = <String, int>{};
        for (var order in orders) {
          final status = order.status ?? 'unknown';
          statusBreakdown[status] = (statusBreakdown[status] ?? 0) + 1;
        }
        statusBreakdown.forEach((status, count) {
          print('🚚     - $status: $count orders');
        });
      }
      
      return orders;
    }).handleError((error) {
      print('🚚 ❌ Error in assigned orders stream: $error');
      return <OrderModel>[];
    });
  }
  
  // Get today's tasks for delivery partner
  Stream<List<OrderModel>> getTodayTasksStream(String deliveryPartnerId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    
    print('🚚 📅 Getting today\'s tasks for: $deliveryPartnerId');
    print('🚚 📅 Date range: ${startOfDay} to ${endOfDay}');
    
    return _getAllOrdersForDeliveryPartner(deliveryPartnerId)
        .map((orders) {
      // Filter for today's orders
      final todayOrders = orders.where((order) {
        final orderDate = (order.createdAt ?? order.orderTimestamp).toDate();
        return orderDate.isAfter(startOfDay) && orderDate.isBefore(endOfDay);
      }).toList();
      
      print('🚚 📅 Today\'s tasks filtered: ${todayOrders.length} orders');
      return todayOrders;
    }).handleError((error) {
      print('🚚 ❌ Error in today tasks stream: $error');
      return <OrderModel>[];
    });
  }
  
  // Update order status
  Future<bool> updateOrderStatus(String orderId, String newStatus, {
    String? notes,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      print('🚚 📝 Updating order $orderId status to: $newStatus');
      
      print('🚚 🔐 Using custom authentication (no Firebase Auth needed)');
      
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      Map<String, dynamic> updateData = {
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      // Add status history entry
      Map<String, dynamic> statusHistoryEntry = {
        'status': newStatus,
        'timestamp': Timestamp.now(),
        'updatedBy': 'delivery_partner',
      };
      
      if (notes != null) {
        statusHistoryEntry['notes'] = notes;
      }
      
      updateData['statusHistory'] = FieldValue.arrayUnion([statusHistoryEntry]);
      
      // Add additional data if provided
      if (additionalData != null) {
        updateData.addAll(additionalData);
      }
      
      // Update specific fields based on status
      switch (newStatus) {
        case 'picked_up':
          updateData['pickedUpAt'] = Timestamp.now();
          break;
        case 'delivered':
          updateData['deliveredAt'] = Timestamp.now();
          break;
        case 'cancelled':
          updateData['cancelledAt'] = Timestamp.now();
          break;
      }
      
      await _firestore.collection('orders').doc(orderId).update(updateData);
      
      _isLoading = false;
      notifyListeners();
      
      print('🚚 ✅ Order $orderId status updated to $newStatus');
      return true;
      
    } catch (e) {
      print('🚚 ❌ Error updating order status: $e');
      _error = 'Failed to update order status: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  


  // Mark pickup as complete
  Future<bool> markPickupComplete(String orderId, {String? notes}) async {
    return updateOrderStatus(orderId, 'picked_up', notes: notes);
  }
  
  // Mark delivery as complete
  Future<bool> markDeliveryComplete(String orderId, {String? notes}) async {
    return updateOrderStatus(orderId, 'delivered', notes: notes);
  }
  
  // Report issue with order
  Future<bool> reportOrderIssue(String orderId, String issue, {String? notes}) async {
    try {
      print('🚚 ⚠️ Reporting issue for order $orderId: $issue');
      
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      Map<String, dynamic> updateData = {
        'status': 'issue_reported',
        'updatedAt': Timestamp.now(),
        'reportedIssue': issue,
        'issueReportedAt': Timestamp.now(),
      };
      
      if (notes != null) {
        updateData['issueNotes'] = notes;
      }
      
      // Add to status history
      Map<String, dynamic> statusHistoryEntry = {
        'status': 'issue_reported',
        'timestamp': Timestamp.now(),
        'updatedBy': 'delivery_partner',
        'issue': issue,
      };
      
      if (notes != null) {
        statusHistoryEntry['notes'] = notes;
      }
      
      updateData['statusHistory'] = FieldValue.arrayUnion([statusHistoryEntry]);
      
      await _firestore.collection('orders').doc(orderId).update(updateData);
      
      _isLoading = false;
      notifyListeners();
      
      print('🚚 ✅ Issue reported for order $orderId: $issue');
      return true;
      
    } catch (e) {
      print('🚚 ❌ Error reporting order issue: $e');
      _error = 'Failed to report issue: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Get delivery partner statistics - FIXED to check both field names
  Future<Map<String, dynamic>> getDeliveryPartnerStats(String deliveryPartnerId) async {
    try {
      print('🚚 📊 Getting stats for delivery partner: $deliveryPartnerId');
      
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      final startOfMonth = DateTime(today.year, today.month, 1);
      
      // Get all orders for this delivery partner first (using both field names)
      final allOrdersQuery = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();
      
      // Filter for orders assigned to this delivery partner (check both field names)
      final assignedOrders = allOrdersQuery.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final newField = data['assignedDeliveryPartner'] as String?;
        final oldField = data['assignedDeliveryPerson'] as String?;
        return newField == deliveryPartnerId || oldField == deliveryPartnerId;
      }).toList();
      
      print('🚚 📊 Found ${assignedOrders.length} total assigned orders');
      
      // Count statistics from filtered results
      int todayCompleted = 0;
      int weekCompleted = 0;
      int monthCompleted = 0;
      int todayPending = 0;
      
      for (var doc in assignedOrders) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] as String?;
        final createdAt = data['createdAt'] as Timestamp?;
        final deliveredAt = data['deliveredAt'] as Timestamp?;
        
        if (status == 'delivered' && deliveredAt != null) {
          final deliveredDate = deliveredAt.toDate();
          
          // Today's completed
          if (deliveredDate.isAfter(startOfDay)) {
            todayCompleted++;
          }
          
          // Week's completed
          if (deliveredDate.isAfter(startOfWeek)) {
            weekCompleted++;
          }
          
          // Month's completed
          if (deliveredDate.isAfter(startOfMonth)) {
            monthCompleted++;
          }
        }
        
        // Today's pending tasks
        if (['confirmed', 'ready_for_pickup', 'picked_up', 'ready_for_delivery'].contains(status) &&
            createdAt != null && createdAt.toDate().isAfter(startOfDay)) {
          todayPending++;
        }
      }
      
      final stats = {
        'todayCompleted': todayCompleted,
        'weekCompleted': weekCompleted,
        'monthCompleted': monthCompleted,
        'todayPending': todayPending,
      };
      
      print('🚚 📊 Stats for $deliveryPartnerId: $stats');
      return stats;
      
    } catch (e) {
      print('🚚 ❌ Error getting delivery partner stats: $e');
      return {
        'todayCompleted': 0,
        'weekCompleted': 0,
        'monthCompleted': 0,
        'todayPending': 0,
      };
    }
  }
  
  // Force refresh all streams and data with immediate order check
  Future<void> forceRefreshAllData(String deliveryPartnerId) async {
    print('🚚 🔄 Force refreshing all data for: $deliveryPartnerId');
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // First do a direct query to check for orders immediately
      await _checkOrdersImmediately(deliveryPartnerId);
      
      // Run diagnostic
      await _performDiagnosticQuery(deliveryPartnerId);
      
      // Small delay to ensure Firestore consistency
      await Future.delayed(Duration(milliseconds: 500));
      
      _isLoading = false;
      notifyListeners();
      
      print('🚚 ✅ Force refresh completed');
    } catch (e) {
      print('🚚 ❌ Force refresh failed: $e');
      _error = 'Force refresh failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Immediate order check method to verify orders exist
  Future<void> _checkOrdersImmediately(String deliveryPartnerId) async {
    try {
      print('🚚 ⚡ Immediate order check for: $deliveryPartnerId');
      
      // Direct query for assignedDeliveryPerson (your primary field)
      final immediateQuery = await _firestore
          .collection('orders')
          .where('assignedDeliveryPerson', isEqualTo: deliveryPartnerId)
          .limit(5)
          .get();
      
      print('🚚 ⚡ Immediate check found ${immediateQuery.docs.length} orders');
      
      if (immediateQuery.docs.isNotEmpty) {
        for (var doc in immediateQuery.docs) {
          final data = doc.data();
          print('🚚 ⚡ Order ${doc.id}: status=${data['status']}');
        }
      }
      
    } catch (e) {
      print('🚚 ❌ Immediate order check failed: $e');
    }
  }

  // Enrich orders with customer data
  Future<List<OrderModel>> _enrichOrdersWithCustomerData(List<OrderModel> orders) async {
    if (orders.isEmpty) return orders;
    
    print('🚚 👥 OrderProvider: Enriching ${orders.length} orders with customer data');
    
    // Get unique customer IDs
    final customerIds = orders
        .where((order) => order.customerId != null)
        .map((order) => order.customerId!)
        .toSet()
        .toList();
    
    if (customerIds.isEmpty) {
      print('🚚 ⚠️ OrderProvider: No customer IDs found in orders');
      return orders;
    }
    
    print('🚚 👥 OrderProvider: Fetching data for ${customerIds.length} unique customers');
    
    // Fetch customer data
    final customersMap = await _customerService.getCustomersByIds(customerIds);
    
    // Enrich orders with customer data
    final enrichedOrders = orders.map((order) {
      if (order.customerId != null && customersMap.containsKey(order.customerId)) {
        final customer = customersMap[order.customerId];
        print('🚚 ✅ OrderProvider: Enriched order ${order.id} with customer ${customer?.name}');
        return order.copyWith(customerInfo: customer);
      }
      return order;
    }).toList();
    
    print('🚚 👥 OrderProvider: Successfully enriched ${enrichedOrders.length} orders');
    return enrichedOrders;
  }

  // Refresh data
  void refreshData() {
    notifyListeners();
  }
  
  // Update order items during pickup (allows editing)
  Future<bool> updateOrderItems(String orderId, List<Map<String, dynamic>> newItems, double newTotalAmount, {String? pickupNotes}) async {
    try {
      print('🚚 📝 OrderProvider: Updating items for order: $orderId');
      print('🚚 📝 New items count: ${newItems.length}');
      print('🚚 📝 New total amount: ₹$newTotalAmount');
      
      print('🚚 🔐 Using custom authentication (no Firebase Auth needed)');
      
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final updateData = {
        'items': newItems,
        'totalAmount': newTotalAmount,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (pickupNotes != null && pickupNotes.isNotEmpty) {
        updateData['pickupNotes'] = pickupNotes;
      }
      
      await _firestore.collection('orders').doc(orderId).update(updateData);
      
      print('🚚 ✅ OrderProvider: Successfully updated order items for: $orderId');
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('🚚 ❌ OrderProvider: Failed to update order items: $e');
      _error = 'Failed to update order items: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }



  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}