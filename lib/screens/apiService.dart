import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:brain_bridge/screens/post.dart';

import 'comment.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Comments>> fetchComments(int postId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$postId/comments'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map<Comments>((json) => Comments.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }
}