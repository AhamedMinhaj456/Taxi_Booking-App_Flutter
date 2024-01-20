import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:taxi_booking_app/Models/list.dart';

void main() {
  runApp(const InviteFriends());
}

class InviteFriends extends StatelessWidget {
  const InviteFriends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: SnappingList()),
    );
  }
}

class SnappingList extends StatefulWidget {
  const SnappingList({Key? key}) : super(key: key);

  @override
  _SnappingListState createState() => _SnappingListState();
}

class _SnappingListState extends State<SnappingList> {
  List<Friend> friendList = [
    Friend('assets/images/friend1.jpg', 'Nirasha Morais', 'Available', 'Mutual-2', 'Ja ela'),
    Friend('assets/images/friend2.jpg', 'Hansani Sithara', 'Offline', 'Mutual-2', 'Ja ela'),
    Friend('assets/images/friend3.jpg', 'Aayan', 'Available','Mutual-3' ,'Ja ela' ),
    Friend('assets/images/friend4.jpg', 'Ethan Sovis', 'Away','Mutual-9' , 'Ja ela'),
    Friend('assets/images/friend5.jpg', 'Praveen Morais', 'Available', 'Mutual-21','Ja ela' ),
    Friend('assets/images/friend9.jpg', 'Sithija Rox', 'Offline','No Mutual' ,'Ja ela' ),
    Friend('assets/images/friend7.jpg', 'Manasha Anjali', 'Available', 'Mutual-27', 'Ja ela'),
    Friend('assets/images/friend8.jpg', 'Shehani Akalankya', 'Away','Mutual-5', 'Ja ela'),
    
  ];

  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Invite Friends",),
      ),
      body: Column(
        children: [
          _buildCategoryToggleButtons(),
          Expanded(
            child: SizedBox(
              height: 100,
              child: ScrollSnapList(
                itemBuilder: _buildFriendListItem,
                itemCount: friendList.length,
                itemSize: 150,
                onItemFocus: (index) {
                 
                },
                dynamicItemSize: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryToggleButtons() {
    List<String> categories = ['All', 'Available', 'Offline', 'Away'];
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selectedCategory == category ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFriendListItem(BuildContext context, int index) {
    Friend friend = friendList[index];
    if (selectedCategory != 'All' && friend.status != selectedCategory) {
      return SizedBox.shrink(); 
    }

    return SizedBox(
      width: 150,
      height: 100,
      child: Card(
        elevation: 12,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Column(
            children: [
              Image.asset(
                friend.imagePath,
                fit: BoxFit.cover,
                width: 150,
                height: 120, 
              ),
              const SizedBox(
                height: 8, 
              ),
              Text(
                friend.name,
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                friend.status,
                style: TextStyle(
                  color: friend.status == 'Available' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${friend.mutual}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${friend.livesin}',
                      style: const TextStyle(color: Colors.blue),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8), 
              ElevatedButton(
                onPressed: () {
                 
                },
                child: const Text('Invite'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
