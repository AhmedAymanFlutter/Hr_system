import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../data/models/attendance_model.dart';
import '../../../../domain/repositories/attendance_repository.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late Future<List<AttendanceModel>> _attendanceFuture;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  void _loadAttendance() {
    final repository = context.read<AttendanceRepository>();
    _attendanceFuture = repository.getTodayAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loadAttendance();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AttendanceModel>>(
        future: _attendanceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Loading attendance...');
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final attendance = snapshot.data ?? [];

          return ListView.builder(
            padding: Responsive.getPagePadding(context),
            itemCount: attendance.length,
            itemBuilder: (context, index) {
              final record = attendance[index];
              final timeFormat = DateFormat('HH:mm');

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(
                      record.status,
                    ).withOpacity(0.2),
                    child: Icon(
                      _getStatusIcon(record.status),
                      color: _getStatusColor(record.status),
                    ),
                  ),
                  title: Text(record.employeeName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      if (record.checkIn != null)
                        Text('Check In: ${timeFormat.format(record.checkIn!)}'),
                      if (record.checkOut != null)
                        Text(
                          'Check Out: ${timeFormat.format(record.checkOut!)}',
                        ),
                      if (record.workDuration != null)
                        Text(
                          'Duration: ${record.workDuration!.inHours}h ${record.workDuration!.inMinutes.remainder(60)}m',
                        ),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      record.status.name.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: _getStatusColor(record.status),
                      ),
                    ),
                    backgroundColor: _getStatusColor(
                      record.status,
                    ).withOpacity(0.1),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.success;
      case AttendanceStatus.late:
        return AppColors.warning;
      case AttendanceStatus.absent:
        return AppColors.error;
      case AttendanceStatus.halfDay:
        return AppColors.info;
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.late:
        return Icons.access_time;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.halfDay:
        return Icons.timelapse;
    }
  }
}
