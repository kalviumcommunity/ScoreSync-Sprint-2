import 'package:flutter/material.dart';
import '../functions/cloudFunctions.dart';

/// Represents the current status of a Cloud Function call.
enum CloudFunctionStatus { idle, loading, success, error }

/// Holds the result of a single Cloud Function invocation for display.
class FunctionCallResult {
  final String functionName;
  final CloudFunctionStatus status;
  final dynamic data;
  final String? errorMessage;
  final DateTime timestamp;
  final Duration? duration;

  FunctionCallResult({
    required this.functionName,
    required this.status,
    this.data,
    this.errorMessage,
    DateTime? timestamp,
    this.duration,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Provider that manages Cloud Function calls and their state.
///
/// Exposes methods corresponding to each Cloud Function and tracks:
/// - Per-function loading state
/// - Call history / results log
/// - Error messages
class CloudFunctionsProvider extends ChangeNotifier {
  final CloudFunctions _cloudFunctions = CloudFunctions();

  // ── State ──

  CloudFunctionStatus _status = CloudFunctionStatus.idle;
  CloudFunctionStatus get status => _status;

  final List<FunctionCallResult> _callHistory = [];
  List<FunctionCallResult> get callHistory =>
      List.unmodifiable(_callHistory);

  String? _lastError;
  String? get lastError => _lastError;

  Map<String, dynamic>? _statistics;
  Map<String, dynamic>? get statistics => _statistics;

  // ── Helpers ──

  void _addResult(FunctionCallResult result) {
    _callHistory.insert(0, result); // newest first
    if (_callHistory.length > 50) _callHistory.removeLast(); // cap history
    notifyListeners();
  }

  void clearHistory() {
    _callHistory.clear();
    _lastError = null;
    _status = CloudFunctionStatus.idle;
    notifyListeners();
  }

  // ━━━━━━━━━━━━━━━━━━  1. Trigger Score Event  ━━━━━━━━━━━━━━━━━━

  /// Triggers the serverless score event handler.
  Future<CloudFunctionResult> triggerScoreEvent({
    required String scoreId,
    required String userId,
    required String eventType,
    Map<String, dynamic>? scoreData,
  }) async {
    _status = CloudFunctionStatus.loading;
    _lastError = null;
    notifyListeners();

    final stopwatch = Stopwatch()..start();

    final result = await _cloudFunctions.triggerScoreEvent(
      scoreId: scoreId,
      userId: userId,
      eventType: eventType,
      scoreData: scoreData,
    );

    stopwatch.stop();

    if (result.success) {
      _status = CloudFunctionStatus.success;
      _addResult(FunctionCallResult(
        functionName: 'onScoreEvent ($eventType)',
        status: CloudFunctionStatus.success,
        data: result.data,
        duration: stopwatch.elapsed,
      ));
    } else {
      _status = CloudFunctionStatus.error;
      _lastError = result.errorMessage;
      _addResult(FunctionCallResult(
        functionName: 'onScoreEvent ($eventType)',
        status: CloudFunctionStatus.error,
        errorMessage: result.errorMessage,
        duration: stopwatch.elapsed,
      ));
    }

    return result;
  }

  // ━━━━━━━━━━━━━━━━━━  2. Get Score Statistics  ━━━━━━━━━━━━━━━━━━

  /// Fetches aggregated score statistics from the cloud.
  Future<CloudFunctionResult> fetchScoreStatistics({
    required String userId,
    String? sport,
  }) async {
    _status = CloudFunctionStatus.loading;
    _lastError = null;
    notifyListeners();

    final stopwatch = Stopwatch()..start();

    final result = await _cloudFunctions.getScoreStatistics(
      userId: userId,
      sport: sport,
    );

    stopwatch.stop();

    if (result.success) {
      _status = CloudFunctionStatus.success;
      _statistics = result.data is Map<String, dynamic>
          ? result.data as Map<String, dynamic>
          : null;
      _addResult(FunctionCallResult(
        functionName: 'getScoreStatistics',
        status: CloudFunctionStatus.success,
        data: result.data,
        duration: stopwatch.elapsed,
      ));
    } else {
      _status = CloudFunctionStatus.error;
      _lastError = result.errorMessage;
      _addResult(FunctionCallResult(
        functionName: 'getScoreStatistics',
        status: CloudFunctionStatus.error,
        errorMessage: result.errorMessage,
        duration: stopwatch.elapsed,
      ));
    }

    return result;
  }

  // ━━━━━━━━━━━━━━━━━━  3. Send Notification  ━━━━━━━━━━━━━━━━━━

  /// Sends a score notification via Cloud Functions.
  Future<CloudFunctionResult> sendNotification({
    required String scoreId,
    required String title,
    required String body,
    List<String>? targetUserIds,
  }) async {
    _status = CloudFunctionStatus.loading;
    _lastError = null;
    notifyListeners();

    final stopwatch = Stopwatch()..start();

    final result = await _cloudFunctions.sendScoreNotification(
      scoreId: scoreId,
      title: title,
      body: body,
      targetUserIds: targetUserIds,
    );

    stopwatch.stop();

    if (result.success) {
      _status = CloudFunctionStatus.success;
      _addResult(FunctionCallResult(
        functionName: 'sendScoreNotification',
        status: CloudFunctionStatus.success,
        data: result.data,
        duration: stopwatch.elapsed,
      ));
    } else {
      _status = CloudFunctionStatus.error;
      _lastError = result.errorMessage;
      _addResult(FunctionCallResult(
        functionName: 'sendScoreNotification',
        status: CloudFunctionStatus.error,
        errorMessage: result.errorMessage,
        duration: stopwatch.elapsed,
      ));
    }

    return result;
  }

  // ━━━━━━━━━━━━━━━━━━  4. Validate Score Data  ━━━━━━━━━━━━━━━━━━

  /// Validates score data server-side before saving.
  Future<CloudFunctionResult> validateScore({
    required Map<String, dynamic> scoreData,
  }) async {
    _status = CloudFunctionStatus.loading;
    _lastError = null;
    notifyListeners();

    final stopwatch = Stopwatch()..start();

    final result = await _cloudFunctions.validateScoreData(
      scoreData: scoreData,
    );

    stopwatch.stop();

    if (result.success) {
      _status = CloudFunctionStatus.success;
      _addResult(FunctionCallResult(
        functionName: 'validateScoreData',
        status: CloudFunctionStatus.success,
        data: result.data,
        duration: stopwatch.elapsed,
      ));
    } else {
      _status = CloudFunctionStatus.error;
      _lastError = result.errorMessage;
      _addResult(FunctionCallResult(
        functionName: 'validateScoreData',
        status: CloudFunctionStatus.error,
        errorMessage: result.errorMessage,
        duration: stopwatch.elapsed,
      ));
    }

    return result;
  }

  // ━━━━━━━━━━━━━━━━━━  5. Batch Processing  ━━━━━━━━━━━━━━━━━━

  /// Triggers batch processing of scores (recalculate, export, archive).
  Future<CloudFunctionResult> processBatch({
    required String userId,
    required String operation,
    List<String>? scoreIds,
  }) async {
    _status = CloudFunctionStatus.loading;
    _lastError = null;
    notifyListeners();

    final stopwatch = Stopwatch()..start();

    final result = await _cloudFunctions.processScoreBatch(
      userId: userId,
      operation: operation,
      scoreIds: scoreIds,
    );

    stopwatch.stop();

    if (result.success) {
      _status = CloudFunctionStatus.success;
      _addResult(FunctionCallResult(
        functionName: 'processScoreBatch ($operation)',
        status: CloudFunctionStatus.success,
        data: result.data,
        duration: stopwatch.elapsed,
      ));
    } else {
      _status = CloudFunctionStatus.error;
      _lastError = result.errorMessage;
      _addResult(FunctionCallResult(
        functionName: 'processScoreBatch ($operation)',
        status: CloudFunctionStatus.error,
        errorMessage: result.errorMessage,
        duration: stopwatch.elapsed,
      ));
    }

    return result;
  }
}
