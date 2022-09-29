import 'package:flutter/material.dart';
import '../models/data_feed_model.dart';
import '../services/auth_service.dart';
import '../services/connection_service.dart';
import '../services/feed_list_service.dart';
import '../services/feed_service.dart';
import '../widgets/feed_list.dart';
import '../widgets/sort_by.dart';
import '../widgets/status_message.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService authService = AuthService();
  final FeedListService feedListService = FeedListService();
  final ScrollController scrollController = ScrollController();
  AuthServiceResponse authServiceResponse = AuthServiceResponse();
  bool internetConnectionAvailability = true;

  @override
  void initState() {
    super.initState();

    getAuth();
    scrollController.addListener(() {
      // Check if scroll has reached the bottom, then retrieve next 10 feeds
      if (scrollController.offset == scrollController.position.maxScrollExtent && !feedListService.isFeedLoading) {
        getFeed();
      }
    });
  }

  @override
  void dispose() {
    // authService does not need disposing
    feedListService.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> checkInternetConnection() async {
    internetConnectionAvailability = await ConnectionService.isInternetConnectionAvailable();
    if (!internetConnectionAvailability) {
      feedListService.isFeedLoading = false;
      feedListService.addFeedError('Internet connection is not available');
    }
    return internetConnectionAvailability;
  }

  Future<void> getAuth() async {
    internetConnectionAvailability = await checkInternetConnection();
    if (!internetConnectionAvailability) {
      return;
    }

    // Look for credential error
    authServiceResponse = await AuthService.login();
    if (authServiceResponse.statusCode == 200 && authServiceResponse.error != 'Error Response') {
      feedListService.isFeedLoading = false;
      getFeed();
    } else {
      feedListService.isFeedLoading = false;
      final String finalError = authServiceResponse.error + authServiceResponse.errorAdditionalDescription;
      feedListService.addFeedError(finalError);
    }
  }

  Future<void> getFeed() async {
    if (feedListService.isFeedLoading) {
      return;
    }
    feedListService.isFeedLoading = true;

    // Make sure we did not loose connectivity since our last feed fetch
    internetConnectionAvailability = await checkInternetConnection();
    if (!internetConnectionAvailability) {
      return;
    }

    // Future enhancement: Check if authServiceResponse is not expired, otherwise re-Auth
    if (authServiceResponse.ssAuthToken.isEmpty) {
      getAuth();
      return;
    }

    FeedService.getFeed(feedListService, authServiceResponse.ssAuthToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          SortBy(
              selected: feedListService.dataOrder,
              onChanged: (dataOrder) {
                // If user changed the Sort By, reset the  dataLpid to zero
                if (feedListService.dataOrder != dataOrder) {
                  feedListService.dataLpid = 0;
                  feedListService.clearFeed();
                }
                setState(() {
                  feedListService.dataOrder = dataOrder;
                });
                getFeed();
              }),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getFeed,
          child: StreamBuilder(
            initialData: const [],
            stream: feedListService.listFeed,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!internetConnectionAvailability) {
                return const StatusMessage(
                  message: 'Internet connection is not available',
                  bannerMessage: 'none',
                  bannerColor: Colors.yellow,
                  textColor: Colors.black,
                );
              }

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                  if (snapshot.hasError) {
                    return StatusMessage(bannerMessage: 'error', message: '${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final feed = snapshot.data as List<Feed>;
                    return FeedListView(feed: feed, scrollController: scrollController,);
                  } else {
                    return const StatusMessage(bannerMessage: 'error', message: 'Not able to retrieve feed');
                  }
                default:
                  return const StatusMessage(
                    message: 'Nothing to Show',
                    bannerMessage: 'nothing',
                    bannerColor: Colors.yellow,
                    textColor: Colors.black,
                  );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getFeed,
        tooltip: 'Load More...',
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
