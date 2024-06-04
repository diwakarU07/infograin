import 'package:brain_bridge/screens/post.dart';
import 'package:brain_bridge/screens/postApi.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'apiService.dart';

class BackgroundImageWidget extends StatefulWidget {
  const BackgroundImageWidget({super.key});

  @override
  State<BackgroundImageWidget> createState() => _BackgroundImageWidgetState();
}

class _BackgroundImageWidgetState extends State<BackgroundImageWidget> {
  final ApiService apiService = ApiService();

  List<Post> posts = [];

  bool isLoading = true;

  bool hasError = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    print("object");
    try {
      posts = await apiService.fetchPosts();
      setState(() {
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _onRefresh() async {
    await _fetchPosts();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Posts",style: TextStyle(color: Colors.white),),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text('Failed to load posts'))
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: ListView.separated(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return ListTile(
                        title: Text(
                          post.title,
                          style: const TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                          ),
                        ),
                        subtitle: Text(post.body,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailsScreen(post: post),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context , index){
                      return Divider(height: 15, thickness: 2,);
                    },
                  ),
                ),
    );
  }
}
