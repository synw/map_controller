import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            if (!kIsWeb)
              MainButton(
                icon: Icons.filter,
                text: "Geojson",
                link: "/geojson",
              ),
            MainButton(
              icon: Icons.location_on,
              text: "Markers",
              link: "/markers",
            ),
            MainButton(
              icon: Icons.edit_location,
              text: "Stateful markers",
              link: "/stateful_markers",
            ),
            MainButton(
              icon: Icons.map,
              text: "Tile layer",
              link: "/tile_layer",
            ),
          ]),
    ));
  }
}

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.link,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final String link;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(children: <Widget>[
        Icon(icon, size: 85.0, color: Colors.grey),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
          child: Text(text,
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
              style: const TextStyle(color: Colors.grey)),
        )
      ]),
      onTap: () => Navigator.of(context).pushNamed(link),
    );
  }
}
