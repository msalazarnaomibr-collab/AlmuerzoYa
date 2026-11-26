
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<dynamic> pedidos = [];
  bool cargando = true;
  String filtro = 'Todos';
  String busqueda = '';

  @override
  void initState() {
    super.initState();
    cargarPedidos();
  }

  // CARGAR PEDIDOS
  Future<void> cargarPedidos() async {
    if (!mounted) return;

    setState(() => cargando = true);

    try {
      final resultado = await ApiService.getAlmuerzos();

      if (!mounted) return;

      setState(() {
        pedidos = resultado;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => cargando = false);
      }
    }
  }

  // REGISTRAR Y EDITAR PEDIDOS
  Future<void> abrirFormulario([dynamic pedido]) async {
    final clienteController = TextEditingController(
      text: pedido == null ? '' : pedido['cliente']?.toString() ?? '',
    );

    final platoController = TextEditingController(
      text: pedido == null ? '' : pedido['plato']?.toString() ?? '',
    );

    final cantidadController = TextEditingController(
      text: pedido == null ? '' : pedido['cantidad'].toString(),
    );

    final precioController = TextEditingController(
      text: pedido == null ? '' : pedido['precio'].toString(),
    );

    bool guardando = false;

    try {
      final resultado = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (contextDialogo, actualizarDialogo) {
              return AlertDialog(
                title: Text(
                  pedido == null
                      ? 'Registrar almuerzo 🍱'
                      : 'Editar pedido',
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: clienteController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del cliente',
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: platoController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del plato',
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: cantidadController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: precioController,
                        keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Precio por unidad (S/)',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: guardando
                        ? null
                        : () => Navigator.pop(dialogContext, false),
                    child: const Text('Cancelar'),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.rosa,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: guardando
                        ? null
                        : () async {
                      final cliente =
                      clienteController.text.trim();
                      final plato =
                      platoController.text.trim();

                      final cantidad = int.tryParse(
                        cantidadController.text.trim(),
                      );

                      final precio = double.tryParse(
                        precioController.text
                            .trim()
                            .replaceAll(',', '.'),
                      );

                      if (cliente.isEmpty ||
                          plato.isEmpty ||
                          cantidad == null ||
                          precio == null ||
                          cantidad <= 0 ||
                          precio <= 0) {
                        ScaffoldMessenger.of(dialogContext)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Completa todos los campos correctamente',
                            ),
                          ),
                        );
                        return;
                      }

                      actualizarDialogo(() {
                        guardando = true;
                      });

                      try {
                        if (pedido == null) {
                          await ApiService.crearAlmuerzo(
                            cliente,
                            plato,
                            cantidad,
                            precio,
                          );
                        } else {
                          await ApiService.actualizarAlmuerzo(
                            pedido['id'] as int,
                            cliente,
                            plato,
                            cantidad,
                            precio,
                          );
                        }

                        if (!dialogContext.mounted) return;

                        Navigator.pop(dialogContext, true);
                      } catch (e) {
                        if (!dialogContext.mounted) return;

                        actualizarDialogo(() {
                          guardando = false;
                        });

                        ScaffoldMessenger.of(dialogContext)
                            .showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    child: guardando
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Guardar'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (resultado == true && mounted) {
        await cargarPedidos();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              pedido == null
                  ? '¡Pedido registrado correctamente!'
                  : '¡Pedido actualizado correctamente!',
            ),
          ),
        );
      }
    } finally {
      clienteController.dispose();
      platoController.dispose();
      cantidadController.dispose();
      precioController.dispose();
    }
  }

  // MARCAR COMO ENTREGADO
  Future<void> marcarEntregado(dynamic pedido) async {
    try {
      await ApiService.marcarEntregado(
        pedido['id'] as int,
      );

      await cargarPedidos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Pedido entregado!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ELIMINAR PEDIDO
  Future<void> eliminarPedido(dynamic pedido) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar pedido'),
          content: Text(
            '¿Estás segura de eliminar el pedido de ${pedido['cliente']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    try {
      await ApiService.eliminarAlmuerzo(
        pedido['id'] as int,
      );

      await cargarPedidos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido eliminado correctamente'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibles = pedidos.where((p) {
      final coincideFiltro = filtro == 'Todos' ||
          (filtro == 'Pendientes' && p['entregado'] != true) ||
          (filtro == 'Entregados' && p['entregado'] == true);

      final texto = busqueda.toLowerCase();

      final coincideBusqueda =
          (p['cliente'] ?? '').toString().toLowerCase().contains(texto) ||
              (p['plato'] ?? '').toString().toLowerCase().contains(texto);

      return coincideFiltro && coincideBusqueda;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis almuerzos 🍱',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: cargarPedidos,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              await ApiService.logout();

              if (!mounted) return;

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                    (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => abrirFormulario(),
        backgroundColor: AppTheme.rosa,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Registrar pedido'),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar cliente o plato...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (valor) {
                setState(() => busqueda = valor);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Todos',
                  label: Text('Todos'),
                ),
                ButtonSegment(
                  value: 'Pendientes',
                  label: Text('Pendientes'),
                ),
                ButtonSegment(
                  value: 'Entregados',
                  label: Text('Entregados'),
                ),
              ],
              selected: {filtro},
              onSelectionChanged: (value) {
                setState(() => filtro = value.first);
              },
            ),
          ),

          Expanded(
            child: cargando
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : visibles.isEmpty
                ? const Center(
              child: Text(
                'Aún no tienes pedidos 🍓\nPresiona "Registrar pedido"',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            )
                : RefreshIndicator(
              onRefresh: cargarPedidos,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  16, 16, 16, 90,
                ),
                itemCount: visibles.length,
                itemBuilder: (context, index) {
                  final pedido = visibles[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            pedido['cliente'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.marron,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text('Plato: ${pedido['plato']}'),
                          Text('Cantidad: ${pedido['cantidad']}'),
                          Text('Total: S/ ${pedido['total']}'),

                          Text(
                            'Estado: ${pedido['entregado'] == true ? 'Entregado' : 'Pendiente'}',
                          ),

                          const Divider(),

                          Wrap(
                            alignment: WrapAlignment.end,
                            children: [
                              if (pedido['entregado'] != true)
                                TextButton.icon(
                                  onPressed: () =>
                                      marcarEntregado(pedido),
                                  icon: const Icon(
                                    Icons.check_circle_outline,
                                  ),
                                  label: const Text('Entregar'),
                                ),

                              TextButton.icon(
                                onPressed: () =>
                                    abrirFormulario(pedido),
                                icon: const Icon(Icons.edit),
                                label: const Text('Editar'),
                              ),

                              TextButton.icon(
                                onPressed: () =>
                                    eliminarPedido(pedido),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Eliminar',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
