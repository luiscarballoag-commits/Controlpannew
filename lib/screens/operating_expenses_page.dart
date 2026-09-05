import 'package:flutter/material.dart';

import '../models/operating_expense.dart';
import '../services/operating_expense_service.dart';

class OperatingExpensesPage extends StatefulWidget {
  const OperatingExpensesPage({super.key});

  @override
  State<OperatingExpensesPage> createState() =>
      _OperatingExpensesPageState();
}

class _OperatingExpensesPageState
    extends State<OperatingExpensesPage> {
  final OperatingExpenseService _service =
      OperatingExpenseService();

  List<OperatingExpense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    setState(() {
      _expenses = _service.getAllExpenses();
    });
  }

  Future<void> _showExpenseForm({
    int? index,
    OperatingExpense? expense,
  }) async {
    final nameController =
        TextEditingController(text: expense?.name ?? '');
    final costController = TextEditingController(
      text: expense == null
          ? ''
          : expense.cost.toStringAsFixed(2),
    );

    String period = expense?.period ?? 'Mensual';
    bool active = expense?.active ?? true;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                expense == null
                    ? 'Agregar gasto operativo'
                    : 'Editar gasto operativo',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization:
                          TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del gasto',
                        hintText: 'Ej. Electricidad',
                        prefixIcon: Icon(Icons.receipt_long),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: costController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Costo',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: period,
                      decoration: const InputDecoration(
                        labelText: 'Período',
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Diario',
                          child: Text('Diario'),
                        ),
                        DropdownMenuItem(
                          value: 'Semanal',
                          child: Text('Semanal'),
                        ),
                        DropdownMenuItem(
                          value: 'Mensual',
                          child: Text('Mensual'),
                        ),
                        DropdownMenuItem(
                          value: 'Anual',
                          child: Text('Anual'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            period = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Gasto activo'),
                      subtitle: const Text(
                        'Los gastos inactivos no se incluirán en los costos.',
                      ),
                      value: active,
                      onChanged: (value) {
                        setDialogState(() {
                          active = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final cost = double.tryParse(
                      costController.text.replaceAll(',', '.'),
                    );

                    if (name.isEmpty || cost == null || cost < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Completa correctamente los datos.',
                          ),
                        ),
                      );
                      return;
                    }

                    final newExpense = OperatingExpense(
                      id: expense?.id ??
                          DateTime.now()
                              .microsecondsSinceEpoch
                              .toString(),
                      name: name,
                      cost: cost,
                      period: period,
                      active: active,
                    );

                    if (index == null) {
                      _service.addExpense(newExpense);
                    } else {
                      _service.updateExpense(
                        index,
                        newExpense,
                      );
                    }

                    Navigator.pop(dialogContext);
                    _loadExpenses();
                  },
                  child: Text(
                    expense == null ? 'Guardar' : 'Actualizar',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    costController.dispose();
  }

  Future<void> _deleteExpense(int index) async {
    final expense = _expenses[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar gasto'),
          content: Text(
            '¿Deseas eliminar "${expense.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _service.deleteExpense(index);
      _loadExpenses();
    }
  }

  void _toggleExpense(int index) {
    final expense = _expenses[index];

    _service.updateExpense(
      index,
      expense.copyWith(
        active: !expense.active,
      ),
    );

    _loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount =
        _expenses.where((expense) => expense.active).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos Operativos'),
      ),
      body: _expenses.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 72,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No hay gastos operativos registrados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Agrega electricidad, aseo, gas y otros gastos de tu panadería.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Gastos operativos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_expenses.length} registrados · '
                                '$activeCount activos',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  _expenses.length,
                  (index) {
                    final expense = _expenses[index];
                    final dailyCost =
                        _service.getDailyCost(expense);

                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    expense.active
                                        ? Icons.bolt_rounded
                                        : Icons.pause_rounded,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expense.name,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${expense.period} · '
                                        '\$${expense.cost.toStringAsFixed(2)}',
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: expense.active,
                                  onChanged: (_) =>
                                      _toggleExpense(index),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Costo diario equivalente'),
                                Text(
                                  '\$${dailyCost.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  tooltip: 'Editar',
                                  onPressed: () =>
                                      _showExpenseForm(
                                    index: index,
                                    expense: expense,
                                  ),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  onPressed: () =>
                                      _deleteExpense(index),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExpenseForm(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar gasto'),
      ),
    );
  }
}
