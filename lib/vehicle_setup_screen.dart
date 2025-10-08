import 'package:flutter/material.dart';

class VehicleSetupScreen extends StatefulWidget {
  const VehicleSetupScreen({super.key});

  @override
  State<VehicleSetupScreen> createState() => _VehicleSetupScreenState();
}

class _VehicleSetupScreenState extends State<VehicleSetupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedType; // '2-wheeler' | '4-wheeler'
  final TextEditingController _plateController = TextEditingController();
  final List<Map<String, String>> _vehicles = <Map<String, String>>[];

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  void _addVehicle() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _vehicles.add({
        'type': _selectedType!,
        'plate': _plateController.text.trim(),
      });
      _selectedType = null;
      _plateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F7),
      appBar: AppBar(
        title: const Text('Add Your Vehicles'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedType,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.directions_bike_outlined),
                            labelText: 'Vehicle type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: '2-wheeler', child: Text('2 wheeler')),
                            DropdownMenuItem(value: '4-wheeler', child: Text('4 wheeler')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Select vehicle type' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _plateController,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.confirmation_number_outlined),
                            labelText: 'License plate',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          textCapitalization: TextCapitalization.characters,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? 'Enter license plate' : null,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _addVehicle,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Add vehicle'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (_vehicles.isNotEmpty) ...[
                          const Text(
                            'Your vehicles',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _vehicles.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final v = _vehicles[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            v['type'] ?? '',
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            v['plate'] ?? '',
                                            style: const TextStyle(color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () {
                                        setState(() {
                                          _vehicles.removeAt(index);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text("I'll do this later"),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}


