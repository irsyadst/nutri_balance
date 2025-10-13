import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ===== SOLUSI SSL: KELAS HTTP OVERRIDES =====
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//==============================================================================
// BAGIAN 1: DATA MODELS (Dengan Logging Debug Tambahan)
//==============================================================================

class User {
  String id; String name; String email; UserProfile? profile;
  User({required this.id, required this.name, required this.email, this.profile});

  factory User.fromJson(Map<String, dynamic> json) {
    debugPrint("[PARSING DEBUG] Memulai parsing User. Data JSON masuk: $json");
    try {
      return User(
          id: json['_id'],
          name: json['name'],
          email: json['email'],
          profile: json['profile'] != null ? UserProfile.fromJson(json['profile']) : null
      );
    } catch (e) {
      debugPrint("!!! ERROR PARSING User.fromJson !!!: $e");
      rethrow; // Lemparkan kembali error agar bisa ditangkap di level atas
    }
  }
}

class UserProfile {
  String gender; int age; double weight; double height;
  String activityLevel; String goal; int targetCalories;
  int targetProteins; int targetCarbs; int targetFats;

  UserProfile({required this.gender, required this.age, required this.weight,
    required this.height, required this.activityLevel, required this.goal,
    this.targetCalories = 0, this.targetProteins = 0, this.targetCarbs = 0, this.targetFats = 0});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    debugPrint("[PARSING DEBUG] Memulai parsing UserProfile. Data JSON masuk: $json");
    try {
      return UserProfile(
          gender: json['gender'] ?? '',
          age: json['age'] ?? 0,
          weight: (json['weight'] ?? 0).toDouble(),
          height: (json['height'] ?? 0).toDouble(),
          activityLevel: json['activityLevel'] ?? '',
          goal: json['goal'] ?? '',
          targetCalories: json['targetCalories'] ?? 0,
          targetProteins: json['targetProteins'] ?? 0,
          targetCarbs: json['targetCarbs'] ?? 0,
          targetFats: json['targetFats'] ?? 0
      );
    } catch (e) {
      debugPrint("!!! ERROR PARSING UserProfile.fromJson !!!: $e");
      rethrow; // Lemparkan kembali error
    }
  }

  Map<String, dynamic> toJson() => {'gender': gender, 'age': age, 'weight': weight,
    'height': height, 'activityLevel': activityLevel, 'goal': goal};
}

class Food {
  final String id; final String name; final int calories;
  final int proteins; final int carbs; final int fats;
  Food({required this.id, required this.name, required this.calories,
    required this.proteins, required this.carbs, required this.fats});
  factory Food.fromJson(Map<String, dynamic> json) => Food(
      id: json['id'], name: json['name'], calories: json['calories'],
      proteins: json['proteins'], carbs: json['carbs'], fats: json['fats']);
}
class LoggedFood {
  final Food food; final double quantity; final String mealType; final String date;
  LoggedFood({required this.food, required this.quantity, required this.mealType, required this.date});
  factory LoggedFood.fromLogJson(Map<String, dynamic> json) => LoggedFood(
      food: Food.fromJson(json['food']),
      quantity: (json['quantity'] ?? 1.0).toDouble(),
      mealType: json['mealType'],
      date: json['date']
  );
}

//==============================================================================
// BAGIAN 2: SERVICES (Dengan Logging Debug Tambahan)
//==============================================================================
class ApiService {
  static const String _baseUrl = 'https://nutri-balance-backend.onrender.com/api';

