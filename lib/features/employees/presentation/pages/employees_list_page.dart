import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../data/models/employee_model.dart';
import '../cubit/employees_cubit.dart';
import '../cubit/employees_state.dart';

class EmployeesListPage extends StatefulWidget {
  const EmployeesListPage({super.key});

  @override
  State<EmployeesListPage> createState() => _EmployeesListPageState();
}

class _EmployeesListPageState extends State<EmployeesListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EmployeesCubit>().loadEmployees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<EmployeesCubit>().refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: Responsive.getPagePadding(context),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search employees...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<EmployeesCubit>().searchEmployees('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<EmployeesCubit>().searchEmployees(value);
              },
            ),
          ),

          // Employee List
          Expanded(
            child: BlocBuilder<EmployeesCubit, EmployeesState>(
              builder: (context, state) {
                if (state is EmployeesLoading) {
                  return const LoadingWidget(message: 'Loading employees...');
                }

                if (state is EmployeesError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<EmployeesCubit>().loadEmployees();
                    },
                  );
                }

                if (state is EmployeesLoaded) {
                  if (state.employees.isEmpty) {
                    return EmptyStateWidget(
                      title: state.searchQuery != null
                          ? 'No Results Found'
                          : 'No Employees',
                      message: state.searchQuery != null
                          ? 'Try adjusting your search'
                          : 'No employees have been added yet',
                      icon: Icons.people_outline,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<EmployeesCubit>().refresh();
                    },
                    child: ListView.builder(
                      padding: Responsive.getPagePadding(context),
                      itemCount: state.employees.length,
                      itemBuilder: (context, index) {
                        final employee = state.employees[index];
                        return _buildEmployeeCard(context, employee);
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, EmployeeModel employee) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: _getStatusColor(employee.status).withOpacity(0.2),
          child: Text(
            employee.name.substring(0, 1).toUpperCase(),
            style: AppTextStyles.h3.copyWith(
              color: _getStatusColor(employee.status),
            ),
          ),
        ),
        title: Text(employee.name, style: AppTextStyles.h4),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${employee.position} • ${employee.department}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.email, size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(employee.email, style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 4),
            _buildStatusChip(employee.status),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          _showEmployeeDetailsDialog(context, employee);
        },
      ),
    );
  }

  Widget _buildStatusChip(EmployeeStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: _getStatusColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(EmployeeStatus status) {
    switch (status) {
      case EmployeeStatus.active:
        return AppColors.success;
      case EmployeeStatus.inactive:
        return AppColors.grey;
      case EmployeeStatus.onLeave:
        return AppColors.warning;
      case EmployeeStatus.terminated:
        return AppColors.error;
    }
  }

  void _showEmployeeDetailsDialog(
    BuildContext context,
    EmployeeModel employee,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(employee.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Email', employee.email),
              _buildDetailRow('Phone', employee.phone),
              _buildDetailRow('Department', employee.department),
              _buildDetailRow('Position', employee.position),
              _buildDetailRow(
                'Join Date',
                dateFormat.format(employee.joinDate),
              ),
              _buildDetailRow('Salary', currencyFormat.format(employee.salary)),
              _buildDetailRow('Address', employee.address),
              if (employee.dateOfBirth != null)
                _buildDetailRow(
                  'Date of Birth',
                  dateFormat.format(employee.dateOfBirth!),
                ),
              if (employee.emergencyContact != null)
                _buildDetailRow(
                  'Emergency Contact',
                  employee.emergencyContact!,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelMedium),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
