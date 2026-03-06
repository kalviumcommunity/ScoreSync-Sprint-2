import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/providers/authProvider.dart';
import '../../services/providers/cloudFunctionsProvider.dart';
import '../../services/providers/scoreProvider.dart';

/// Dashboard page for triggering and monitoring Cloud Functions.
///
/// Provides buttons for each serverless function and shows a live
/// activity log of all function calls with their status and duration.
class CloudFunctionsPage extends StatelessWidget {
  const CloudFunctionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Functions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear history',
            onPressed: () {
              Provider.of<CloudFunctionsProvider>(context, listen: false)
                  .clearHistory();
            },
          ),
        ],
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final cfProvider = Provider.of<CloudFunctionsProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Status banner ──
          _StatusBanner(status: cfProvider.status, error: cfProvider.lastError),
          const SizedBox(height: 20),

          // ── Function trigger cards ──
          const Text(
            'Trigger Cloud Functions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          const _ScoreEventCard(),
          const SizedBox(height: 12),

          const _StatisticsCard(),
          const SizedBox(height: 12),

          const _NotificationCard(),
          const SizedBox(height: 12),

          const _ValidationCard(),
          const SizedBox(height: 12),

          const _BatchProcessingCard(),
          const SizedBox(height: 24),

          // ── Activity log ──
          Row(
            children: [
              const Text(
                'Activity Log',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${cfProvider.callHistory.length} calls',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (cfProvider.callHistory.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'No function calls yet.\nTrigger a function above to see results here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...cfProvider.callHistory.map((r) => _ActivityLogTile(result: r)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Status Banner
// ═══════════════════════════════════════════════════════════════════

class _StatusBanner extends StatelessWidget {
  final CloudFunctionStatus status;
  final String? error;
  const _StatusBanner({required this.status, this.error});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (status) {
      case CloudFunctionStatus.idle:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade700;
        icon = Icons.cloud_queue;
        label = 'Ready — No active function calls';
        break;
      case CloudFunctionStatus.loading:
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade700;
        icon = Icons.cloud_sync;
        label = 'Calling Cloud Function…';
        break;
      case CloudFunctionStatus.success:
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        icon = Icons.cloud_done;
        label = 'Last call succeeded';
        break;
      case CloudFunctionStatus.error:
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        icon = Icons.cloud_off;
        label = error ?? 'Last call failed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
          ),
          if (status == CloudFunctionStatus.loading)
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: fg,
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  1. Score Event Card
// ═══════════════════════════════════════════════════════════════════

class _ScoreEventCard extends StatelessWidget {
  const _ScoreEventCard();

  @override
  Widget build(BuildContext context) {
    return _FunctionCard(
      icon: Icons.bolt,
      color: Colors.orange,
      title: 'Score Event Handler',
      description:
          'Triggers serverless processing when scores are created, '
          'updated, or deleted — updates leaderboards & analytics.',
      buttons: [
        _buildButton(context, 'Created', 'created'),
        _buildButton(context, 'Updated', 'updated'),
        _buildButton(context, 'Deleted', 'deleted'),
      ],
    );
  }

  Widget _buildButton(BuildContext ctx, String label, String eventType) {
    return OutlinedButton(
      onPressed: () => _trigger(ctx, eventType),
      child: Text(label),
    );
  }

  Future<void> _trigger(BuildContext context, String eventType) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final cfProvider =
        Provider.of<CloudFunctionsProvider>(context, listen: false);
    final scores =
        Provider.of<ScoreProvider>(context, listen: false).scores;

    final userId = auth.user?.uid ?? '';
    final scoreId = scores.isNotEmpty ? (scores.first.id ?? 'demo') : 'demo';
    final scoreData = scores.isNotEmpty
        ? {
            'title': scores.first.title,
            'sport': scores.first.sport,
            'homeTeam': scores.first.homeTeam,
            'awayTeam': scores.first.awayTeam,
            'homeScore': scores.first.homeScore,
            'awayScore': scores.first.awayScore,
          }
        : <String, dynamic>{'title': 'Demo Match'};

    final result = await cfProvider.triggerScoreEvent(
      scoreId: scoreId,
      userId: userId,
      eventType: eventType,
      scoreData: scoreData,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.success
                ? 'Score event ($eventType) processed!'
                : result.errorMessage ?? 'Score event failed',
          ),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  2. Statistics Card
// ═══════════════════════════════════════════════════════════════════

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard();

  @override
  Widget build(BuildContext context) {
    return _FunctionCard(
      icon: Icons.bar_chart,
      color: Colors.indigo,
      title: 'Score Statistics',
      description:
          'Aggregates total games, win rates, and per-sport breakdowns '
          'via a serverless function.',
      buttons: [
        ElevatedButton.icon(
          onPressed: () => _fetch(context),
          icon: const Icon(Icons.analytics, size: 18),
          label: const Text('Fetch Statistics'),
        ),
      ],
    );
  }

  Future<void> _fetch(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final cfProvider =
        Provider.of<CloudFunctionsProvider>(context, listen: false);

    final result = await cfProvider.fetchScoreStatistics(
      userId: auth.user?.uid ?? '',
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.success
                ? 'Statistics fetched successfully!'
                : result.errorMessage ?? 'Statistics fetch failed',
          ),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  3. Notification Card
// ═══════════════════════════════════════════════════════════════════

class _ScoreNotificationData {
  String title = '';
  String body = '';
}

class _NotificationCard extends StatefulWidget {
  const _NotificationCard();

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  final _data = _ScoreNotificationData();

  @override
  Widget build(BuildContext context) {
    return _FunctionCard(
      icon: Icons.notifications_active,
      color: Colors.teal,
      title: 'Send Notification',
      description:
          'Dispatches push notifications about score events to '
          'subscribed users via Cloud Functions.',
      extraContent: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Notification Title',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => _data.title = v,
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Notification Body',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => _data.body = v,
          ),
        ],
      ),
      buttons: [
        ElevatedButton.icon(
          onPressed: () => _send(context),
          icon: const Icon(Icons.send, size: 18),
          label: const Text('Send Notification'),
        ),
      ],
    );
  }

  Future<void> _send(BuildContext context) async {
    final cfProvider =
        Provider.of<CloudFunctionsProvider>(context, listen: false);
    final scores =
        Provider.of<ScoreProvider>(context, listen: false).scores;
    final scoreId = scores.isNotEmpty ? (scores.first.id ?? 'demo') : 'demo';

    final result = await cfProvider.sendNotification(
      scoreId: scoreId,
      title: _data.title.isEmpty ? 'Score Update' : _data.title,
      body: _data.body.isEmpty ? 'A score has been updated!' : _data.body,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.success
                ? 'Notification sent!'
                : result.errorMessage ?? 'Notification failed',
          ),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  4. Validation Card
// ═══════════════════════════════════════════════════════════════════

class _ValidationCard extends StatelessWidget {
  const _ValidationCard();

  @override
  Widget build(BuildContext context) {
    return _FunctionCard(
      icon: Icons.verified,
      color: Colors.purple,
      title: 'Validate Score Data',
      description:
          'Sends the most recent score to the server for validation '
          'before persistence. Returns any validation errors.',
      buttons: [
        ElevatedButton.icon(
          onPressed: () => _validate(context),
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: const Text('Validate Latest Score'),
        ),
      ],
    );
  }

  Future<void> _validate(BuildContext context) async {
    final cfProvider =
        Provider.of<CloudFunctionsProvider>(context, listen: false);
    final scores =
        Provider.of<ScoreProvider>(context, listen: false).scores;

    final scoreData = scores.isNotEmpty
        ? scores.first.toFirestore()
        : <String, dynamic>{
            'title': 'Demo Match',
            'sport': 'Football',
            'homeTeam': 'Team A',
            'awayTeam': 'Team B',
            'homeScore': 2,
            'awayScore': 1,
          };

    final result = await cfProvider.validateScore(scoreData: scoreData);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.success
                ? 'Validation passed!'
                : result.errorMessage ?? 'Validation failed',
          ),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  5. Batch Processing Card
// ═══════════════════════════════════════════════════════════════════

class _BatchProcessingCard extends StatelessWidget {
  const _BatchProcessingCard();

  @override
  Widget build(BuildContext context) {
    return _FunctionCard(
      icon: Icons.dynamic_feed,
      color: Colors.deepOrange,
      title: 'Batch Processing',
      description:
          'Triggers batch operations on scores: recalculate aggregates, '
          'export data, or archive old records.',
      buttons: [
        _buildButton(context, 'Recalculate', 'recalculate'),
        _buildButton(context, 'Export', 'export'),
        _buildButton(context, 'Archive', 'archive'),
      ],
    );
  }

  Widget _buildButton(BuildContext ctx, String label, String operation) {
    return OutlinedButton(
      onPressed: () => _trigger(ctx, operation),
      child: Text(label),
    );
  }

  Future<void> _trigger(BuildContext context, String operation) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final cfProvider =
        Provider.of<CloudFunctionsProvider>(context, listen: false);
    final scores =
        Provider.of<ScoreProvider>(context, listen: false).scores;

    final result = await cfProvider.processBatch(
      userId: auth.user?.uid ?? '',
      operation: operation,
      scoreIds: scores
          .where((s) => s.id != null)
          .map((s) => s.id!)
          .toList(),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.success
                ? 'Batch $operation completed!'
                : result.errorMessage ?? 'Batch $operation failed',
          ),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Shared Function Card Shell
// ═══════════════════════════════════════════════════════════════════

class _FunctionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final List<Widget> buttons;
  final Widget? extraContent;

  const _FunctionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.buttons,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            if (extraContent != null) ...[
              const SizedBox(height: 12),
              extraContent!,
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: buttons,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Activity Log Tile
// ═══════════════════════════════════════════════════════════════════

class _ActivityLogTile extends StatelessWidget {
  final FunctionCallResult result;
  const _ActivityLogTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final isSuccess = result.status == CloudFunctionStatus.success;
    final color = isSuccess ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(
          isSuccess ? Icons.check_circle : Icons.error,
          color: color,
        ),
        title: Text(
          result.functionName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          isSuccess
              ? 'Completed in ${result.duration?.inMilliseconds ?? '–'}ms'
              : result.errorMessage ?? 'Unknown error',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Text(
          '${result.timestamp.hour.toString().padLeft(2, '0')}:'
          '${result.timestamp.minute.toString().padLeft(2, '0')}:'
          '${result.timestamp.second.toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
