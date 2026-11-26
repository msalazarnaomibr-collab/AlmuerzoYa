
package com.example.almuerzoservice.service;

import com.example.almuerzoservice.dto.RegisterDTO;
import com.example.almuerzoservice.dto.LoginDTO;
import com.example.almuerzoservice.dto.AuthResponseDTO;
import com.example.almuerzoservice.entity.Usuario;
import com.example.almuerzoservice.repository.UsuarioRepository;
import com.example.almuerzoservice.security.JwtService;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;

    public AuthService(
            UsuarioRepository usuarioRepository,
            PasswordEncoder passwordEncoder,
            AuthenticationManager authenticationManager,
            JwtService jwtService) {

        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
    }

    public AuthResponseDTO registrar(RegisterDTO dto) {

        if (usuarioRepository.existsByEmail(dto.getEmail())) {
            throw new IllegalArgumentException(
                    "El correo ya está registrado");
        }

        Usuario usuario = new Usuario();

        usuario.setNombre(dto.getNombre());
        usuario.setEmail(dto.getEmail());
        usuario.setPassword(
                passwordEncoder.encode(dto.getPassword()));
        usuario.setRol("USER");

        usuarioRepository.save(usuario);

        String token = jwtService.generateToken(
                usuario.getEmail(),
                usuario.getRol());

        return new AuthResponseDTO(
                token,
                usuario.getEmail(),
                usuario.getRol());
    }

    public AuthResponseDTO iniciarSesion(LoginDTO dto) {

        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        dto.getEmail(),
                        dto.getPassword()));

        Usuario usuario = usuarioRepository
                .findByEmail(dto.getEmail())
                .orElseThrow(() ->
                        new IllegalArgumentException(
                                "Usuario no encontrado"));

        String token = jwtService.generateToken(
                usuario.getEmail(),
                usuario.getRol());

        return new AuthResponseDTO(
                token,
                usuario.getEmail(),
                usuario.getRol());
    }
}
