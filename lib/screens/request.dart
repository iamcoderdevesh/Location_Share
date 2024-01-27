import 'package:flutter/material.dart';
import 'package:location_share/screens/location_code.dart';
import 'package:location_share/screens/qr_scanner.dart';

class RequestLocation extends StatefulWidget {
  const RequestLocation({super.key});

  @override
  State<RequestLocation> createState() => _RequestLocationState();
}

class _RequestLocationState extends State<RequestLocation> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                    color: Colors.grey.shade900,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade900,
                  tabs: const [
                    Tab(
                      text: 'Scan QR Code',
                    ),
                    Tab(
                      text: 'Location Code',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    QRScanner(),
                    LocationCode(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
