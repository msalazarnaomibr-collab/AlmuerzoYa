package com.example.almuerzoservice.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "almuerzo")
public class Almuerzo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String cliente;

    @Column(nullable = false, length = 100)
    private String plato;

    @Column(nullable = false)
    private Integer cantidad;

    @Column(nullable = false, precision = 8, scale = 2)
    private BigDecimal precio;

    @Column(name = "fecha_pedido", nullable = false)
    private LocalDate fechaPedido;

    @Column(nullable = false)
    private Boolean entregado = false;

    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    public Almuerzo() {
    }

    public Long getId() { return id; }
    public String getCliente() { return cliente; }
    public String getPlato() { return plato; }
    public Integer getCantidad() { return cantidad; }
    public BigDecimal getPrecio() { return precio; }
    public LocalDate getFechaPedido() { return fechaPedido; }
    public Boolean getEntregado() { return entregado; }
    public Usuario getUsuario() { return usuario; }

    public void setId(Long id) { this.id = id; }
    public void setCliente(String cliente) { this.cliente = cliente; }
    public void setPlato(String plato) { this.plato = plato; }
    public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }
    public void setFechaPedido(LocalDate fechaPedido) { this.fechaPedido = fechaPedido; }
    public void setEntregado(Boolean entregado) { this.entregado = entregado; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }
}

