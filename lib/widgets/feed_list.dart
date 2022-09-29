import 'package:flutter/material.dart';
import '../models/data_feed_model.dart';
import 'feed_item.dart';


class FeedListView extends StatelessWidget {
  const FeedListView({Key? key, required this.feed, required this.scrollController}) : super(key: key);

  final List<Feed> feed;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: feed.length,
      itemBuilder: (BuildContext context, int index) {
        // Future features can contain a stack to add a Spinner to show loading
        // at the bottom of the page
        return FeedItem(feed: feed, index: index,);
      },
    );
  }
}
