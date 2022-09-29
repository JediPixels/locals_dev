import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/data_feed_error_model.dart';
import '../models/data_feed_model.dart';
import 'api_values_service.dart';
import 'feed_list_service.dart';

class FeedService {
  static getFeed(FeedListService feedListService, String ssAuthToken) async {
    Map dataBody = {
      'data': {
        'page_size': 10,
        'order': feedListService.dataOrder,
        'lpid': feedListService.dataLpid
      },
    };

    if (ssAuthToken.isNotEmpty) {
      var urlFeed = Uri.https(ApiServiceValues.feedBaseUrl, ApiServiceValues.feedBaseUrlPath);
      await http.post(
        urlFeed,
        headers: {
          'Connection': 'keep-alive',
          'Content-Type': 'application/json',
          'X-APP-AUTH-TOKEN': ssAuthToken,
          'X-DEVICE-ID': ApiServiceValues.deviceId,
        },
        body: jsonEncode(dataBody),
      ).then((responseFeed) {
        if (responseFeed.statusCode == 200) {
          // Check body response for possible 'error' message like wrong credentials
          final String isErrorMessage = responseFeed.body;
          if (isErrorMessage.contains('error')) {
            final dataFeedErrorModel = DataFeedErrorModel.fromRawJson(isErrorMessage);
            feedListService.isFeedLoading = false;
            feedListService.addFeedError('Failed to load feed:\n${dataFeedErrorModel.code}');
            return;
          }

          // Three ways to parse info. Default, via compute, via Isolate.spawn

          // 1. Default
          final localsFeed = DataFeedModel.fromRawJson(responseFeed.body);
          feedListService.addFeed(localsFeed.data);
          feedListService.dataLpid = localsFeed.data.last.id;
          feedListService.isFeedLoading = false;

          // 2. Via compute - Spawn a Isolate
          // FeedServiceBackgroundParser().parseViaCompute(responseFeed.body).then((localsFeed) {
          //   feedListService.addFeed(localsFeed.data);
          //   feedListService.dataLpid = localsFeed.data.last.id;
          //   feedListService.isFeedLoading = false;
          // });

          // 3. Via Isolate.spawn - Manually spawn Isolate plus message
          // FeedServiceBackgroundParser().parseViaIsolate(responseFeed.body).then((localsFeed) {
          //   feedListService.addFeed(localsFeed.data);
          //   feedListService.dataLpid = localsFeed.data.last.id;
          //   feedListService.isFeedLoading = false;
          // });
        } else if (responseFeed.statusCode == 404) {
          feedListService.isFeedLoading = false;
          feedListService.addFeedError('Failed to load feed:\n404 Not Found');
        } else {
          feedListService.isFeedLoading = false;
          feedListService.addFeedError('Failed to load feed:\nUnknown Error');
        }
        feedListService.isFeedLoading = false;
      }).onError((error, stackTrace) {
        feedListService.isFeedLoading = false;
        feedListService.addFeedError('Failed to load feed:\n$error');
      });
    } else {
      feedListService.isFeedLoading = false;
      feedListService.addFeedError('Failed to load feed');
    }
  }
}

@immutable
class FeedServiceBackgroundMessage {
  final SendPort sendPort;
  final String encodedJson;

  const FeedServiceBackgroundMessage({required this.sendPort, required this.encodedJson});
}

class FeedServiceBackgroundParser {
  // Background Parser via compute
  Future<DataFeedModel> parseViaCompute(String encodedJson) async {
    return await compute(_fromRawJsonVuaCompute, encodedJson);
  }

  DataFeedModel _fromRawJsonVuaCompute(String body) {
    return DataFeedModel.fromRawJson(body);
  }

  // Background Parser via Isolate
  Future<DataFeedModel> parseViaIsolate(String encodedJson) async {
    final ReceivePort receivePort = ReceivePort();
    FeedServiceBackgroundMessage feedServiceBackgroundMessage =
      FeedServiceBackgroundMessage(sendPort: receivePort.sendPort, encodedJson: encodedJson);
    await Isolate.spawn(_fromRawJsonViaIsolate, feedServiceBackgroundMessage);
    // Note: Arguments could also be passed as (List<dynamic> parameters)
    // await Isolate.spawn(_fromRawJsonViaIsolate, [receivePort.sendPort, encodedJson]);
    return await receivePort.first;
  }

  void _fromRawJsonViaIsolate(FeedServiceBackgroundMessage feedServiceBackgroundMessage) async {
    SendPort sendPort = feedServiceBackgroundMessage.sendPort;
    String encodedJson = feedServiceBackgroundMessage.encodedJson;
    final result = DataFeedModel.fromRawJson(encodedJson);
    Isolate.exit(sendPort, result);
  }

  // Note: Parameters could also receive Arguments as (List<dynamic> parameters)
  // Future<void> _fromRawJsonViaIsolate(List<dynamic> parameters) {
  //   SendPort sendPort = parameters[0];
  //   String encodedJson = parameters[1];
  //   final result = LocalsDataFeed.fromRawJson(encodedJson);
  //   Isolate.exit(sendPort, result);
  // }
}