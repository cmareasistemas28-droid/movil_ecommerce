import 'package:flutter/material.dart';

import '../widgets/profile_editor_layout.dart';

class ProfileBirthDateEditPage extends StatefulWidget {
  const ProfileBirthDateEditPage({super.key, this.initialDate});
  final DateTime? initialDate;
  @override
  State<ProfileBirthDateEditPage> createState() =>
      _ProfileBirthDateEditPageState();
}

class _ProfileBirthDateEditPageState extends State<ProfileBirthDateEditPage> {
  late DateTime? _selected = widget.initialDate;
  bool _calendarVisible = false;
  bool _missingDate = false;

  void _toggleCalendar() => setState(() {
    _selected ??= DateTime(DateTime.now().year - 18, 1, 1);
    _calendarVisible = !_calendarVisible;
    _missingDate = false;
  });

  void _save() {
    if (_selected == null) {
      setState(() => _missingDate = true);
      return;
    }
    Navigator.pop(context, _selected);
  }

  @override
  Widget build(BuildContext context) => ProfileEditorLayout(
    title: 'Fecha de nacimiento',
    description: 'Actualiza tu fecha de nacimiento. Tu edad se calculará automáticamente.',
    saveLabel: 'Guardar fecha de nacimiento',
    onSave: _save,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Fecha de nacimiento',
          style: TextStyle(fontSize: 16, height: 1.2),
        ),
        const SizedBox(height: 8),
        Semantics(
          button: true,
          label: 'Seleccionar fecha de nacimiento',
          child: InkWell(
            key: const Key('birth-date-input'),
            onTap: _toggleCalendar,
            borderRadius: BorderRadius.circular(14),
            child: InputDecorator(
              decoration: profileEditorInput(
                context,
                label: 'Fecha de nacimiento',
                suffix: const Icon(Icons.calendar_today_outlined),
                error: _missingDate
                    ? 'Selecciona tu fecha de nacimiento.'
                    : null,
              ),
              child: Text(
                _selected == null
                    ? 'Selecciona tu fecha'
                    : MaterialLocalizations.of(context)
                          .formatMediumDate(_selected!),
                style: const TextStyle(fontSize: 18, height: 1.2),
              ),
            ),
          ),
        ),
        if (_calendarVisible) ...[
          const SizedBox(height: 12),
          CalendarDatePicker(
            initialDate: _selected!,
            firstDate: DateTime(1900),
            lastDate: DateUtils.dateOnly(DateTime.now()),
            onDateChanged: (date) => setState(() {
              _selected = date;
              _missingDate = false;
            }),
          ),
        ],
      ],
    ),
  );
}
