
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../models/almuerzo.dart';

class OrderFormScreen extends StatefulWidget {
  final Almuerzo? pedido;

  const OrderFormScreen({super.key, this.pedido});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final clienteController = TextEditingController();
  final platoController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();

  bool cargando = false;

  bool get editando => widget.pedido != null;

  @override
  void initState() {
    super.initState();

    final pedido = widget.pedido;
    if (pedido != null) {
      clienteController.text = pedido.cliente;
      platoController.text = pedido.plato;
      cantidadController.text = pedido.cantidad.toString();
      precioController.text = pedido.precio.toStringAsFixed(2);
    }
  }

  Future<void> guardarPedido() async {
    final cantidad = int.tryParse(cantidadController.text);
    final precio = double.tryParse(precioController.text.replaceAll(',', '.'));

    if (clienteController.text.trim().isEmpty ||
        platoController.text.trim().isEmpty ||
        cantidad == null ||
        precio == null ||
        cantidad <= 0 ||
        precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa datos válidos en todos los campos')),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      if (editando) {
        await ApiService.actualizarAlmuerzo(
          widget.pedido!.id,
          clienteController.text.trim(),
          platoController.text.trim(),
          cantidad,
          precio,
        );
      } else {
        await ApiService.crearAlmuerzo(
          clienteController.text.trim(),
          platoController.text.trim(),
          cantidad,
          precio,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  void dispose() {
    clienteController.dispose();
    platoController.dispose();
    cantidadController.dispose();
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar pedido' : 'Nuevo pedido'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('🍱', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 70)),
            TextField(
              controller: clienteController,
              decoration: const InputDecoration(
                labelText: 'Nombre del cliente',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: platoController,
              decoration: const InputDecoration(
                labelText: 'Nombre del plato',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: precioController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Precio por unidad (S/)',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: cargando ? null : guardarPedido,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.rosa,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(editando ? 'Guardar cambios' : 'Registrar pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
