import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/questionnaire_controller.dart';
import '../widgets/questionnaire/question_widgets.dart';
import '../widgets/questionnaire/summary_page.dart';
import 'main_app_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});
  @override
  State<QuestionnaireScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionnaireScreen> {
  late QuestionnaireController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuestionnaireController();
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

  Widget _buildInlineCupertinoPicker(int step, int min, int max) {
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
                  controller: _controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) => _controller.updateCurrentStep(page),
                  itemCount: _controller.questionDefinitions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _controller.questionDefinitions.length) {
                      return SummaryPage(
                          answers: _controller.answers,
                          onConfirm: isSaving ? (){} : _controller.saveProfile
                      );
                    }
                    else {
                      final definition = _controller.questionDefinitions[index];
                      Widget questionWidget;

                      switch (definition['type']) {
                        case 'gender':
                          questionWidget = SimpleGenderSelection(
                            onChanged: (val) => _controller.updateAnswer(index, val),
                            initialValue: _controller.answers[index],
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
                            initialValue: _controller.answers[index],
                          );
                          break;
                        case 'multiselect':
                          questionWidget = MultiSelectSection(
                            description: definition['description'],
                            initialSelected: _controller.answers[index] as List<String>,
                            sections: [
                              MultiSelectCheckbox(
                                title: definition['sectionTitle'],
                                options: definition['options'],
                                initialSelected: _controller.answers[index] as List<String>,
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
                        onContinue: _controller.nextPage,
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