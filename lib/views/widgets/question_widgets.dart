import 'package:flutter/material.dart';

// Template umum untuk setiap halaman pertanyaan
class QuestionPageContent extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;
  final VoidCallback onContinue;

  const QuestionPageContent({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D1617)), textAlign: TextAlign.center),
          const SizedBox(height: 15),
          Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[600]), textAlign: TextAlign.center),
          const SizedBox(height: 40),
          Expanded(child: Center(child: child)), // Memastikan konten berada di tengah
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: const Color(0xFF82B0F2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}


// Widget untuk Pilihan Jenis Kelamin
class GenderSelection extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const GenderSelection({super.key, required this.onChanged});

  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Menunda pemanggilan agar tidak error saat build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(''); // Memberi tahu parent nilai awal adalah kosong
    });
  }

  void _selectGender(String gender) {
    setState(() => _selectedGender = gender);
    widget.onChanged(gender);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenderOption(
              icon: Icons.male, label: 'Male',
              isSelected: _selectedGender == 'Male',
              onTap: () => _selectGender('Male'),
            ),
            const SizedBox(width: 20),
            GenderOption(
              icon: Icons.female, label: 'Female',
              isSelected: _selectedGender == 'Female',
              onTap: () => _selectGender('Female'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => _selectGender('Prefer not to say'),
          child: Text(
            'Prefer not to say',
            style: TextStyle(
              color: _selectedGender == 'Prefer not to say' ? const Color(0xFF82B0F2) : Colors.grey,
              fontWeight: _selectedGender == 'Prefer not to say' ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class GenderOption extends StatelessWidget {
  final IconData icon; final String label; final bool isSelected; final VoidCallback onTap;
  const GenderOption({super.key, required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF82B0F2).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF82B0F2) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 50, color: isSelected ? const Color(0xFF82B0F2) : Colors.grey[800]),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(
                color: isSelected ? const Color(0xFF82B0F2) : Colors.black87,
                fontWeight: FontWeight.bold, fontSize: 16
            )),
          ],
        ),
      ),
    );
  }
}

// Widget Pemilih Angka Model Roda (Wheel Picker)
class WheelNumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final String unit;
  final ValueChanged<int> onChanged;

  const WheelNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.unit,
    required this.onChanged,
  });

  @override
  State<WheelNumberPicker> createState() => _WheelNumberPickerState();
}

class _WheelNumberPickerState extends State<WheelNumberPicker> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    int initialItem = widget.initialValue - widget.minValue;
    if (initialItem < 0 || initialItem >= (widget.maxValue - widget.minValue + 1)) {
      initialItem = 0;
    }
    _controller = FixedExtentScrollController(initialItem: initialItem);

    // PERBAIKAN: Menunda pemanggilan onChanged
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(widget.minValue + _controller.initialItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: 60,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                widget.onChanged(widget.minValue + index);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.maxValue - widget.minValue + 1,
                builder: (context, index) {
                  final value = widget.minValue + index;
                  return Center(
                    child: Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(widget.unit, style: TextStyle(fontSize: 24, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// Widget Pemilih Waktu Model Roda
class WheelTimePicker extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const WheelTimePicker({super.key, required this.onChanged});

  @override
  State<WheelTimePicker> createState() => _WheelTimePickerState();
}

class _WheelTimePickerState extends State<WheelTimePicker> {
  int _selectedHour = 7;
  int _selectedMinute = 0;
  String _selectedPeriod = 'AM';

  @override
  void initState(){
    super.initState();
    // PERBAIKAN: Menunda pemanggilan onChanged
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateParent();
    });
  }

  void _updateParent() {
    final formattedTime =
        '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} $_selectedPeriod';
    widget.onChanged(formattedTime);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hour Picker
          SizedBox(
            width: 70,
            child: ListWheelScrollView(
              itemExtent: 50,
              onSelectedItemChanged: (index) => setState(() {
                _selectedHour = index + 1;
                _updateParent();
              }),
              controller: FixedExtentScrollController(initialItem: 6),
              children: List.generate(12, (index) => Center(child: Text('${index + 1}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)))),
            ),
          ),
          const Text(':', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          // Minute Picker
          SizedBox(
            width: 70,
            child: ListWheelScrollView(
              itemExtent: 50,
              onSelectedItemChanged: (index) => setState(() {
                _selectedMinute = index;
                _updateParent();
              }),
              children: List.generate(60, (index) => Center(child: Text(index.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)))),
            ),
          ),
          // AM/PM Picker
          SizedBox(
            width: 70,
            child: ListWheelScrollView(
              itemExtent: 50,
              onSelectedItemChanged: (index) => setState(() {
                _selectedPeriod = index == 0 ? 'AM' : 'PM';
                _updateParent();
              }),
              children: const [
                Center(child: Text('AM', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF82B0F2)))),
                Center(child: Text('PM', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF82B0F2)))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk Pilihan Ganda (Single & Multiple Choice)
class ChoiceOptions extends StatefulWidget {
  final List<String> options;
  final bool allowMultiple;
  final ValueChanged<List<String>> onChanged;

  const ChoiceOptions({super.key, required this.options, this.allowMultiple = false, required this.onChanged});

  @override
  State<ChoiceOptions> createState() => _ChoiceOptionsState();
}

class _ChoiceOptionsState extends State<ChoiceOptions> {
  late List<String> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = [];
    // PERBAIKAN: Menunda pemanggilan onChanged
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(_selectedOptions);
    });
  }

  void _toggleOption(String option) {
    setState(() {
      if (widget.allowMultiple) {
        if (_selectedOptions.contains(option)) {
          _selectedOptions.remove(option);
        } else {
          _selectedOptions.add(option);
        }
      } else {
        _selectedOptions.clear();
        _selectedOptions.add(option);
      }
    });
    widget.onChanged(_selectedOptions);
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
        final isSelected = _selectedOptions.contains(option);
        return GestureDetector(
          onTap: () => _toggleOption(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF82B0F2).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF82B0F2) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Text(
              option,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF82B0F2) : Colors.black87,
                  fontSize: 16
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget untuk Pilihan Ganda dengan Deskripsi
class ChoiceOptionsWithDescription extends StatefulWidget {
  final List<Map<String, String>> options;
  final ValueChanged<String> onChanged;

  const ChoiceOptionsWithDescription({super.key, required this.options, required this.onChanged});

  @override
  State<ChoiceOptionsWithDescription> createState() => _ChoiceOptionsWithDescriptionState();
}

class _ChoiceOptionsWithDescriptionState extends State<ChoiceOptionsWithDescription> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    // PERBAIKAN: Menunda pemanggilan onChanged
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged('');
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
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF82B0F2).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF82B0F2) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option['title']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF82B0F2) : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  option['description']!,
                  style: TextStyle(
                    color: isSelected ? Colors.black54 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

