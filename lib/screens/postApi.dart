
import 'package:brain_bridge/screens/post.dart';
import 'package:flutter/material.dart';
import 'apiService.dart';
import 'comment.dart';


class PostDetailsScreen extends StatelessWidget {
  final Post post;

  PostDetailsScreen({required this.post});

  final ApiService apiService = ApiService();

  Future<List<Comments>>? _fetchComments() async {
    return await apiService.fetchComments(post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: FutureBuilder<List<Comments>>(
        future: _fetchComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load comments'));
          } else {
            final comments = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(post.body, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    Text('Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ...comments.map((comment) => Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(comment.name),
                        subtitle: Text(comment.body),
                        trailing: Text(comment.email),
                      ),
                    )),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}