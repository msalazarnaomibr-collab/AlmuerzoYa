
package com.example.almuerzoservice.controller;

import com.example.almuerzoservice.dto.RegisterDTO;
import com.example.almuerzoservice.dto.LoginDTO;
import com.example.almuerzoservice.dto.AuthResponseDTO;
import com.example.almuerzoservice.service.AuthService;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponseDTO> registrar(
            @Valid @RequestBody RegisterDTO dto) {

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(authService.registrar(dto));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDTO> iniciarSesion(
            @Valid @RequestBody LoginDTO dto) {

        return ResponseEntity.ok(
                authService.iniciarSesion(dto));
    }
}
