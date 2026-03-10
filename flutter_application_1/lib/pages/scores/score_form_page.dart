import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/providers/authProvider.dart';
import '../../services/providers/scoreProvider.dart';
import '../../services/models/score_item.dart';

/// A form page for creating a new score item or editing an existing one.
/// When [existingItem] is provided the form is in **edit** mode.
class ScoreFormPage extends StatefulWidget {
  final ScoreItem? existingItem;

  const ScoreFormPage({super.key, this.existingItem});

  @override
  State<ScoreFormPage> createState() => _ScoreFormPageState();
}

class _ScoreFormPageState extends State<ScoreFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _homeTeamCtrl;
  late final TextEditingController _awayTeamCtrl;
  late final TextEditingController _homeScoreCtrl;
  late final TextEditingController _awayScoreCtrl;

  String _selectedSport = 'Football';
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  bool get _isEditing => widget.existingItem != null;

  static const List<String> _sports = [
    'Football',
    'Basketball',
    'Baseball',
    'Hockey',
    'Soccer',
    'Tennis',
    'Rugby',
    'Cricket',
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    _titleCtrl = TextEditingController(text: item?.title ?? '');
    _homeTeamCtrl = TextEditingController(text: item?.homeTeam ?? '');
    _awayTeamCtrl = TextEditingController(text: item?.awayTeam ?? '');
    _homeScoreCtrl =
        TextEditingController(text: item != null ? '${item.homeScore}' : '');
    _awayScoreCtrl =
        TextEditingController(text: item != null ? '${item.awayScore}' : '');
    if (item != null) {
      _selectedSport = item.sport;
      _selectedDate = item.date;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _homeTeamCtrl.dispose();
    _awayTeamCtrl.dispose();
    _homeScoreCtrl.dispose();
    _awayScoreCtrl.dispose();
    super.dispose();
  }

  // ────────────────────── Build ──────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Score' : 'Add Score'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Title ──
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Match Title',
                  hintText: 'e.g. Super Bowl LXII',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              // ── Sport dropdown ──
              DropdownButtonFormField<String>(
                value: _selectedSport,
                decoration: const InputDecoration(
                  labelText: 'Sport',
                  border: OutlineInputBorder(),
                ),
                items: _sports
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedSport = v);
                },
              ),
              const SizedBox(height: 16),

              // ── Teams row ──
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _homeTeamCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Home Team',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('vs', style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _awayTeamCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Away Team',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Scores row ──
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _homeScoreCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Home Score',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (int.tryParse(v.trim()) == null) {
                          return 'Enter a number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _awayScoreCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Away Score',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (int.tryParse(v.trim()) == null) {
                          return 'Enter a number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Date picker ──
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _pickDate,
              ),
              const SizedBox(height: 24),

              // ── Submit button ──
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEditing ? 'Update Score' : 'Add Score'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────── Helpers ──────────────────────

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
    final userId = authProvider.user?.uid ?? '';

    final item = ScoreItem(
      id: widget.existingItem?.id,
      userId: userId,
      title: _titleCtrl.text.trim(),
      sport: _selectedSport,
      homeTeam: _homeTeamCtrl.text.trim(),
      awayTeam: _awayTeamCtrl.text.trim(),
      homeScore: int.parse(_homeScoreCtrl.text.trim()),
      awayScore: int.parse(_awayScoreCtrl.text.trim()),
      date: _selectedDate,
      createdAt: widget.existingItem?.createdAt,
    );

    try {
      if (_isEditing) {
        await scoreProvider.updateScore(item);
      } else {
        await scoreProvider.addScore(item);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Score updated!' : 'Score added!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
