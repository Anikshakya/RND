import 'package:flutter/material.dart';
import 'package:rnd/src/data/pages_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("RND"),
      ),
      body: ListView.builder(
        itemCount: pageList.length,
        padding: const EdgeInsets.only(top: 10.0),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pageList[index]["title"].toString()),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => pageList[index]["page"] as Widget,));
            },
          );
        },
      ),
    );
  }
}