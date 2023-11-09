import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use the gradient as the main background of the Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xbc175124), Color(0xff175124)],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Contacts",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white, // Ensuring text is visible on green background
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: const [
                  DeveloperDetailWidget(
                    name: 'Rupal, Franz Adrian G.',
                    email: 'franzrupal@gmail.com',
                    imagePath: 'assets/franzpng.png',
                  ),
                  DeveloperDetailWidget(
                    name: 'Arceño, Joshua Carl M.',
                    email: 'joshuacarl16@gmail.com',
                    imagePath: 'assets/carlpng.png',
                  ),
                  DeveloperDetailWidget(
                    name: 'Palalay, Julius D.',
                    email: 'juljulducante@gmail.com',
                    imagePath: 'assets/juliuspng.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperDetailWidget extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;

  const DeveloperDetailWidget({
    Key? key,
    required this.name,
    required this.email,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.asset(
                imagePath,
                width: 100, // Adjust the size to fit your layout
                height: 100,
                fit: BoxFit.cover, // Cover the container bounds
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