  Future<User?> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint("================================================");
      debugPrint("!!! DEBUGGING getProfile !!!");
      debugPrint("URL yang dipanggil: $_baseUrl/user/profile");
      debugPrint("Status Code yang Diterima: ${response.statusCode}");
      debugPrint("Isi Body Respons: ${response.body}");
      debugPrint("================================================");

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("!!! ERROR DI DALAM getProfile (level API Service) !!!: $e");
      return null;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}));
    return response.statusCode == 201;
  }

  Future<String?> login(String email, String password) async {
    final response = await http.post(Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}));
    return response.statusCode == 200 ? jsonDecode(response.body)['token'] : null;
  }

  Future<User?> updateProfile(String token, UserProfile profile) async {
    final response = await http.put(Uri.parse('$_baseUrl/user/profile'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(profile.toJson()));
    return response.statusCode == 200 ? User.fromJson(jsonDecode(response.body)['user']) : null;
  }

  Future<List<Food>> searchFood(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/foods?search=$query'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((item) => Food.fromJson(item)).toList();
    }
    throw Exception('Gagal memuat makanan');
  }

  Future<LoggedFood?> logFood(String token, String foodId, double quantity, String mealType) async {
    final response = await http.post(Uri.parse('$_baseUrl/log/food'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({'foodId': foodId, 'quantity': quantity, 'mealType': mealType}));
    if (response.statusCode == 201) {
      return LoggedFood.fromLogJson(jsonDecode(response.body)['log']);
    }
    return null;
  }

  Future<List<LoggedFood>> getTodaysLogs(String token) async {
    final response = await http.get(Uri.parse('$_baseUrl/log/history'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final allLogs = (jsonDecode(response.body) as List)
          .map((data) => LoggedFood.fromLogJson(data))
          .toList();

      final todaysLogs = allLogs.where((log) => log.date == today).toList();
      return todaysLogs;
    }
    throw Exception('Gagal memuat riwayat log (Status: ${response.statusCode})');
  }
}

class StorageService {
  static const _tokenKey = 'auth_token';
  static const _waterKey = 'water_glasses';
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  Future<String?> getToken() async => (await SharedPreferences.getInstance()).getString(_tokenKey);
  Future<void> deleteToken() async => (await SharedPreferences.getInstance()).remove(_tokenKey);
  Future<void> saveWaterGlasses(int glasses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_waterKey, glasses);
  }
  Future<int> getWaterGlasses() async => (await SharedPreferences.getInstance()).getInt(_waterKey) ?? 0;
}

//==============================================================================
// BAGIAN 3: MAIN APP & AUTH WRAPPER
//==============================================================================
void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const NutriBalanceApp());
}

class NutriBalanceApp extends StatelessWidget {
  const NutriBalanceApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'NutriBalance', theme: _buildThemeData(), home: const AuthWrapper(),
      debugShowCheckedModeBanner: false);
}

ThemeData _buildThemeData() => ThemeData(
    primarySwatch: Colors.green, scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
    cardTheme: CardThemeData(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1))));

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _checkAuthStatus();
  }

  Future<User?> _checkAuthStatus() async {
    final token = await _storageService.getToken();
    if (token != null) {
      try {
        return await _apiService.getProfile(token);
      } catch (e) {
        debugPrint("Error saat getProfile (di AuthWrapper): $e");
        await _storageService.deleteToken();
        return null;
      }
    }
    return null;
  }

  void _updateAuthStatus() {
    setState(() {
      _userFuture = _checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const SplashScreen();
        final user = snapshot.data;
        if (user != null) {
          if (user.profile == null) {
            return ProfileSetupScreen(onProfileComplete: _updateAuthStatus);
          }
          return MainScreen(user: user, onLogout: _updateAuthStatus);
        } else {
          return LoginScreen(onLogin: _updateAuthStatus);
        }
      });
}

//==============================================================================
// BAGIAN 4: SCREENS UTAMA
//==============================================================================

class MainScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;
  const MainScreen({super.key, required this.user, required this.onLogout});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<LoggedFood> _dailyLog = [];
  int _waterGlasses = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final token = await _storageService.getToken();
      if (token == null) { _performLogout(); return; }
      final logs = await _apiService.getTodaysLogs(token);
      final water = await _storageService.getWaterGlasses();
      if (mounted) setState(() { _dailyLog = logs; _waterGlasses = water; });
    } catch (e) {
      debugPrint("=================================");
      debugPrint("ERROR di _loadInitialData: $e");
      debugPrint("=================================");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat data harian.')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _performLogout() async {
    await _storageService.deleteToken();
    widget.onLogout();
  }

  void _addFood(LoggedFood food) {
    setState(() => _dailyLog.add(food));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${food.food.name} berhasil ditambahkan!'),
        duration: const Duration(seconds: 1)));
  }

  void _updateWater(int change) {
    final newCount = max(0, _waterGlasses + change);
    _storageService.saveWaterGlasses(newCount);
    setState(() => _waterGlasses = newCount);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(
          user: widget.user, dailyLog: _dailyLog, waterGlasses: _waterGlasses,
          onFoodAdded: _addFood, onWaterChanged: _updateWater, isLoading: _isLoading,
          onRefresh: _loadInitialData),
      const ProgressScreen(),
      ProfileScreen(user: widget.user, onLogout: _performLogout),
    ];

    return Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Progres'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            onTap: (index) => setState(() => _selectedIndex = index)));
  }
}

class DashboardScreen extends StatelessWidget {
  final User user; final List<LoggedFood> dailyLog;
  final int waterGlasses; final Function(LoggedFood) onFoodAdded;
  final Function(int) onWaterChanged; final bool isLoading;
  final VoidCallback onRefresh;

  const DashboardScreen({super.key, required this.user, required this.dailyLog,
    required this.waterGlasses, required this.onFoodAdded,
    required this.onWaterChanged, required this.isLoading, required this.onRefresh});

  int get _consumedCalories => dailyLog.fold(0, (sum, i) => sum + (i.food.calories * i.quantity).toInt());
  int get _consumedProteins => dailyLog.fold(0, (sum, i) => sum + (i.food.proteins * i.quantity).toInt());
  int get _consumedCarbs => dailyLog.fold(0, (sum, i) => sum + (i.food.carbs * i.quantity).toInt());
  int get _consumedFats => dailyLog.fold(0, (sum, i) => sum + (i.food.fats * i.quantity).toInt());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Halo, ${user.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              const Text('Selamat Datang!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]),
            actions: [IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh))]),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: ListView(padding: const EdgeInsets.all(16.0), children: [
            _buildCalorieSummaryCard(), const SizedBox(height: 20),
            _buildMacrosSummary(), const SizedBox(height: 20),
            _buildMealLoggingSection(context), const SizedBox(height: 20),
            _buildWaterTracker(), const SizedBox(height: 20),
            if (dailyLog.isNotEmpty) _buildDailyLogList()
          ]),
        ));
  }

  Widget _buildCalorieSummaryCard() {
    final profile = user.profile;
    if (profile == null) return const Card(child: Padding(padding: EdgeInsets.all(20), child: Text("Profil belum lengkap.")));
    final remaining = profile.targetCalories - _consumedCalories;
    return Card(color: Colors.green.shade50, child: Padding(padding: const EdgeInsets.all(20.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(children: [const Text("Target"), Text("${profile.targetCalories}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)), const Text("kkal")]),
      const Text("-", style: TextStyle(fontSize: 30, color: Colors.grey)),
      Column(children: [const Text("Terkonsumsi"), Text("$_consumedCalories", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)), const Text("kkal")]),
      const Text("=", style: TextStyle(fontSize: 30, color: Colors.grey)),
      Column(children: [const Text("Sisa"), Text("$remaining", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)), const Text("kkal")]),
    ])));
  }

  Widget _buildMacrosSummary() {
    final profile = user.profile;
    if (profile == null) return const SizedBox.shrink();
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _MacroProgressIndicator(label: 'Karbo', consumed: _consumedCarbs, target: profile.targetCarbs, color: Colors.orange),
      _MacroProgressIndicator(label: 'Protein', consumed: _consumedProteins, target: profile.targetProteins, color: Colors.red),
      _MacroProgressIndicator(label: 'Lemak', consumed: _consumedFats, target: profile.targetFats, color: Colors.blue),
    ]);
  }

  Widget _buildMealLoggingSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Catat Makananmu Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.5, children: [
        _MealCard(label: 'Sarapan', icon: Icons.free_breakfast, onTap: () => _navigateToAddFood(context, 'Sarapan')),
        _MealCard(label: 'Makan Siang', icon: Icons.lunch_dining, onTap: () => _navigateToAddFood(context, 'Makan Siang')),
        _MealCard(label: 'Makan Malam', icon: Icons.dinner_dining, onTap: () => _navigateToAddFood(context, 'Makan Malam')),
        _MealCard(label: 'Camilan', icon: Icons.fastfood, onTap: () => _navigateToAddFood(context, 'Camilan')),
      ]),
    ]);
  }

  void _navigateToAddFood(BuildContext context, String mealType) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => FoodLoggingScreen(mealType: mealType, onFoodLogged: onFoodAdded)));
  }

  Widget _buildWaterTracker() {
    return Card(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Icon(Icons.local_drink, color: Colors.blue, size: 30),
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [const Text('Asupan Air Minum', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text('$waterGlasses / 8 Gelas', style: const TextStyle(fontSize: 14, color: Colors.grey))]),
      Row(children: [
        IconButton.filled(icon: const Icon(Icons.remove), onPressed: () => onWaterChanged(-1), style: IconButton.styleFrom(backgroundColor: Colors.blue.shade100)),
        const SizedBox(width: 8),
        IconButton.filled(icon: const Icon(Icons.add), onPressed: () => onWaterChanged(1), style: IconButton.styleFrom(backgroundColor: Colors.blue.shade100)),
      ])
    ])));
  }

  Widget _buildDailyLogList() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Log Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Card(child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dailyLog.length,
        itemBuilder: (context, index) {
          final log = dailyLog[index];
          return ListTile(
            leading: const Icon(Icons.restaurant, color: Colors.green),
            title: Text(log.food.name),
            subtitle: Text(log.mealType),
            trailing: Text("${(log.food.calories * log.quantity).toInt()} kkal", style: const TextStyle(fontWeight: FontWeight.w500)),
          );
        },
      ))
    ]);
  }
}

