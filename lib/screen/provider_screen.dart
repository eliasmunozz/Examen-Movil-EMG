import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider.dart';
import '../services/provider_service.dart';
import '../widgets/custom_notification.dart';

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ProviderService>(context);

    if (service.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: service.providers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No se pudieron cargar los proveedores.\nRevisa tu conexión o vuelve a intentar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await service.loadProviders();
                        if (service.providers.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Proveedores recargados correctamente')),
                          );
                        }
                      } catch (e) {
                        CustomNotification.show(
                          context,
                          message: 'Error al recargar: $e',
                          backgroundColor: Colors.red,
                          icon: Icons.error,
                        );
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: service.providers.length,
              itemBuilder: (_, index) {
                final provider = service.providers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${provider.providerName} ${provider.providerLastName}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(provider.providerMail),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () => _viewDialog(context, provider),
                              icon: const Icon(Icons.visibility),
                              label: const Text('Ver'),
                            ),
                            TextButton.icon(
                              onPressed: () => _editDialog(context, service, provider),
                              icon: const Icon(Icons.edit),
                              label: const Text('Editar'),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                try {
                                  await service.deleteProvider(provider);
                                  CustomNotification.show(
                                    context,
                                    message: 'Proveedor eliminado',
                                    backgroundColor: Colors.green,
                                    icon: Icons.check_circle,
                                  );
                                } catch (e) {
                                  CustomNotification.show(
                                    context,
                                    message: 'Error al eliminar: $e',
                                    backgroundColor: Colors.red,
                                    icon: Icons.error,
                                  );
                                }
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text('Borrar', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () => _editDialog(
          context,
          service,
          ProviderModel(
            providerId: 0,
            providerName: '',
            providerLastName: '',
            providerMail: '',
            providerState: 'Activo',
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editDialog(BuildContext context, ProviderService service, ProviderModel provider) {
    showDialog(
      context: context,
      builder: (_) => _ProviderFormDialog(service: service, provider: provider),
    );
  }

  void _viewDialog(BuildContext context, ProviderModel provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ver Proveedor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${provider.providerName} ${provider.providerLastName}'),
            const SizedBox(height: 8),
            Text('Correo: ${provider.providerMail}'),
            const SizedBox(height: 8),
            Text('Estado: ${provider.providerState}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _ProviderFormDialog extends StatefulWidget {
  final ProviderService service;
  final ProviderModel provider;

  const _ProviderFormDialog({required this.service, required this.provider});

  @override
  State<_ProviderFormDialog> createState() => _ProviderFormDialogState();
}

class _ProviderFormDialogState extends State<_ProviderFormDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController lastNameCtrl;
  late TextEditingController mailCtrl;

  String? nameError;
  String? lastNameError;
  String? mailError;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.provider.providerName);
    lastNameCtrl = TextEditingController(text: widget.provider.providerLastName);
    mailCtrl = TextEditingController(text: widget.provider.providerMail);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    lastNameCtrl.dispose();
    mailCtrl.dispose();
    super.dispose();
  }

  void validateFields() {
    setState(() {
      nameError = nameCtrl.text.trim().isEmpty ? 'Nombre requerido' : null;
      lastNameError = lastNameCtrl.text.trim().isEmpty ? 'Apellido requerido' : null;

      final email = mailCtrl.text.trim();
      if (email.isEmpty) {
        mailError = 'Correo requerido';
      } else {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        mailError = emailRegex.hasMatch(email) ? null : 'Correo inválido';
      }
    });
  }

  bool get isFormValid => nameError == null && lastNameError == null && mailError == null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.provider.providerId == 0 ? 'Agregar Proveedor' : 'Editar Proveedor'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Nombre',
                errorText: nameError,
              ),
              onChanged: (_) => validateFields(),
            ),
            TextField(
              controller: lastNameCtrl,
              decoration: InputDecoration(
                labelText: 'Apellido',
                errorText: lastNameError,
              ),
              onChanged: (_) => validateFields(),
            ),
            TextField(
              controller: mailCtrl,
              decoration: InputDecoration(
                labelText: 'Correo',
                errorText: mailError,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => validateFields(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            validateFields();
            if (!isFormValid) return;

            widget.provider.providerName = nameCtrl.text.trim();
            widget.provider.providerLastName = lastNameCtrl.text.trim();
            widget.provider.providerMail = mailCtrl.text.trim();
            widget.provider.providerState = 'Activo';

            try {
              await widget.service.saveProvider(widget.provider);
              Navigator.pop(context);
              CustomNotification.show(
                context,
                message: 'Proveedor guardado',
                backgroundColor: Colors.green,
                icon: Icons.check_circle,
              );
            } catch (e) {
              CustomNotification.show(
                context,
                message: 'Error al guardar: $e',
                backgroundColor: Colors.red,
                icon: Icons.error,
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}