import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../constants/app_theme.dart';
import '../onboarding/plant_selection_screen.dart';

/// Screen showing statistics and charts for a specific plant
class PlantStatsScreen extends StatefulWidget {
  final Plant plant;
  final List<DateTime> wateringHistory;
  final DateTime lastWatered;
  
  const PlantStatsScreen({
    Key? key,
    required this.plant,
    required this.wateringHistory,
    required this.lastWatered,
  }) : super(key: key);

  @override
  State<PlantStatsScreen> createState() => _PlantStatsScreenState();
}

class _PlantStatsScreenState extends State<PlantStatsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedDays = 30;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  List<DateTime> get _filteredHistory {
    final cutoffDate = DateTime.now().subtract(Duration(days: _selectedDays));
    return widget.wateringHistory
        .where((date) => date.isAfter(cutoffDate))
        .toList();
  }
  
  int get _totalWaterings => widget.wateringHistory.length;
  
  double get _averageFrequency {
    if (widget.wateringHistory.length < 2) return 0;
    
    final sorted = List<DateTime>.from(widget.wateringHistory)..sort();
    double totalDays = 0;
    
    for (int i = 1; i < sorted.length; i++) {
      totalDays += sorted[i].difference(sorted[i - 1]).inDays.toDouble();
    }
    
    return totalDays / (sorted.length - 1);
  }
  
  int get _longestStreak {
    if (widget.wateringHistory.length < 2) return 1;
    
    final sorted = List<DateTime>.from(widget.wateringHistory)..sort();
    int maxStreak = 1;
    int currentStreak = 1;
    
    for (int i = 1; i < sorted.length; i++) {
      final daysDiff = sorted[i].difference(sorted[i - 1]).inDays;
      // Consider it a streak if watered within expected frequency +/- 2 days
      if (daysDiff <= widget.plant.wateringDays + 2) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else {
        currentStreak = 1;
      }
    }
    
    return maxStreak;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundGreen,
              AppTheme.lightGreen.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _animationController,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Statystyki',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 24,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.plant.emoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.plant.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats cards
                      _buildStatsCards(),
                      
                      const SizedBox(height: 24),
                      
                      // Time period selector
                      _buildTimePeriodSelector(),
                      
                      const SizedBox(height: 16),
                      
                      // Watering chart
                      _buildWateringChart(),
                      
                      const SizedBox(height: 24),
                      
                      // Watering calendar
                      _buildWateringCalendar(),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.water_drop,
            value: _totalWaterings.toString(),
            label: 'Podlewań',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.schedule,
            value: _averageFrequency.toStringAsFixed(1),
            label: 'Średnio dni',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.local_fire_department,
            value: _longestStreak.toString(),
            label: 'Streak',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textDark.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimePeriodSelector() {
    return Row(
      children: [
        _buildPeriodButton('7D', 7),
        const SizedBox(width: 8),
        _buildPeriodButton('30D', 30),
        const SizedBox(width: 8),
        _buildPeriodButton('90D', 90),
        const SizedBox(width: 8),
        _buildPeriodButton('Wszystko', 365 * 10),
      ],
    );
  }
  
  Widget _buildPeriodButton(String label, int days) {
    final isSelected = _selectedDays == days;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDays = days;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primaryGreen : AppTheme.lightGreen,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  
  Widget _buildWateringChart() {
    if (_filteredHistory.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Brak danych dla wybranego okresu',
            style: TextStyle(
              color: AppTheme.textDark.withOpacity(0.6),
            ),
          ),
        ),
      );
    }
    
    // Group waterings by date
    final wateringsByDate = <DateTime, int>{};
    for (final date in _filteredHistory) {
      final dateOnly = DateTime(date.year, date.month, date.day);
      wateringsByDate[dateOnly] = (wateringsByDate[dateOnly] ?? 0) + 1;
    }
    
    // Create bar chart data
    final spots = <BarChartGroupData>[];
    final sortedDates = wateringsByDate.keys.toList()..sort();
    
    for (int i = 0; i < sortedDates.length && i < 10; i++) {
      final date = sortedDates[sortedDates.length - 10 + i];
      final count = wateringsByDate[date] ?? 0;
      
      spots.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: AppTheme.primaryGreen,
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historia podlewania',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (wateringsByDate.values.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
                barGroups: spots,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= sortedDates.length - 10 &&
                            value.toInt() < sortedDates.length) {
                          final date = sortedDates[sortedDates.length - 10 + value.toInt()];
                          return Text(
                            '${date.day}/${date.month}',
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWateringCalendar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ostatnie podlewania',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          if (_filteredHistory.isEmpty)
            Center(
              child: Text(
                'Brak historii podlewania',
                style: TextStyle(
                  color: AppTheme.textDark.withOpacity(0.6),
                ),
              ),
            )
          else
            ..._filteredHistory
                .reversed
                .take(10)
                .map((date) => _buildWateringItem(date))
                .toList(),
        ],
      ),
    );
  }
  
  Widget _buildWateringItem(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    String timeAgo;
    
    if (difference.inDays == 0) {
      timeAgo = 'Dzisiaj';
    } else if (difference.inDays == 1) {
      timeAgo = 'Wczoraj';
    } else if (difference.inDays < 7) {
      timeAgo = '${difference.inDays} dni temu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      timeAgo = '$weeks ${weeks == 1 ? "tydzień" : "tygodnie"} temu';
    } else {
      timeAgo = DateFormat('dd MMM yyyy', 'pl').format(date);
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.water_drop,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  DateFormat('HH:mm', 'pl').format(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textDark.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: AppTheme.primaryGreen.withOpacity(0.6),
            size: 20,
          ),
        ],
      ),
    );
  }
}
