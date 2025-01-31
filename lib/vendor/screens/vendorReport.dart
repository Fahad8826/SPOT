import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ShopAnalyticsData {
  final String shopId;
  final int viewCount;
  final DateTime timestamp;

  ShopAnalyticsData(this.shopId, this.viewCount, this.timestamp);
}

class ShopAnalyticsReport extends StatefulWidget {
  const ShopAnalyticsReport({Key? key}) : super(key: key);

  @override
  State<ShopAnalyticsReport> createState() => _ShopAnalyticsReportState();
}

class _ShopAnalyticsReportState extends State<ShopAnalyticsReport> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  List<ShopAnalyticsData> analyticsData = [];
  bool isLoading = true;
  String selectedTimeRange = 'Week';

  @override
  void initState() {
    super.initState();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      DateTime startDate = DateTime.now();
      switch (selectedTimeRange) {
        case 'Week':
          startDate = startDate.subtract(const Duration(days: 7));
          break;
        case 'Month':
          startDate = startDate.subtract(const Duration(days: 30));
          break;
        case 'Year':
          startDate = startDate.subtract(const Duration(days: 365));
          break;
      }

      var snapshot = await _firestore
          .collection('shop_analytics')
          .where('vendorId', isEqualTo: currentUser?.uid)
          .where('timestamp', isGreaterThan: startDate)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        analyticsData = snapshot.docs.map((doc) {
          return ShopAnalyticsData(
            doc['shopId'],
            doc['viewCount'],
            (doc['timestamp'] as Timestamp).toDate(),
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching analytics: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching analytics: $e')),
      );
    }
  }

  Future<void> incrementShopView(String shopId) async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      await _firestore.collection('shop_analytics').add({
        'shopId': shopId,
        'vendorId': currentUser!.uid,
        'viewCount': 1,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await fetchAnalyticsData();
    } catch (e) {
      debugPrint('Error incrementing view: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error incrementing view: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Analytics'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTimeRangeSelector(),
                      const SizedBox(height: 20),
                      _buildAnalyticsChart(),
                      const SizedBox(height: 20),
                      _buildSummaryCards(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['Week', 'Month', 'Year'].map((range) {
            return ChoiceChip(
              label: Text(range),
              selected: selectedTimeRange == range,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedTimeRange = range;
                  });
                  fetchAnalyticsData();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAnalyticsChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 300,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('MMM dd'),
              intervalType: DateTimeIntervalType.days,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'View Count'),
            ),
            // tooltipBehavior: TooltipBehavior(enable: true),
            // series: <ChartSeries>[
            //   LineSeries<ShopAnalyticsData, DateTime>(
            //     dataSource: analyticsData,
            //     xValueMapper: (ShopAnalyticsData data, _) => data.timestamp,
            //     yValueMapper: (ShopAnalyticsData data, _) => data.viewCount,
            //     name: 'Views',
            //     markerSettings: const MarkerSettings(isVisible: true),
            //   ),
            // ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSummaryCard(
            'Total Views',
            analyticsData.fold<int>(0, (sum, item) => sum + item.viewCount),
            Icons.visibility,
          );
        } else {
          return _buildSummaryCard(
            'Average Views',
            analyticsData.isEmpty
                ? 0
                : (analyticsData.fold<int>(
                            0, (sum, item) => sum + item.viewCount) /
                        analyticsData.length)
                    .round(),
            Icons.analytics,
          );
        }
      },
    );
  }

  Widget _buildSummaryCard(String title, int value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
