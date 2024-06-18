import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this dependency to use url_launcher

class Footer extends StatelessWidget {
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[900], // Background color of the footer
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shortcut Hub', // Replace with your app name
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () => _launchURL('https://github.com/your_project'), // Replace with your GitHub project URL
                child: Row(
                  children: [
                    Icon(
                      Icons.code,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Shortcut Hub GitHub Repo',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Me',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Tech enthusiast skilled in web and Android development, with a passion for drawing.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    InkWell(
                      onTap: () => _launchURL('https://arine-project.vercel.app/'),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/arine_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'My Portofolio',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _launchURL('https://x.com/_ArinEmir_'),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/twitter_icon.png',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'My Twitter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  InkWell(
                    onTap: () => _launchURL('https://github.com/KiraneTMS'),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/github_icon.png', // Use your Facebook icon
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'My Github',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add more social media links as needed
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}