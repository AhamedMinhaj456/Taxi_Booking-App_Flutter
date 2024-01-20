import 'package:flutter/material.dart';

class Promotion {
  final String title;
  final String description;
  final IconData iconData;

  Promotion({
    required this.title,
    required this.description,
    required this.iconData,
  });
}

class PromotionListPage extends StatelessWidget {
  final List<Promotion> promotions = [
    Promotion(
      title: 'Weekend Special',
      description: 'Get 20% off on your weekend rides. Use code: WEEKEND20',
      iconData: Icons.weekend,
    ),
    Promotion(
      title: 'New User Offer',
      description: 'First-time users enjoy a free ride up to Rs.200. Use code: NEWUSER',
      iconData: Icons.person_add,
    ),
     Promotion(
      title: 'New User Offer',
      description: 'First-time users enjoy a free ride up to Rs.200. Use code: NEWUSER',
      iconData: Icons.person_add,
    ),
     Promotion(
  title: 'Holiday Getaway',
  description: 'Plan a holiday trip and enjoy 15% off. Use code: HOLIDAY15',
  iconData: Icons.flight,
),
Promotion(
  title: 'Refer a Friend',
  description: 'Refer a friend and both get Rs.200 credit. Share your referral code now!',
  iconData: Icons.people,
),
Promotion(
  title: 'Night Out Discount',
  description: 'Get 10% off on rides between 8 PM - 12 AM. Use code: NIGHT10',
  iconData: Icons.nightlife,
),
Promotion(
  title: 'City Explorer',
  description: 'Explore the city with 5 consecutive rides and get the 6th ride free!',
  iconData: Icons.location_city,
),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
      ),
      body: ListView.builder(
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          return PromotionItem(promotion: promotions[index]);
        },
      ),
    );
  }
}

class PromotionItem extends StatelessWidget {
  final Promotion promotion;

  PromotionItem({required this.promotion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              promotion.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              promotion.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            leading: Icon(
              promotion.iconData,
              size: 50,
              color: Colors.blue, 
            ),
          ),
        ],
      ),
    );
  }
}

