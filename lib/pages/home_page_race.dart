import 'package:chaskis/utils/custom_text.dart';
import 'package:flutter/material.dart';

class HomePageRace extends StatelessWidget {
  const HomePageRace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: Colors.black,
                  child: ListTile(
                    leading: Icon(Icons.check_box, color: Colors.red,),
                    title: H2Text(
                      text: 'Check List',
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
                Card(
                  color: Colors.black,
                  child: ListTile(
                    leading: Icon(Icons.check_box, color: Colors.red,),
                    title: H2Text(
                      text: 'Check Points',
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
                Card(
                  color: Colors.black,
                  child: ListTile(
                    leading: Icon(Icons.check_box, color: Colors.red,),
                    title: H2Text(
                      text: 'Guarda Ropa',
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
