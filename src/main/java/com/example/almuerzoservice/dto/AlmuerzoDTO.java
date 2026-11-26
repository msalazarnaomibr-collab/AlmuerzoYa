
package com.example.almuerzoservice.dto;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

public class AlmuerzoDTO {

    @NotBlank(message = "El cliente es obligatorio")
    @Size(max = 100)
    private String cliente;

    @NotBlank(message = "El plato es obligatorio")
    @Size(max = 100)
    private String plato;

    @NotNull(message = "La cantidad es obligatoria")
    @Min(value = 1, message = "La cantidad debe ser mayor que cero")
    private Integer cantidad;

    @NotNull(message = "El precio es obligatorio")
    @DecimalMin(value = "0.01", message = "El precio debe ser mayor que cero")
    @Digits(integer = 6, fraction = 2)
    private BigDecimal precio;

    public String getCliente() { return cliente; }
    public String getPlato() { return plato; }
    public Integer getCantidad() { return cantidad; }
    public BigDecimal getPrecio() { return precio; }

    public void setCliente(String cliente) { this.cliente = cliente; }
    public void setPlato(String plato) { this.plato = plato; }
    public void setCantidad(Integer cantidad) { this.cantidad = cantidad; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }
}
