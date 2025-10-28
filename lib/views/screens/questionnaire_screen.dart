import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Import controllers
import '../../controllers/questionnaire_controller.dart';
// Import widget
import '../widgets/questionnaire/question_widgets.dart';
import '../widgets/questionnaire/summary_page.dart';
// Import screen tujuan
import 'main_app_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});
  @override
  State<QuestionnaireScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionnaireScreen> {
  // Inisialisasi controller
  late QuestionnaireController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuestionnaireController();
    // Listener untuk navigasi setelah save berhasil
    _controller.addListener(_handleControllerStateChange);
  }

  void _handleControllerStateChange() {
    if (_controller.status == QuestionnaireStatus.success && _controller.savedUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainAppScreen(user: _controller.savedUser!)),
                (Route<dynamic> route) => false,
          );
        }
      });
    } else if (_controller.status == QuestionnaireStatus.failure && _controller.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_controller.errorMessage!)),
          );
        }
      });
    }
  }


  @override
  void dispose() {
    _controller.removeListener(_handleControllerStateChange);
    _controller.dispose();
    super.dispose();
  }

  // Widget untuk CupertinoPicker (Tetap di sini atau pindah ke file widgets jika reusable)
  Widget _buildInlineCupertinoPicker(int step, int min, int max) {
    // Ambil nilai awal dari controller
    int initialValue = (_controller.answers[step] as int?) ?? min;
    int calculatedInitialItem = (initialValue - min).clamp(0, max - min);

    return SizedBox(
      height: 150,
      child: CupertinoPicker(
        magnification: 1.2,
        itemExtent: 32.0,
        scrollController: FixedExtentScrollController(initialItem: calculatedInitialItem),
        // Panggil updateAnswer di controller
        onSelectedItemChanged: (int index) => _controller.updateAnswer(step, min + index),
        children: List<Widget>.generate(max - min + 1, (int index) {
          return Center(child: Text('${min + index}'));
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan ListenableBuilder untuk mendengarkan perubahan step dan status
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        bool isSummaryPage = _controller.currentStep == _controller.questionDefinitions.length;
        bool isSaving = _controller.status == QuestionnaireStatus.saving;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: isSummaryPage ? Colors.grey[50] : Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.grey[600]),
              // Panggil _controller.previousPage() atau pop jika di step 0
              onPressed: _controller.currentStep == 0
                  ? () => Navigator.of(context).pop()
                  : _controller.previousPage,
            ),
            title: isSummaryPage
                ? const Text("Ringkasan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87))
                : null,
            actions: [
              if (!isSummaryPage)
                TextButton(
                  onPressed: _controller.jumpToSummary, // Langsung ke summary
                  child: Text('Lewati', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
                ),
              const SizedBox(width: 16),
            ],
            centerTitle: true,
          ),
          backgroundColor: isSummaryPage ? Colors.grey[50] : Colors.white,
          body: Column(
            children: [
              // Progress Bar
              if (!isSummaryPage)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: LinearProgressIndicator(
                    // Hitung progress berdasarkan controller
                    value: (_controller.currentStep + 1) / _controller.questionDefinitions.length,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _controller.pageController, // Gunakan pageController dari controller
                  physics: const NeverScrollableScrollPhysics(),
                  // Update currentStep di controller saat halaman berganti
                  onPageChanged: (page) => _controller.updateCurrentStep(page),
                  itemCount: _controller.questionDefinitions.length + 1,
                  itemBuilder: (context, index) {
                    // Halaman Summary
                    if (index == _controller.questionDefinitions.length) {
                      return SummaryPage(
                          answers: _controller.answers, // Ambil jawaban dari controller
                          onConfirm: isSaving ? (){} : _controller.saveProfile // Panggil saveProfile dari controller
                        // TODO: Handle loading state di tombol SummaryPage
                      );
                    }
                    // Halaman Pertanyaan
                    else {
                      final definition = _controller.questionDefinitions[index];
                      Widget questionWidget;

                      switch (definition['type']) {
                        case 'gender':
                          questionWidget = SimpleGenderSelection(
                            // Panggil updateAnswer di controller
                            onChanged: (val) => _controller.updateAnswer(index, val),
                            initialValue: _controller.answers[index], // Ambil nilai awal dari controller
                          );
                          break;
                        case 'picker':
                          questionWidget = _buildInlineCupertinoPicker(
                            index, definition['min'], definition['max'],
                          );
                          break;
                        case 'choice':
                          questionWidget = ChoiceOptionsWithDescription(
                            options: definition['options'],
                            // Panggil updateAnswer di controller
                            onChanged: (val) => _controller.updateAnswer(index, val),
                            initialValue: _controller.answers[index], // Ambil nilai awal dari controller
                          );
                          break;
                        case 'multiselect':
                          questionWidget = MultiSelectSection(
                            description: definition['description'],
                            // Ambil nilai awal dari controller
                            initialSelected: _controller.answers[index] as List<String>,
                            sections: [
                              MultiSelectCheckbox(
                                title: definition['sectionTitle'],
                                options: definition['options'],
                                // Ambil nilai awal dari controller
                                initialSelected: _controller.answers[index] as List<String>,
                                // Panggil updateAnswer di controller
                                onChanged: (selected) => _controller.updateAnswer(index, selected),
                              ),
                            ],
                          );
                          break;
                        default:
                          questionWidget = const Text('Tipe widget tidak dikenal');
                      }

                      return QuestionPageContent(
                        title: definition['title'],
                        onContinue: _controller.nextPage, // Panggil nextPage dari controller
                        // Panggil _controller.previousPage() atau pop jika di step 0
                        onBack: _controller.currentStep == 0
                            ? () => Navigator.of(context).pop()
                            : _controller.previousPage,
                        child: questionWidget,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}