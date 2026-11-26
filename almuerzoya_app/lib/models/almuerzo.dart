
class Almuerzo {
  final int id;
  final String cliente;
  final String plato;
  final int cantidad;
  final double precio;
  final double total;
  final String fechaPedido;
  final bool entregado;

  Almuerzo({
    required this.id,
    required this.cliente,
    required this.plato,
    required this.cantidad,
    required this.precio,
    required this.total,
    required this.fechaPedido,
    required this.entregado,
  });

  factory Almuerzo.fromJson(Map<String, dynamic> json) {
    return Almuerzo(
      id: json['id'],
      cliente: json['cliente'] ?? '',
      plato: json['plato'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      precio: (json['precio'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      fechaPedido: json['fechaPedido'] ?? '',
      entregado: json['entregado'] ?? false,
    );
  }
}
