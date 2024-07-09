import 'package:flutter/material.dart';
import 'package:wptoflutter/wp_api.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WordPress"),
      ),
      body: FutureBuilder<List>(
        future: fetchWpPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var wppost = snapshot.data![index] as Map<String, dynamic>;
                return PostTile(
                  href: wppost["_links"]["wp:featuredmedia"][0]["href"] as String,
                  title: wppost["title"]["rendered"].replaceAll("#038;", ""),
                  desc: wppost["excerpt"]["rendered"],
                  content: wppost["content"]["rendered"],
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PostTile extends StatefulWidget {
  final String href, title, desc, content;
  const PostTile({
    Key? key,
    required this.content,
    required this.desc,
    required this.href,
    required this.title,
  }) : super(key: key);

  @override
  PostTileState createState() => PostTileState();
}

class PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: fetchWpPostImageUrl(widget.href),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return Image.network(snapshot.data["guid"]["rendered"] as String);
              }
              return const CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 5),
          Text(widget.desc),
        ],
      ),
    );
  }
}
