import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/parking_spot.dart';

class ParkingMapScreen extends StatefulWidget {
  const ParkingMapScreen({super.key});

  @override
  State<ParkingMapScreen> createState() => _ParkingMapScreenState();
}

class _ParkingMapScreenState extends State<ParkingMapScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedVehicleType = '4-wheeler';

  @override
  void initState() {
    super.initState();
    _checkAndCreateInitialSpots();
  }

  Future<void> _checkAndCreateInitialSpots() async {
    // Only create initial parking spots if none exist
    final spotsSnapshot = await _firestore.collection('parking_spots').get();
    
    if (spotsSnapshot.docs.isEmpty) {
      // Create initial parking spots if none exist
      await _createInitialParkingSpots();
    }
    // Don't automatically update existing spots - this should be admin-only
  }


  Future<void> _createInitialParkingSpots() async {
    final now = DateTime.now();
    
    // 4-wheeler parking spots - Left side of road (15 spots, smaller spacing)
    final fourWheelerLeftSpots = [
      {'name': 'A1', 'x': 0.35, 'y': 0.05},
      {'name': 'A2', 'x': 0.35, 'y': 0.09},
      {'name': 'A3', 'x': 0.35, 'y': 0.13},
      {'name': 'A4', 'x': 0.35, 'y': 0.17},
      {'name': 'A5', 'x': 0.35, 'y': 0.21},
      {'name': 'A6', 'x': 0.35, 'y': 0.25},
      {'name': 'A7', 'x': 0.35, 'y': 0.29},
      {'name': 'A8', 'x': 0.35, 'y': 0.33},
      {'name': 'A9', 'x': 0.35, 'y': 0.37},
      {'name': 'A10', 'x': 0.35, 'y': 0.41},
      {'name': 'A11', 'x': 0.35, 'y': 0.45},
      {'name': 'A12', 'x': 0.35, 'y': 0.49},
      {'name': 'A13', 'x': 0.35, 'y': 0.53},
      {'name': 'A14', 'x': 0.35, 'y': 0.57},
      {'name': 'A15', 'x': 0.35, 'y': 0.61},
    ];

    // 4-wheeler parking spots - Right side of road (15 spots, smaller spacing)
    final fourWheelerRightSpots = [
      {'name': 'B1', 'x': 0.65, 'y': 0.05},
      {'name': 'B2', 'x': 0.65, 'y': 0.09},
      {'name': 'B3', 'x': 0.65, 'y': 0.13},
      {'name': 'B4', 'x': 0.65, 'y': 0.17},
      {'name': 'B5', 'x': 0.65, 'y': 0.21},
      {'name': 'B6', 'x': 0.65, 'y': 0.25},
      {'name': 'B7', 'x': 0.65, 'y': 0.29},
      {'name': 'B8', 'x': 0.65, 'y': 0.33},
      {'name': 'B9', 'x': 0.65, 'y': 0.37},
      {'name': 'B10', 'x': 0.65, 'y': 0.41},
      {'name': 'B11', 'x': 0.65, 'y': 0.45},
      {'name': 'B12', 'x': 0.65, 'y': 0.49},
      {'name': 'B13', 'x': 0.65, 'y': 0.53},
      {'name': 'B14', 'x': 0.65, 'y': 0.57},
      {'name': 'B15', 'x': 0.65, 'y': 0.61},
    ];

    // 2-wheeler parking spots - Near Computer Department building (bottom row)
    final twoWheelerSpots = [
      {'name': 'M1', 'x': 0.2, 'y': 0.9},
      {'name': 'M2', 'x': 0.3, 'y': 0.9},
      {'name': 'M3', 'x': 0.4, 'y': 0.9},
      {'name': 'M4', 'x': 0.6, 'y': 0.9},
      {'name': 'M5', 'x': 0.7, 'y': 0.9},
      {'name': 'M6', 'x': 0.8, 'y': 0.9},
    ];

    // Create 4-wheeler spots - Left side
    for (var spot in fourWheelerLeftSpots) {
      final parkingSpot = ParkingSpot(
        id: _firestore.collection('parking_spots').doc().id,
        name: spot['name'] as String,
        type: '4-wheeler',
        x: spot['x'] as double,
        y: spot['y'] as double,
        isOccupied: false,
        createdAt: now,
        updatedAt: now,
      );
      
      await _firestore
          .collection('parking_spots')
          .doc(parkingSpot.id)
          .set(parkingSpot.toMap());
    }

    // Create 4-wheeler spots - Right side
    for (var spot in fourWheelerRightSpots) {
      final parkingSpot = ParkingSpot(
        id: _firestore.collection('parking_spots').doc().id,
        name: spot['name'] as String,
        type: '4-wheeler',
        x: spot['x'] as double,
        y: spot['y'] as double,
        isOccupied: false,
        createdAt: now,
        updatedAt: now,
      );
      
      await _firestore
          .collection('parking_spots')
          .doc(parkingSpot.id)
          .set(parkingSpot.toMap());
    }

    // Create 2-wheeler spots
    for (var spot in twoWheelerSpots) {
      final parkingSpot = ParkingSpot(
        id: _firestore.collection('parking_spots').doc().id,
        name: spot['name'] as String,
        type: '2-wheeler',
        x: spot['x'] as double,
        y: spot['y'] as double,
        isOccupied: false,
        createdAt: now,
        updatedAt: now,
      );
      
      await _firestore
          .collection('parking_spots')
          .doc(parkingSpot.id)
          .set(parkingSpot.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F7),
      appBar: AppBar(
        title: const Text('Parking Map'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          DropdownButton<String>(
            value: _selectedVehicleType,
            items: const [
              DropdownMenuItem(value: '2-wheeler', child: Text('2-Wheeler')),
              DropdownMenuItem(value: '4-wheeler', child: Text('4-Wheeler')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedVehicleType = value!;
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Legend
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem(Colors.green, 'Available'),
                  _buildLegendItem(Colors.red, 'Occupied'),
                  _buildLegendItem(Colors.blue, 'Your Spot'),
                ],
              ),
            ),
            // Map
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('parking_spots')
                        .where('type', isEqualTo: _selectedVehicleType)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No parking spots available'),
                        );
                      }

                      final spots = snapshot.data!.docs
                          .map((doc) => ParkingSpot.fromMap(doc.data() as Map<String, dynamic>))
                          .toList();

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              // Background map
                              Container(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey.shade200,
                                      Colors.grey.shade300,
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Horizontal road at top (perpendicular to main road)
                                    Positioned(
                                      left: 0,
                                      top: -20, // Extends above the map
                                      child: Container(
                                        width: constraints.maxWidth,
                                        height: 30, // Increased height
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                      ),
                                    ),
                                    // Main road (vertical line in center)
                                    Positioned(
                                      left: constraints.maxWidth * 0.468 - 12,
                                      top: 0-40,
                                      child: Container(
                                        width: 50,
                                        height: constraints.maxHeight * 0.87, // End before Computer Department
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    // Comp/Ene Building at bottom left
                                    Positioned(
                                      left: constraints.maxWidth * -0.037,
                                      bottom: constraints.maxHeight * 0,
                                      child: Container(
                                        width: constraints.maxWidth * 0.2,
                                        height: constraints.maxHeight * 0.30,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade400,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey.shade600, width: 2),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Comp/Ene\nBuilding',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Computer Department building at bottom center
                                    Positioned(
                                      left: constraints.maxWidth * 0.395,
                                      bottom: constraints.maxHeight * 0,
                                      child: Container(
                                        width: constraints.maxWidth * 0.30,
                                        height: constraints.maxHeight * 0.20,
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade400,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey.shade600, width: 2),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Computer Department',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Mech Building at bottom right
                                    Positioned(
                                      left: constraints.maxWidth * 0.85,
                                      bottom: constraints.maxHeight * 0,
                                      child: Container(
                                        width: constraints.maxWidth * 0.2,
                                        height: constraints.maxHeight * 0.30,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade400,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey.shade600, width: 2),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Mech\nBuilding',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Horizontal road connecting Comp/Ene and Mech buildings
                                    Positioned(
                                      left: constraints.maxWidth * 0.16,
                                      bottom: constraints.maxHeight * 0.21,
                                      child: Container(
                                        width: constraints.maxWidth * 0.69,
                                        height: 33,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                      ),
                                    ),
                                    // Vertical road (passage) going down from Comp/Ene building
                                    Positioned(
                                      left: constraints.maxWidth * 0.265,
                                      top: constraints.maxHeight * 0.75,
                                      child: Container(
                                        width: 20,
                                        height: constraints.maxHeight * 0.3,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Parking spots
                              ...spots.map((spot) => _buildParkingSpot(spot, constraints)),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _buildParkingSpot(ParkingSpot spot, BoxConstraints constraints) {
    // Determine spot color based on occupancy and ownership
    Color spotColor;
    if (!spot.isOccupied) {
      spotColor = Colors.green; // Available
    } else if (spot.occupiedBy == _auth.currentUser?.uid) {
      spotColor = Colors.blue; // User's own spot
    } else {
      spotColor = Colors.red; // Occupied by others
    }

    return Positioned(
      left: constraints.maxWidth * spot.x - 21,
      top: constraints.maxHeight * spot.y - 20,
      child: GestureDetector(
        onTap: () => _showParkingConfirmation(spot),
        child: Container(
          width: 45,
          height: 25,
          decoration: BoxDecoration(
            color: spotColor,
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              spot.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showParkingConfirmation(ParkingSpot spot) {
    if (spot.isOccupied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This parking spot is already occupied'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Parking'),
        content: Text('Do you want to park at spot ${spot.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _parkVehicle(spot);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Park Here'),
          ),
        ],
      ),
    );
  }

  Future<void> _parkVehicle(ParkingSpot spot) async {
    try {
      final now = DateTime.now();
      final updatedSpot = spot.copyWith(
        isOccupied: true,
        occupiedBy: _auth.currentUser?.uid,
        occupiedAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection('parking_spots')
          .doc(spot.id)
          .update(updatedSpot.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully parked at spot ${spot.name}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parking vehicle: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
