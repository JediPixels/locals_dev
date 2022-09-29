import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/data_feed_model.dart';
import '../services/time_ago_service.dart';

class FeedItem extends StatelessWidget {
  const FeedItem({
    Key? key,
    required this.feed,
    required this.index,
  }) : super(key: key);

  final List<Feed> feed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24.0, top: 24.0),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  CircleAvatar(backgroundImage: Image
                      .network(feed[index].authorAvatarUrl)
                      .image),
                  const Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: FractionalTranslation(
                      translation: Offset(0.5, 0),
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.verified_outlined,
                          size: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feed[index].authorName),
                  Text(TimeAgoService.getTimeAgoSinceDateTime(feed[index].timestamp)),
                ],
              ),
              const Spacer(),
              Transform.rotate(
                angle: math.pi / 4,
                child: Icon(
                  Icons.push_pin,
                  color: feed[index].bookmarked ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24.0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feed[index].title, style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),
              Text(feed[index].text, style: Theme.of(context).textTheme.subtitle2,),
              const SizedBox(height: 4,)
            ],
          ),
        ),
        Container(height: 1, color: Colors.grey, margin: const EdgeInsets.only(top: 14, bottom: 14),),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24.0,),
          child: Row(
            children: [
              Icon(
                Icons.thumb_up_sharp,
                color: feed[index].totalPostViews > 0 ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text('${feed[index].totalPostViews}',
                style: TextStyle(
                  color: feed[index].totalPostViews > 0 ? Colors.red : Colors.grey,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}