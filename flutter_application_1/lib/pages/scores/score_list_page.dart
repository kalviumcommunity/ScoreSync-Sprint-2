import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/providers/scoreProvider.dart';
import '../../services/models/score_item.dart';
import 'score_form_page.dart';

/// Displays all score items for the authenticated user in a list.
/// Supports pull-to-refresh, swipe-to-delete, and tap-to-edit.
class ScoreListPage extends StatelessWidget {
  const ScoreListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<ScoreProvider>(context);

    if (scoreProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (scoreProvider.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              scoreProvider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    if (scoreProvider.scores.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.scoreboard_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No scores yet.\nTap + to add your first score!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: scoreProvider.scores.length,
      itemBuilder: (context, index) {
        final item = scoreProvider.scores[index];
        return _ScoreCard(item: item);
      },
    );
  }
}

// ─────────────────────── Score Card ───────────────────────

class _ScoreCard extends StatelessWidget {
  final ScoreItem item;
  const _ScoreCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);

    return Dismissible(
      key: Key(item.id ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        if (item.id != null) {
          scoreProvider.deleteScore(item.id!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deleted "${item.title}"')),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openEditForm(context, item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & sport chip
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(item.sport,
                          style: const TextStyle(fontSize: 12)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Score row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.homeTeam,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      '${item.homeScore}  -  ${item.awayScore}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.awayTeam,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Date
                Text(
                  '${item.date.day}/${item.date.month}/${item.date.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Score'),
        content: Text('Are you sure you want to delete "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openEditForm(BuildContext context, ScoreItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScoreFormPage(existingItem: item),
      ),
    );
  }
}
