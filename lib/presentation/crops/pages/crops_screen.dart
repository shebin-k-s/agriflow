import 'package:flutter/material.dart';

class CropsScreen extends StatefulWidget {
  @override
  _CropsScreenState createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  int selectedField = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AgriFlow', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Icon(Icons.camera_alt, color: Colors.black),
        actions: [
          Icon(Icons.notifications, color: Colors.black),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFieldTab(1, 'Field 1'),
                _buildFieldTab(2, 'Field'),
                _buildFieldTab(3, 'Field 3'),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildCropCard('Corn', selectedField == 1 ? 90 : 60),
                SizedBox(height: 16),
                _buildCropCard('Rice', selectedField == 2 ? 80 : 50),
                SizedBox(height: 16),
                _buildCropCard('Wheat', selectedField == 3 ? 70 : 40),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.terrain), label: 'Fields'),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Crops'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildFieldTab(int fieldNumber, String title) {
    bool isSelected = (selectedField == fieldNumber);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedField = fieldNumber; // Update the selected field
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade100 : Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCropCard(String cropName, int percentage) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Text(
              cropName[0],
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cropName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Based on current soil condition',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage / 100,
                  color: Colors.green,
                  backgroundColor: Colors.grey.shade200,
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}