
package com.example.almuerzoservice.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public class AlmuerzoResponseDTO {

    private Long id;
    private String cliente;
    private String plato;
    private Integer cantidad;
    private BigDecimal precio;
    private BigDecimal total;
    private LocalDate fechaPedido;
    private Boolean entregado;

    public AlmuerzoResponseDTO(Long id, String cliente, String plato,
                               Integer cantidad, BigDecimal precio, BigDecimal total,
                               LocalDate fechaPedido, Boolean entregado) {
        this.id = id;
        this.cliente = cliente;
        this.plato = plato;
        this.cantidad = cantidad;
        this.precio = precio;
        this.total = total;
        this.fechaPedido = fechaPedido;
        this.entregado = entregado;
    }

    public Long getId() { return id; }
    public String getCliente() { return cliente; }
    public String getPlato() { return plato; }
    public Integer getCantidad() { return cantidad; }
    public BigDecimal getPrecio() { return precio; }
    public BigDecimal getTotal() { return total; }
    public LocalDate getFechaPedido() { return fechaPedido; }
    public Boolean getEntregado() { return entregado; }
}
