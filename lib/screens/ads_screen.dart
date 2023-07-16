import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommercialPage extends StatelessWidget {
  final int selectedTab;
  CommercialPage({super.key, required this.selectedTab});

  final List<String> promoImages = [
    'assets/promo2.jpg',
    'assets/promo3.jpg',
    'assets/promo4.jpg',
    'assets/promo5.jpg',
    'assets/promo1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              expandedHeight: 270,
              floating: false,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                title: Text('PARTNERS',
                    style: GoogleFonts.signika(fontWeight: FontWeight.bold)),
                background: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              backgroundColor: Color(0xFF609966),
            )
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color(0xFF609966),
                Color(0xFF175124),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: promoImages.length,
                  itemBuilder: (context, index) {
                    String imagePath = promoImages[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Material(
                          elevation: 5,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
