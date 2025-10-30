import 'package:flutter/material.dart';
// Import Controller
import '../../controllers/home_controller.dart';
// Import Model (tetap diperlukan untuk tipe data parameter)
import '../../models/user_model.dart';
// Import Widget (tetap diperlukan)
import '../widgets/home/home_header.dart';
import '../widgets/home/calorie_macro_card.dart';
import '../widgets/home/meal_target_grid.dart';
import '../widgets/home/add_food_button.dart';
// Import screen lain (jika diperlukan untuk navigasi error/logout)
// import 'login_screen.dart'; // Sudah ada di HomeController

class HomeScreen extends StatefulWidget {
  final User initialUser;
  const HomeScreen({super.key, required this.initialUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instance Controller
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    // Buat instance HomeController, berikan initialUser
    _controller = HomeController(widget.initialUser);
    // Tambahkan listener jika perlu menangani error secara spesifik di UI
    // _controller.addListener(_handleControllerChanges);
  }

  // Opsional: Listener untuk menangani error atau event lain dari controller
  // void _handleControllerChanges() {
  //   if (_controller.status == HomeStatus.failure && _controller.errorMessage != null) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(_controller.errorMessage!),
  //             action: SnackBarAction(label: 'Logout', onPressed: () => _controller.logout(context)),
  //           ),
  //         );
  //       }
  //     });
  //   }
  // }

  @override
  void dispose() {
    // _controller.removeListener(_handleControllerChanges); // Hapus listener jika ada
    _controller.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan ListenableBuilder untuk mendengarkan perubahan state controller
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        // Tentukan konten berdasarkan status controller
        Widget bodyContent;
        if (_controller.status == HomeStatus.loading && _controller.currentUser == null) {
          // Loading awal (sebelum data user ada)
          bodyContent = const Center(child: CircularProgressIndicator());
        } else if (_controller.status == HomeStatus.failure) {
          // Tampilkan pesan error dengan tombol refresh
          bodyContent = Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    _controller.errorMessage ?? 'Gagal memuat data.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    onPressed: _controller.fetchData, // Panggil fetchData lagi
                  ),
                  TextButton(
                    onPressed: () => _controller.logout(context),
                    child: const Text('Logout', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Tampilkan konten utama jika status success atau loading tapi data sudah ada
          bodyContent = RefreshIndicator(
            onRefresh: _controller.fetchData, // Panggil fetchData saat refresh
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // Selalu bisa di-scroll
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gunakan HomeHeader widget dengan data dari controller
                  HomeHeader(userName: _controller.currentUser?.name ?? 'Pengguna'),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // Gunakan CalorieMacroCard dengan data dari controller
                        CalorieMacroCard(
                          caloriesEaten: _controller.consumedCalories,
                          caloriesGoal: _controller.targetCalories,
                          proteinEaten: _controller.consumedProtein.round(),
                          proteinGoal: _controller.targetProtein.round(),
                          fatsEaten: _controller.consumedFats.round(),
                          fatsGoal: _controller.targetFats.round(),
                          carbsEaten: _controller.consumedCarbs.round(),
                          carbsGoal: _controller.targetCarbs.round(),
                        ),
                        const SizedBox(height: 25),

                        // Gunakan MealTargetGrid dengan data dari controller
                        MealTargetGrid(
                          targets: _controller.targetsForGrid, // Ambil target dari controller
                          consumedData: _controller.consumedDataForGrid, // Ambil data konsumsi dari controller
                        ),
                        const SizedBox(height: 25),

                        // Tombol Tambah Makanan
                        const AddFoodButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: bodyContent, // Tampilkan konten yang sesuai
        );
      },
    );
  }
}