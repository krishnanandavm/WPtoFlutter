import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> fetchWpPosts() async {
  final response = await http.get(
    Uri.parse("http://wordpresssite.local/wp-json/wp/v2/posts"),
    headers: {
      "Accept": "application/json",
    },
  );

  var convertedDatatoJson = jsonDecode(response.body);

  return convertedDatatoJson;
}

Future<List> fetchWpPostImageUrl( href) async {
  final response = await http.get(
    href, 
    headers: {
      "Accept": "application/json",
    },
  );

  var convertedDatatoJson = jsonDecode(response.body);

  return convertedDatatoJson;
}