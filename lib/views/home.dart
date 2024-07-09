import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordpress_task/wp_api.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WordPress"),
      ),
      body: Container(
        child: FutureBuilder<List>(
          future: fetchWpPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text('No data found'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  var wppost = snapshot.data![index] as Map<String, dynamic>; // Cast to Map
                  return PostTile(href: wppost["_links"]["wp:featuredmedia:"][0]["href"],
                  title: wppost["title"]["rendered"].replaceAll("#038;",""),
                  desc: wppost["excerpt"]["rendered"],
                  content: wppost["content"]["rendered"], );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}


class PostTile extends StatefulWidget {
  final String href, title, desc, content;
  PostTile({this.content, this.desc, this.href, this.title});
  @override
  PostTileState createState() => PostTileState();
}
class PostTileState extends State<PostTile>{
  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FutureBuilder(
        future: fetchWpPostImageUrl(widget.href), 
        builder: (context, snapshot){
          if (snapshot.hasData) {
            return Image.network(snapshot.data["guig"]["rendered"]);
          }
          return CircularProgressIndicator();
        },),
        SizedBox(height: 8),
        Text(
          widget.title, 
          style: TextStyle(fontSize: 18),
          ),
        SizedBox(height: 5),
        Text(widget.desc)
      ])
    );
  }
  
}