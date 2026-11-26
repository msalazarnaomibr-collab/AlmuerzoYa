
package com.example.almuerzoservice.controller;

import com.example.almuerzoservice.dto.AlmuerzoDTO;
import com.example.almuerzoservice.dto.AlmuerzoResponseDTO;
import com.example.almuerzoservice.service.AlmuerzoService;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/almuerzos")
public class AlmuerzoController {

    private final AlmuerzoService almuerzoService;

    public AlmuerzoController(AlmuerzoService almuerzoService) {
        this.almuerzoService = almuerzoService;
    }

    @GetMapping
    public ResponseEntity<List<AlmuerzoResponseDTO>> listar(
            Authentication authentication) {

        return ResponseEntity.ok(
                almuerzoService.listar(authentication.getName()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AlmuerzoResponseDTO> buscarPorId(
            @PathVariable Long id,
            Authentication authentication) {

        return ResponseEntity.ok(
                almuerzoService.buscarPorId(
                        id, authentication.getName()));
    }

    @PostMapping
    public ResponseEntity<AlmuerzoResponseDTO> registrar(
            @Valid @RequestBody AlmuerzoDTO dto,
            Authentication authentication) {

        return ResponseEntity.status(HttpStatus.CREATED).body(
                almuerzoService.registrar(
                        dto, authentication.getName()));
    }

    @PutMapping("/{id}")
    public ResponseEntity<AlmuerzoResponseDTO> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody AlmuerzoDTO dto,
            Authentication authentication) {

        return ResponseEntity.ok(
                almuerzoService.actualizar(
                        id, dto, authentication.getName()));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(
            @PathVariable Long id,
            Authentication authentication) {

        almuerzoService.eliminar(id, authentication.getName());

        return ResponseEntity.noContent().build();
    }
    @PutMapping("/{id}/entregado")
    public AlmuerzoResponseDTO marcarEntregado(
            @PathVariable Long id,
            Authentication authentication) {

        return almuerzoService.marcarEntregado(
                id,
                authentication.getName()
        );
    }
}