//==============================================================================
// BAGIAN 5: SCREENS LAINNYA & WIDGETS
//==============================================================================
class FoodLoggingScreen extends StatefulWidget {
  final String mealType; final Function(LoggedFood) onFoodLogged;
  const FoodLoggingScreen({super.key, required this.mealType, required this.onFoodLogged});
  @override
  State<FoodLoggingScreen> createState() => _FoodLoggingScreenState();
}
class _FoodLoggingScreenState extends State<FoodLoggingScreen> {
  final _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  List<Food> _searchResults = [];
  bool _isLoading = false;
  bool _isLogging = false;

  @override
  void initState() {
    super.initState();
    _searchFood("");
  }

  Future<void> _searchFood(String query) async {
    setState(() => _isLoading = true);
    try {
      final results = await _apiService.searchFood(query);
      if (mounted) setState(() => _searchResults = results);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat data makanan.')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddFoodDialog(Food food) {
    final quantityController = TextEditingController(text: "1");
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return AlertDialog(
                title: Text('Tambah ${food.name}'),
                content: TextField(
                    controller: quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Jumlah Porsi', hintText: 'Contoh: 1.5')),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
                  ElevatedButton(
                      onPressed: _isLogging ? null : () async {
                        setDialogState(() => _isLogging = true);
                        final quantity = double.tryParse(quantityController.text) ?? 1.0;
                        final token = await _storageService.getToken();
                        if (token == null) {
                          if (mounted) Navigator.of(context).pop();
                          return;
                        }

                        final newLog = await _apiService.logFood(token, food.id, quantity, widget.mealType);

                        if (newLog != null && mounted) {
                          widget.onFoodLogged(newLog);
                          Navigator.of(context).pop();
                        } else {
                          if (mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Gagal mencatat makanan.')));
                          }
                        }
                      },
                      child: _isLogging ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Tambah')),
                ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Tambah ${widget.mealType}')),
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'Cari makanan...', prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                onChanged: _searchFood)),
        Expanded(child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _searchResults.isEmpty
            ? const Center(child: Text("Tidak ada hasil. Coba kata kunci lain."))
            : ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final food = _searchResults[index];
              return ListTile(
                  title: Text(food.name),
                  subtitle: Text('${food.calories} kkal, P:${food.proteins}g C:${food.carbs}g F:${food.fats}g'),
                  onTap: () => _showAddFoodDialog(food));
            }))]));
}
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(backgroundColor: Colors.green, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.eco, size: 80, color: Colors.white), SizedBox(height: 20), Text('NutriBalance', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white))])));
}
class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  const LoginScreen({super.key, required this.onLogin});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  Future<void> _performLogin() async {
    setState(() => _isLoading = true);
    try {
      final token = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (token != null) {
        await _storageService.saveToken(token);
        widget.onLogin();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email atau password salah.')),
          );
        }
      }
    } catch (e) {
      debugPrint("================================================");
      debugPrint("!!! KESALAHAN KRITIS SAAT LOGIN !!!");
      debugPrint("Tipe Error: ${e.runtimeType}");
      debugPrint("Pesan Error: ${e.toString()}");
      debugPrint("================================================");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal terhubung ke server. Cek konsol debug.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.eco, size: 60, color: Colors.green),
              const SizedBox(height: 16),
              const Text('Selamat Datang!',
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock)),
                  obscureText: true),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                  onPressed: _performLogin,
                  style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('Login',
                      style:
                      TextStyle(fontSize: 18, color: Colors.white))),
              const SizedBox(height: 16),
              TextButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                          const RegistrationScreen())),
                  child: const Text('Belum punya akun? Daftar di sini'))
            ],
          ),
        ),
      ),
    ),
  );
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}
class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _performRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final success = await _apiService.register(_nameController.text, _emailController.text, _passwordController.text);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil! Silakan login.')));
        Navigator.of(context).pop();
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi gagal. Email mungkin sudah digunakan.')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal terhubung ke server.')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Buat Akun Baru'), elevation: 0, backgroundColor: Colors.transparent, foregroundColor: Colors.black87), body: Padding(padding: const EdgeInsets.all(24.0), child: Center(child: SingleChildScrollView(child: Form(key: _formKey, child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    const Text('Daftar Akun', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    const SizedBox(height: 40),
    TextFormField(controller: _nameController, decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.person)), validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null),
    const SizedBox(height: 16),
    TextFormField(controller: _emailController, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.email)), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Email tidak boleh kosong' : !v.contains('@') ? 'Format email tidak valid' : null),
    const SizedBox(height: 16),
    TextFormField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.lock)), obscureText: true, validator: (v) => v!.length < 6 ? 'Password minimal 6 karakter' : null),
    const SizedBox(height: 24),
    _isLoading ? const Center(child: CircularProgressIndicator()) : ElevatedButton(onPressed: _performRegistration, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Daftar', style: TextStyle(fontSize: 18, color: Colors.white)))
  ]))))));
}
class ProfileSetupScreen extends StatefulWidget {
  final VoidCallback onProfileComplete;
  const ProfileSetupScreen({super.key, required this.onProfileComplete});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}
