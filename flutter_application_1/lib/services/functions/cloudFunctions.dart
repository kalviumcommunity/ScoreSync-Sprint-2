import 'package:cloud_functions/cloud_functions.dart';

/// Result wrapper for Cloud Function responses.
class CloudFunctionResult {
  final bool success;
  final dynamic data;
  final String? errorMessage;

  CloudFunctionResult({
    required this.success,
    this.data,
    this.errorMessage,
  });

  factory CloudFunctionResult.fromResponse(Map<String, dynamic> response) {
    return CloudFunctionResult(
      success: response['success'] ?? false,
      data: response['data'],
      errorMessage: response['error'],
    );
  }

  factory CloudFunctionResult.error(String message) {
    return CloudFunctionResult(
      success: false,
      errorMessage: message,
    );
  }
}

/// Service class that handles all Firebase Cloud Functions calls.
///
/// Each method wraps a callable Cloud Function, providing:
/// - Type-safe parameters
/// - Structured error handling
/// - Timeout configuration
///
/// Cloud Functions triggered:
/// 1. **onScoreEvent**      – Processes score creation/update events serverlessly
/// 2. **getScoreStatistics** – Aggregates score statistics for a user
/// 3. **sendScoreNotification** – Sends push notifications for score events
/// 4. **validateScoreData** – Server-side validation of score data
/// 5. **processScoreBatch** – Batch processes multiple scores at once
class CloudFunctions {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Default timeout for cloud function calls.
  static const Duration _defaultTimeout = Duration(seconds: 60);

  // ━━━━━━━━━━━━━━━━━━  1. Score Event Processing  ━━━━━━━━━━━━━━━━━━

  /// Triggers the `onScoreEvent` Cloud Function to handle serverless
  /// processing when a score is created, updated, or deleted.
  ///
  /// The function performs server-side tasks such as:
  /// - Updating leaderboard aggregates
  /// - Logging analytics events
  /// - Triggering downstream workflows
  Future<CloudFunctionResult> triggerScoreEvent({
    required String scoreId,
    required String userId,
    required String eventType, // 'created' | 'updated' | 'deleted'
    Map<String, dynamic>? scoreData,
  }) async {
    try {
      final callable = _functions.httpsCallable(
        'onScoreEvent',
        options: HttpsCallableOptions(timeout: _defaultTimeout),
      );

      final result = await callable.call<Map<String, dynamic>>({
        'scoreId': scoreId,
        'userId': userId,
        'eventType': eventType,
        'scoreData': scoreData,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return CloudFunctionResult.fromResponse(
        Map<String, dynamic>.from(result.data),
      );
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResult.error(
        'Score event failed [${e.code}]: ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResult.error('Score event failed: $e');
    }
  }

  // ━━━━━━━━━━━━━━━━━━  2. Score Statistics  ━━━━━━━━━━━━━━━━━━

  /// Calls the `getScoreStatistics` Cloud Function to compute aggregate
  /// stats across a user's scores (total games, win rate, sport breakdown).
  Future<CloudFunctionResult> getScoreStatistics({
    required String userId,
    String? sport, // optional filter by sport
  }) async {
    try {
      final callable = _functions.httpsCallable(
        'getScoreStatistics',
        options: HttpsCallableOptions(timeout: _defaultTimeout),
      );

      final params = <String, dynamic>{
        'userId': userId,
      };
      if (sport != null) params['sport'] = sport;

      final result = await callable.call<Map<String, dynamic>>(params);

      return CloudFunctionResult.fromResponse(
        Map<String, dynamic>.from(result.data),
      );
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResult.error(
        'Statistics fetch failed [${e.code}]: ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResult.error('Statistics fetch failed: $e');
    }
  }

  // ━━━━━━━━━━━━━━━━━━  3. Score Notifications  ━━━━━━━━━━━━━━━━━━

  /// Calls the `sendScoreNotification` Cloud Function to dispatch push
  /// notifications about score events to subscribed users.
  Future<CloudFunctionResult> sendScoreNotification({
    required String scoreId,
    required String title,
    required String body,
    List<String>? targetUserIds,
  }) async {
    try {
      final callable = _functions.httpsCallable(
        'sendScoreNotification',
        options: HttpsCallableOptions(timeout: _defaultTimeout),
      );

      final result = await callable.call<Map<String, dynamic>>({
        'scoreId': scoreId,
        'notification': {
          'title': title,
          'body': body,
        },
        'targetUserIds': targetUserIds,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return CloudFunctionResult.fromResponse(
        Map<String, dynamic>.from(result.data),
      );
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResult.error(
        'Notification failed [${e.code}]: ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResult.error('Notification failed: $e');
    }
  }

  // ━━━━━━━━━━━━━━━━━━  4. Score Validation  ━━━━━━━━━━━━━━━━━━

  /// Calls the `validateScoreData` Cloud Function to perform server-side
  /// validation of score data before persisting it.
  ///
  /// Returns validation errors (if any) in the `data` field.
  Future<CloudFunctionResult> validateScoreData({
    required Map<String, dynamic> scoreData,
  }) async {
    try {
      final callable = _functions.httpsCallable(
        'validateScoreData',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );

      final result = await callable.call<Map<String, dynamic>>({
        'scoreData': scoreData,
      });

      return CloudFunctionResult.fromResponse(
        Map<String, dynamic>.from(result.data),
      );
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResult.error(
        'Validation failed [${e.code}]: ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResult.error('Validation failed: $e');
    }
  }

  // ━━━━━━━━━━━━━━━━━━  5. Batch Processing  ━━━━━━━━━━━━━━━━━━

  /// Calls the `processScoreBatch` Cloud Function to process multiple
  /// score records at once (e.g. bulk import, recalculate stats).
  Future<CloudFunctionResult> processScoreBatch({
    required String userId,
    required String operation, // 'recalculate' | 'export' | 'archive'
    List<String>? scoreIds,
  }) async {
    try {
      final callable = _functions.httpsCallable(
        'processScoreBatch',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 120),
        ),
      );

      final result = await callable.call<Map<String, dynamic>>({
        'userId': userId,
        'operation': operation,
        'scoreIds': scoreIds,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return CloudFunctionResult.fromResponse(
        Map<String, dynamic>.from(result.data),
      );
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResult.error(
        'Batch processing failed [${e.code}]: ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResult.error('Batch processing failed: $e');
    }
  }
}
