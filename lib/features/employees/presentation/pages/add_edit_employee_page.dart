import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/enterprise_button.dart';
import '../../../../data/models/employee_model.dart';
import '../cubit/employees_cubit.dart';
import '../cubit/employees_state.dart';

class AddEditEmployeePage extends StatefulWidget {
  final EmployeeModel? employee;

  const AddEditEmployeePage({super.key, this.employee});

  @override
  State<AddEditEmployeePage> createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _positionController;
  late TextEditingController _departmentController;
  late TextEditingController _salaryController;

  EmployeeStatus _status = EmployeeStatus.active;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name);
    _emailController = TextEditingController(text: widget.employee?.email);
    _positionController = TextEditingController(
      text: widget.employee?.position,
    );
    _departmentController = TextEditingController(
      text: widget.employee?.department,
    );
    _salaryController = TextEditingController(
      text: widget.employee?.salary.toStringAsFixed(0),
    );

    if (widget.employee != null) {
      _status = widget.employee!.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final employee = EmployeeModel(
        id:
            widget.employee?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        email: _emailController.text,
        position: _positionController.text,
        department: _departmentController.text,
        salary: double.tryParse(_salaryController.text) ?? 50000,
        status: _status,
        joinDate: widget.employee?.joinDate ?? DateTime.now(),
        address: widget.employee?.address ?? 'HQ', // Default for now
        phone: widget.employee?.phone ?? 'N/A', // Default
      );

      if (widget.employee == null) {
        context.read<EmployeesCubit>().addEmployee(employee);
      } else {
        context.read<EmployeesCubit>().updateEmployee(employee);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.employee != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Employee' : 'Add Employee')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Employee Information', style: AppTextStyles.h3),
              const SizedBox(height: 24),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter email' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _departmentController,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _positionController,
                      decoration: const InputDecoration(
                        labelText: 'Position',
                        prefixIcon: Icon(Icons.work_outline),
                      ),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Salary
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Salary (Yearly)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              // Status Dropdown
              Text('Status', style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<EmployeeStatus>(
                    value: _status,
                    isExpanded: true,
                    items: EmployeeStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(
                          status.name.toUpperCase(),
                          style: AppTextStyles.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _status = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: EnterpriseButton(
                  text: isEditing ? 'Update Employee' : 'Create Employee',
                  onPressed: _saveEmployee,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
