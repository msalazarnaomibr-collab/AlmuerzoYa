
package com.example.almuerzoservice.dto;

public class AuthResponseDTO {

    private String token;
    private String tipo = "Bearer";
    private String email;
    private String rol;

    public AuthResponseDTO(String token, String email, String rol) {
        this.token = token;
        this.email = email;
        this.rol = rol;
    }

    public String getToken() {
        return token;
    }

    public String getTipo() {
        return tipo;
    }

    public String getEmail() {
        return email;
    }

    public String getRol() {
        return rol;
    }
}
