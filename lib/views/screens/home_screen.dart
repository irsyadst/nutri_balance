import 'package:flutter/material.dart';
// Import Controller
import '../../controllers/home_controller.dart';
// Import Model
import '../../models/user_model.dart';
// Import Widget
import '../widgets/home/home_header.dart';
import '../widgets/home/calorie_macro_card.dart';
import '../widgets/home/meal_target_grid.dart';
import '../widgets/home/add_food_button.dart';
import '../widgets/home/view_log_button.dart'; // Impor tombol log

class HomeScreen extends StatefulWidget {
  final User initialUser;
  const HomeScreen({super.key, required this.initialUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(widget.initialUser);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        Widget bodyContent;
        if (_controller.status == HomeStatus.loading && _controller.currentUser == null) {
          bodyContent = const Center(child: CircularProgressIndicator());
        } else if (_controller.status == HomeStatus.failure) {
          // Tampilkan pesan error
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
          // Tampilkan konten utama
          bodyContent = RefreshIndicator(
            onRefresh: _controller.fetchData, // Panggil fetchData saat refresh
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(userName: _controller.currentUser?.name ?? 'Pengguna'),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
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

                        // --- [PERBAIKAN DI SINI] ---
                        MealTargetGrid(
                          targets: _controller.targetsForGrid,
                          consumedData: _controller.consumedDataForGrid,
                          controller: _controller, // <-- KIRIM CONTROLLER
                        ),
                        // --- [AKHIR PERBAIKAN] ---

                        const SizedBox(height: 25),

                        // Tombol Tambah Makanan
                        const AddFoodButton(),

                        const SizedBox(height: 15),

                        // Tombol Lihat Catatan Harian
                        ViewLogButton(
                          onPressed: () => _controller.navigateToFoodLog(context),
                        ),
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

