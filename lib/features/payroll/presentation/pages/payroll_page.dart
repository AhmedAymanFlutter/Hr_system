import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_system/domain/repositories/payroll_repository.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../data/models/payroll_model.dart';

class PayrollPage extends StatefulWidget {
  const PayrollPage({super.key});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  late Future<List<PayrollModel>> _payrollFuture;
  late Future<Map<String, double>> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _loadPayroll();
  }

  void _loadPayroll() {
    final repository = context.read<PayrollRepository>();
    final currentMonth = DateTime.now();
    _payrollFuture = repository.getPayrollByMonth(currentMonth);
    _summaryFuture = repository.getMonthlyPayrollSummary(currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/dashboard');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Section
          FutureBuilder<Map<String, double>>(
            future: _summaryFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final summary = snapshot.data!;
                return Card(
                  margin: Responsive.getPagePadding(context),
                  color: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Summary',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Net Payroll',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.white.withOpacity(0.9),
                              ),
                            ),
                            Text(
                              currencyFormat.format(summary['netSalary'] ?? 0),
                              style: AppTextStyles.displaySmall.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Payroll List
          Expanded(
            child: FutureBuilder<List<PayrollModel>>(
              future: _payrollFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(message: 'Loading payroll...');
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final payrolls = snapshot.data ?? [];

                return ListView.builder(
                  padding: Responsive.getPagePadding(context),
                  itemCount: payrolls.length,
                  itemBuilder: (context, index) {
                    final payroll = payrolls[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: payroll.isPaid
                              ? AppColors.success.withOpacity(0.2)
                              : AppColors.warning.withOpacity(0.2),
                          child: Icon(
                            payroll.isPaid ? Icons.check_circle : Icons.pending,
                            color: payroll.isPaid
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                        title: Text(payroll.employeeName),
                        subtitle: Text(
                          currencyFormat.format(payroll.netSalary),
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        trailing: Chip(
                          label: Text(
                            payroll.isPaid ? 'PAID' : 'PENDING',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: payroll.isPaid
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                          backgroundColor:
                              (payroll.isPaid
                                      ? AppColors.success
                                      : AppColors.warning)
                                  .withOpacity(0.1),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildPayrollRow(
                                  'Basic Salary',
                                  payroll.basicSalary,
                                  currencyFormat,
                                ),
                                _buildPayrollRow(
                                  'Allowances',
                                  payroll.allowances,
                                  currencyFormat,
                                  isPositive: true,
                                ),
                                _buildPayrollRow(
                                  'Bonuses',
                                  payroll.bonuses,
                                  currencyFormat,
                                  isPositive: true,
                                ),
                                _buildPayrollRow(
                                  'Deductions',
                                  payroll.deductions,
                                  currencyFormat,
                                  isNegative: true,
                                ),
                                _buildPayrollRow(
                                  'Tax',
                                  payroll.taxAmount,
                                  currencyFormat,
                                  isNegative: true,
                                ),
                                const Divider(),
                                _buildPayrollRow(
                                  'Net Salary',
                                  payroll.netSalary,
                                  currencyFormat,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollRow(
    String label,
    double amount,
    NumberFormat formatter, {
    bool isPositive = false,
    bool isNegative = false,
    bool isBold = false,
  }) {
    Color? color;
    if (isPositive) color = AppColors.success;
    if (isNegative) color = AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? AppTextStyles.h4 : AppTextStyles.bodyMedium,
          ),
          Text(
            formatter.format(amount),
            style: (isBold ? AppTextStyles.h4 : AppTextStyles.bodyMedium)
                .copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
