import 'dart:async';
import '../models/data_feed_model.dart';

class FeedListService {
  bool isFeedLoading = false;
  String dataOrder = 'recent';
  int dataLpid = 0;
  List<Feed> feedList = <Feed>[];

  final StreamController<List<Feed>> _feedController = StreamController<List<Feed>>.broadcast();
  Sink<List<Feed>> get _addListFeed => _feedController.sink;
  Stream<List<Feed>> get listFeed => _feedController.stream;

  FeedListService() {
    startListeners();
  }

  void dispose() {
    _feedController.close();
  }

  void startListeners() {
    _feedController.stream.listen((feed) {
      isFeedLoading = false;
    });
  }

  void addFeed(List<Feed> addToFeedList) {
    // Add new Feeds to the existing Feeds List
    if (addToFeedList.isNotEmpty) {
      feedList.addAll(addToFeedList);
    }
    isFeedLoading = true;
    _addListFeed.add(feedList);
  }

  void addFeedError(error) {
    isFeedLoading = false;
    _feedController.addError('Error: $error');
  }

  void clearFeed() {
    feedList.clear();
    _addListFeed.add([]);
  }
}