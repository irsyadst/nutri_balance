import 'package:flutter/material.dart';
import '../models/api_service.dart';
import '../models/dashboard_data.dart';

// Controller untuk halaman Dashboard.
class DashboardController with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DashboardData? _dashboardData;
  DashboardData? get dashboardData => _dashboardData;

  DashboardController() {
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    // Di aplikasi nyata, token akan diambil dari penyimpanan aman
    _dashboardData = await _apiService.getDashboardData("fake_token");

    _isLoading = false;
    notifyListeners();
  }
}
