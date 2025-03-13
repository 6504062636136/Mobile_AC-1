import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2CACA),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.deepPurple[400]),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo2.png',
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'GLAMORA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[400],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '✨ GLAMORA - A Beauty Destination You Can Trust ✨',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'GLAMORA is a premium beauty app that brings together cosmetics and cosmeceuticals from carefully selected brands. We are committed to offering only high-quality, certified, and safe products—so you can shop with confidence, knowing that every choice you make is the right one.',
                          ),
                          SizedBox(height: 15),
                          Text(
                            '💖 Certified Quality',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '- Only products that meet the highest standards make it into our collection.',
                          ),
                          SizedBox(height: 15),
                          Text(
                            '🌿 Where Beauty Meets Science',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '- A perfect fusion of cosmetics and cosmeceuticals for real, visible results.',
                          ),
                          SizedBox(height: 15),
                          Text(
                            '🎀 A Trusted Platform',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '- Shop with ease and 100% confidence in the authenticity of every product.',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'At GLAMORA, we don’t just sell beauty—we deliver trust and confidence. ✨',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20.0,
                      runSpacing: 10.0,
                      children: <Widget>[
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.facebook,
                                color: Colors.blue,
                                size: 40,
                              ),
                              onPressed: () {
                                // TODO: Implement Link Facebook
                              },
                            ),
                            Text(
                              'GLAMORA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [


                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
