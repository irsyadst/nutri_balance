import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class QuestionPageContent extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const QuestionPageContent({
    super.key,
    required this.title,
    required this.child,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. JUDUL
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1617),
              ),
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: child,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Text('Kembali', style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF007BFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                      elevation: 4,
                      shadowColor: const Color(0xFF007BFF).withOpacity(0.3),
                    ),
                    child: const Text('Selanjutnya', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleGenderSelection extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;
  const SimpleGenderSelection({super.key, required this.onChanged, this.initialValue});

  @override
  State<SimpleGenderSelection> createState() => _SimpleGenderSelectionState();
}

class _SimpleGenderSelectionState extends State<SimpleGenderSelection> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialValue;
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onChanged(_selectedGender ?? 'Pria'));
  }

  void _selectGender(String gender) {
    setState(() => _selectedGender = gender);
    widget.onChanged(gender);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GenderButton(label: 'Pria', isSelected: _selectedGender == 'Pria', onTap: () => _selectGender('Pria')),
        const SizedBox(width: 20),
        GenderButton(label: 'Wanita', isSelected: _selectedGender == 'Wanita', onTap: () => _selectGender('Wanita')),
      ],
    );
  }
}

class GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderButton({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 140,
        height: 180,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE7F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF007BFF) : Colors.grey[200]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0xFF007BFF).withOpacity(0.15) : Colors.black.withOpacity(0.04),
              blurRadius: 12,
            )
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF007BFF) : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownNumberPicker extends StatelessWidget {
  final String hintText;
  final int value;
  final VoidCallback onTap;

  const DropdownNumberPicker({
    super.key,
    required this.hintText,
    required this.value,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value == 0 ? hintText : '$value',
              style: TextStyle(fontSize: 16, color: value == 0 ? Colors.grey[600] : Colors.black, fontWeight: FontWeight.w500),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}

// Pilihan Ganda dengan Animasi dan Tampilan Modern
class ChoiceOptionsWithDescription extends StatefulWidget {
  final List<Map<String, String>> options;
  final ValueChanged<String> onChanged;
  final String? initialValue; // Tambahkan initialValue

  const ChoiceOptionsWithDescription({super.key, required this.options, required this.onChanged, this.initialValue});

  @override
  State<ChoiceOptionsWithDescription> createState() => _ChoiceOptionsWithDescriptionState();
}

class _ChoiceOptionsWithDescriptionState extends State<ChoiceOptionsWithDescription> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    // Set nilai awal dari properti, atau yang pertama jika tidak ada
    _selectedOption = widget.initialValue ?? (widget.options.isNotEmpty ? widget.options.first['title'] : null);

    // Panggil onChanged dengan nilai awal setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedOption != null) {
        widget.onChanged(_selectedOption!);
      }
    });
  }

  void _selectOption(String title) {
    setState(() => _selectedOption = title);
    widget.onChanged(title);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final option = widget.options[index];
        final isSelected = _selectedOption == option['title'];
        return GestureDetector(
          onTap: () => _selectOption(option['title']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? const Color(0xFF007BFF) : Colors.grey[200]!,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: const Color(0xFF007BFF).withOpacity(0.15), blurRadius: 12)]
                  : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['title']!,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      if(option['description']!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            option['description']!,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
                Radio<String>(
                  value: option['title']!,
                  groupValue: _selectedOption,
                  onChanged: (String? value) => _selectOption(value!),
                  activeColor: const Color(0xFF007BFF),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget untuk mengelompokkan Checkbox dengan deskripsi (Seperti di langkah 7 & 8)
class MultiSelectSection extends StatelessWidget {
  final String description;
  final List<Widget> sections;
  final List<String> initialSelected; // Diperlukan untuk inisialisasi MultiSelectCheckbox

  const MultiSelectSection({
    super.key,
    required this.description,
    required this.sections,
    required this.initialSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        const SizedBox(height: 30),
        ...sections,
      ],
    );
  }
}


// Widget untuk Pilihan Ganda (Checkbox)
class MultiSelectCheckbox extends StatefulWidget {
  final String title;
  final List<String> options;
  final ValueChanged<List<String>> onChanged;
  final List<String>? initialSelected; // Tambahkan initialSelected

  const MultiSelectCheckbox({
    super.key,
    required this.title,
    required this.options,
    required this.onChanged,
    this.initialSelected,
  });

  @override
  State<MultiSelectCheckbox> createState() => _MultiSelectCheckboxState();
}

class _MultiSelectCheckboxState extends State<MultiSelectCheckbox> {
  late List<String> _selectedOptions;

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan nilai awal atau list kosong
    _selectedOptions = widget.initialSelected ?? [];
    // Panggil onChanged dengan nilai awal
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onChanged(_selectedOptions));
  }

  void _onOptionSelected(bool? selected, String option) {
    setState(() {
      if (selected == true) {
        if (!_selectedOptions.contains(option)) {
          _selectedOptions.add(option);
        }
      } else {
        _selectedOptions.remove(option);
      }
    });
    widget.onChanged(_selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    // Styling untuk menyesuaikan dengan tampilan gambar
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 20, thickness: 1, color: Color(0xFFF3F4F6)),
          ...widget.options.map(
                (option) => CheckboxListTile(
              title: Text(option, style: const TextStyle(fontSize: 16)),
              value: _selectedOptions.contains(option),
              onChanged: (bool? selected) {
                _onOptionSelected(selected, option);
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF007BFF),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              // Hilangkan padding bawaan untuk membuatnya lebih rapat
              dense: true,
              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }
}