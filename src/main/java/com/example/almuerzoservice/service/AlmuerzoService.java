
package com.example.almuerzoservice.service;

import com.example.almuerzoservice.dto.AlmuerzoDTO;
import com.example.almuerzoservice.dto.AlmuerzoResponseDTO;
import com.example.almuerzoservice.entity.Almuerzo;
import com.example.almuerzoservice.entity.Usuario;
import com.example.almuerzoservice.repository.AlmuerzoRepository;
import com.example.almuerzoservice.repository.UsuarioRepository;

import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Service
public class AlmuerzoService {

    private final AlmuerzoRepository almuerzoRepository;
    private final UsuarioRepository usuarioRepository;

    public AlmuerzoService(
            AlmuerzoRepository almuerzoRepository,
            UsuarioRepository usuarioRepository) {
        this.almuerzoRepository = almuerzoRepository;
        this.usuarioRepository = usuarioRepository;
    }

    private Usuario obtenerUsuario(String email) {
        return usuarioRepository.findByEmail(email)
                .orElseThrow(() ->
                        new RuntimeException("Usuario no encontrado"));
    }

    private AlmuerzoResponseDTO convertirDTO(Almuerzo almuerzo) {

        BigDecimal total = almuerzo.getPrecio()
                .multiply(BigDecimal.valueOf(almuerzo.getCantidad()));

        return new AlmuerzoResponseDTO(
                almuerzo.getId(),
                almuerzo.getCliente(),
                almuerzo.getPlato(),
                almuerzo.getCantidad(),
                almuerzo.getPrecio(),
                total,
                almuerzo.getFechaPedido(),
                almuerzo.getEntregado()
        );
    }

    public List<AlmuerzoResponseDTO> listar(String email) {

        Usuario usuario = obtenerUsuario(email);

        return almuerzoRepository
                .findByUsuarioId(usuario.getId())
                .stream()
                .map(this::convertirDTO)
                .toList();
    }

    public AlmuerzoResponseDTO buscarPorId(Long id, String email) {

        Usuario usuario = obtenerUsuario(email);

        Almuerzo almuerzo = almuerzoRepository.findById(id)
                .filter(a -> a.getUsuario().getId().equals(usuario.getId()))
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.NOT_FOUND,
                                "Almuerzo no encontrado"
                        ));

        return convertirDTO(almuerzo);
    }

    public AlmuerzoResponseDTO registrar(
            AlmuerzoDTO dto, String email) {

        Usuario usuario = obtenerUsuario(email);

        Almuerzo almuerzo = new Almuerzo();

        almuerzo.setCliente(dto.getCliente());
        almuerzo.setPlato(dto.getPlato());
        almuerzo.setCantidad(dto.getCantidad());
        almuerzo.setPrecio(dto.getPrecio());
        almuerzo.setFechaPedido(LocalDate.now());
        almuerzo.setEntregado(false);
        almuerzo.setUsuario(usuario);

        return convertirDTO(almuerzoRepository.save(almuerzo));
    }

    public AlmuerzoResponseDTO actualizar(
            Long id, AlmuerzoDTO dto, String email) {

        Usuario usuario = obtenerUsuario(email);

        Almuerzo almuerzo = almuerzoRepository.findById(id)
                .filter(a -> a.getUsuario().getId().equals(usuario.getId()))
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.NOT_FOUND,
                                "Almuerzo no encontrado"
                        ));

        almuerzo.setCliente(dto.getCliente());
        almuerzo.setPlato(dto.getPlato());
        almuerzo.setCantidad(dto.getCantidad());
        almuerzo.setPrecio(dto.getPrecio());

        return convertirDTO(almuerzoRepository.save(almuerzo));
    }

    public void eliminar(Long id, String email) {

        Usuario usuario = obtenerUsuario(email);

        Almuerzo almuerzo = almuerzoRepository.findById(id)
                .filter(a -> a.getUsuario().getId().equals(usuario.getId()))
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.NOT_FOUND,
                                "Almuerzo no encontrado"
                        ));

        almuerzoRepository.delete(almuerzo);
    }
    public AlmuerzoResponseDTO marcarEntregado(Long id, String email) {

        Usuario usuario = obtenerUsuario(email);

        Almuerzo almuerzo = almuerzoRepository.findById(id)
                .filter(a -> a.getUsuario().getId().equals(usuario.getId()))
                .orElseThrow(() ->
                        new ResponseStatusException(
                                HttpStatus.NOT_FOUND,
                                "Almuerzo no encontrado"
                        ));

        almuerzo.setEntregado(true);

        return convertirDTO(almuerzoRepository.save(almuerzo));
    }
}
