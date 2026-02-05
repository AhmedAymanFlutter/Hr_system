import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/enterprise_card.dart';
import '../../../../core/widgets/enterprise_button.dart';
import '../../../../data/models/employee_model.dart';
import '../cubit/employees_cubit.dart';
import '../cubit/employees_state.dart';
import 'add_edit_employee_page.dart';

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

  void _navigateToAddEditEmployee([EmployeeModel? employee]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditEmployeePage(employee: employee),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<EmployeesCubit>().refresh(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEditEmployee(),
        icon: const Icon(Icons.add),
        label: const Text('Add Employee'),
        backgroundColor: AppColors.primary,
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
                          : 'Get started by adding a new employee',
                      icon: Icons.people_outline,
                      action: EnterpriseButton(
                        text: 'Add Employee',
                        onPressed: () => _navigateToAddEditEmployee(),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: Responsive.getPagePadding(
                      context,
                    ).copyWith(bottom: 80),
                    itemCount: state.employees.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final employee = state.employees[index];
                      return _buildEmployeeCard(context, employee);
                    },
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
    return EnterpriseCard(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: _getStatusColor(employee.status).withOpacity(0.1),
          child: Text(
            employee.name.substring(0, 1).toUpperCase(),
            style: AppTextStyles.h4.copyWith(
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
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildStatusChip(employee.status),
                const Spacer(),
                Text(employee.email, style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
        onTap: () => _navigateToAddEditEmployee(employee),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppTextStyles.labelSmall),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(EmployeeStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.2)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: _getStatusColor(status),
          fontWeight: FontWeight.bold,
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
}
