import 'package:flutter/material.dart';
import 'package:nutri_balance/controllers/food_log_controller.dart';
import '../widgets/food_log/food_log_tile.dart';

class FoodLogScreen extends StatefulWidget {
  final String token;
  const FoodLogScreen({super.key, required this.token});

  @override
  State<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  late FoodLogController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FoodLogController(token: widget.token);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              _controller.selectedDateFormatted,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.5,
            actions: [
              IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                    color: Theme.of(context).primaryColor),
                onPressed: () {
                  _controller.selectDate(context);
                },
              ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_controller.status == FoodLogStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.status == FoodLogStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            _controller.errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_controller.logsForSelectedDate.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada makanan yang dicatat\npada tanggal ini.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Kelompokkan berdasarkan MealType
    final Map<String, List<Widget>> groupedLogs = {};
    for (var log in _controller.logsForSelectedDate) {
      if (!groupedLogs.containsKey(log.mealType)) {
        groupedLogs[log.mealType] = [];
      }
      groupedLogs[log.mealType]!.add(FoodLogTile(log: log));
    }

    final sortedKeys = groupedLogs.keys.toList()
      ..sort((a, b) {
        const order = {'Sarapan': 1, 'Makan Siang': 2, 'Makan Malam': 3, 'Snack': 4};
        return (order[a] ?? 99).compareTo(order[b] ?? 99);
      });

    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final mealType = sortedKeys[index];
        final items = groupedLogs[mealType]!;

        double totalCalories = 0;
        for (var log in _controller.logsForSelectedDate.where((l) => l.mealType == mealType)) {
          totalCalories += (log.food.calories * log.quantity);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mealType,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text(
                      '${totalCalories.toStringAsFixed(0)} kkal',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    )
                  ],
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200)
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: items,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
