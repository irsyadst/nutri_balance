// lib/views/screens/add_food_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/add_food_controller.dart';
import '../widgets/add_food/food_search_bar.dart';
import '../widgets/add_food/recommendation_tab_view.dart';
import '../widgets/add_food/category_tab_view.dart';
import '../widgets/add_food/search_results_view.dart';


class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AddFoodController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = AddFoodController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Tambah Makanan',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0.5,
              shadowColor: Colors.grey.shade200,
              bottom: _controller.isSearching
                  ? null
                  : TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 3.0,
                tabs: const [
                  Tab(text: 'Rekomendasi'),
                  Tab(text: 'Kategori'),
                ],
              ),
            ),
            body: _buildBody(context, _controller),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AddFoodController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 15.0),
          child: FoodSearchBar(
            controller: _searchController,
            onChanged:
            controller.handleSearchByName,
          ),
        ),
        Expanded(
          child: _buildContent(context, controller),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, AddFoodController controller) {

    if (controller.isSearching) {
      return SearchResultsView(controller: controller);
    }

    return TabBarView(
      controller: _tabController,
      children: [
        RecommendationTabView(controller: controller),
        CategoryTabView(
          controller: controller,
          searchController: _searchController,
        ),
      ],
    );
  }

}