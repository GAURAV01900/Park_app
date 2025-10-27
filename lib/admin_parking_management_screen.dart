import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/parking_spot.dart';

class AdminParkingManagementScreen extends StatefulWidget {
  const AdminParkingManagementScreen({super.key});

  @override
  State<AdminParkingManagementScreen> createState() => _AdminParkingManagementScreenState();
}

class _AdminParkingManagementScreenState extends State<AdminParkingManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedType = 'all'; // 'all', '2-wheeler', '4-wheeler'
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F7),
      appBar: AppBar(
        title: const Text('Manage Parking Spots'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Types')),
                DropdownMenuItem(value: '2-wheeler', child: Text('2-Wheeler Only')),
                DropdownMenuItem(value: '4-wheeler', child: Text('4-Wheeler Only')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _selectedType == 'all'
              ? _firestore.collection('parking_spots').snapshots()
              : _firestore.collection('parking_spots').where('type', isEqualTo: _selectedType).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final spots = snapshot.data?.docs.map((doc) => ParkingSpot.fromMap(doc.data() as Map<String, dynamic>)).toList() ?? [];

            if (spots.isEmpty) {
              return const Center(child: Text('No parking spots found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: spots.length,
              itemBuilder: (context, index) {
                final spot = spots[index];
                return _buildSpotCard(spot);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpotCard(ParkingSpot spot) {
    Color statusColor = spot.isOccupied ? Colors.red : Colors.green;
    String statusText = spot.isOccupied ? 'Occupied' : 'Available';

    return FutureBuilder<String?>(
      future: spot.isOccupied && spot.occupiedBy != null 
          ? _getUserName(spot.occupiedBy!) 
          : Future.value(null),
      builder: (context, snapshot) {
        final userName = snapshot.data ?? 'Loading...';
        
        return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_parking,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spot ${spot.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: spot.type == '2-wheeler' ? Colors.green.shade100 : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              spot.type,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: spot.type == '2-wheeler' ? Colors.green.shade700 : Colors.blue.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit Spot'),
                        ],
                      ),
                      onTap: () => _showEditSpotDialog(spot),
                    ),
                    if (spot.isOccupied)
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.remove_circle, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Force Unpark', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        onTap: () => _showForceUnparkDialog(spot),
                      ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.refresh, size: 20),
                          SizedBox(width: 8),
                          Text('Reset Spot'),
                        ],
                      ),
                      onTap: () => _resetSpot(spot),
                    ),
                  ],
                ),
              ],
            ),
            if (spot.isOccupied) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Occupied by: $userName',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    if (spot.vehicleName != null || spot.isGuestVehicle) ...[
                      const SizedBox(height: 4),
                      Text(
                        spot.isGuestVehicle ? 'Guest Vehicle' : spot.vehicleName ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
      },
    );
  }

  Future<String?> _getUserName(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data()?['name'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _showEditSpotDialog(ParkingSpot spot) {
    // TODO: Show dialog to edit spot details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality coming soon')),
    );
  }

  void _showForceUnparkDialog(ParkingSpot spot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Force Unpark'),
        content: Text('Are you sure you want to force unpark spot ${spot.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _forceUnpark(spot);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Force Unpark'),
          ),
        ],
      ),
    );
  }

  Future<void> _forceUnpark(ParkingSpot spot) async {
    try {
      await _firestore.collection('parking_spots').doc(spot.id).update({
        'isOccupied': false,
        'occupiedBy': FieldValue.delete(),
        'occupiedAt': FieldValue.delete(),
        'vehicleId': FieldValue.delete(),
        'vehicleName': FieldValue.delete(),
        'vehicleLicensePlate': FieldValue.delete(),
        'vehicleType': FieldValue.delete(),
        'isGuestVehicle': false,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Spot force unparked successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resetSpot(ParkingSpot spot) async {
    try {
      await _firestore.collection('parking_spots').doc(spot.id).update({
        'isOccupied': false,
        'occupiedBy': FieldValue.delete(),
        'occupiedAt': FieldValue.delete(),
        'vehicleId': FieldValue.delete(),
        'vehicleName': FieldValue.delete(),
        'vehicleLicensePlate': FieldValue.delete(),
        'vehicleType': FieldValue.delete(),
        'isGuestVehicle': false,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Spot reset successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