class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'Pria', _activityLevel = 'Ringan', _goal = 'Menjaga berat badan';
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  bool _isLoading = false;

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final profile = UserProfile(gender: _gender, age: int.parse(_ageController.text), weight: double.parse(_weightController.text), height: double.parse(_heightController.text), activityLevel: _activityLevel, goal: _goal);
      try {
        final token = await _storageService.getToken();
        if (token == null) return;
        final updatedUser = await _apiService.updateProfile(token, profile);
        if (updatedUser != null) {
          widget.onProfileComplete();
        } else { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memperbarui profil.'))); }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal terhubung ke server.')));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Lengkapi Profil Anda'), centerTitle: true), body: SingleChildScrollView(padding: const EdgeInsets.all(24.0), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    const Text("Info ini untuk personalisasi program dietmu.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
    const SizedBox(height: 24),
    DropdownButtonFormField<String>(value: _gender, decoration: const InputDecoration(labelText: 'Jenis Kelamin', border: OutlineInputBorder()), items: ['Pria', 'Wanita'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => _gender = v!)),
    const SizedBox(height: 16),
    TextFormField(controller: _ageController, decoration: const InputDecoration(labelText: 'Umur', border: OutlineInputBorder()), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Mohon isi umur' : null),
    const SizedBox(height: 16),
    TextFormField(controller: _weightController, decoration: const InputDecoration(labelText: 'Berat Badan (kg)', border: OutlineInputBorder()), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Mohon isi berat' : null),
    const SizedBox(height: 16),
    TextFormField(controller: _heightController, decoration: const InputDecoration(labelText: 'Tinggi Badan (cm)', border: OutlineInputBorder()), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Mohon isi tinggi' : null),
    const SizedBox(height: 16),
    DropdownButtonFormField<String>(value: _activityLevel, decoration: const InputDecoration(labelText: 'Tingkat Aktivitas', border: OutlineInputBorder()), items: ['Ringan', 'Sedang', 'Aktif'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => _activityLevel = v!)),
    const SizedBox(height: 16),
    DropdownButtonFormField<String>(value: _goal, decoration: const InputDecoration(labelText: 'Tujuan Diet', border: OutlineInputBorder()), items: ['Menurunkan berat badan', 'Menjaga berat badan', 'Menambah berat badan'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => _goal = v!)),
    const SizedBox(height: 32),
    _isLoading ? const Center(child: CircularProgressIndicator()) : ElevatedButton(onPressed: _saveProfile, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Simpan & Mulai', style: TextStyle(fontSize: 18, color: Colors.white)))
  ]))));
}
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Laporan & Progres')), body: const Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.construction, size: 60, color: Colors.grey), SizedBox(height: 16), Text('Halaman Progres', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('Grafik kemajuan berat badan dan riwayat kalender akan ditampilkan di sini.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey))]))));
}
class ProfileScreen extends StatelessWidget {
  final User user;
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profil Saya'), actions: [IconButton(icon: const Icon(Icons.logout), onPressed: onLogout)]), body: ListView(padding: const EdgeInsets.all(16.0), children: [
    Center(child: Column(children: [
      const CircleAvatar(radius: 50, backgroundColor: Colors.green, child: Icon(Icons.person, size: 50, color: Colors.white)),
      const SizedBox(height: 10),
      Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      Text(user.email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
    ])),
    const SizedBox(height: 20), const Divider(), const SizedBox(height: 10),
    if (user.profile != null) ...[
      _buildProfileInfoTile('Jenis Kelamin', user.profile!.gender),
      _buildProfileInfoTile('Umur', '${user.profile!.age} tahun'),
      _buildProfileInfoTile('Berat Badan', '${user.profile!.weight} kg'),
      _buildProfileInfoTile('Tinggi Badan', '${user.profile!.height} cm'),
      _buildProfileInfoTile('Aktivitas', user.profile!.activityLevel),
      _buildProfileInfoTile('Tujuan', user.profile!.goal),
    ] else const Center(child: Text("Profil belum diatur."))
  ]));
  Widget _buildProfileInfoTile(String title, String subtitle) => ListTile(title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), trailing: Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.black54)));
}
class _MacroProgressIndicator extends StatelessWidget {
  final String label; final int consumed; final int target; final Color color;
  const _MacroProgressIndicator({required this.label, required this.consumed, required this.target, required this.color});
  @override
  Widget build(BuildContext context) {
    final double progress = target == 0 ? 0 : min(consumed / target, 1.0);
    return Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 8),
      LinearProgressIndicator(value: progress, backgroundColor: color.withOpacity(0.2), color: color, minHeight: 6), const SizedBox(height: 8),
      Text('$consumed / ${target}g', style: const TextStyle(fontSize: 14, color: Colors.grey))
    ]))));
  }
}
class _MealCard extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _MealCard({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Padding(padding: const EdgeInsets.all(8.0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(icon, color: Colors.green), const SizedBox(width: 10), Text(label, style: const TextStyle(fontWeight: FontWeight.bold))
  ]))));
}

