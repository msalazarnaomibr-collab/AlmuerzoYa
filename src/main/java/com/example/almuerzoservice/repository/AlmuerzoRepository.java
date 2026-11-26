
package com.example.almuerzoservice.repository;

import com.example.almuerzoservice.entity.Almuerzo;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AlmuerzoRepository extends JpaRepository<Almuerzo, Long> {

    List<Almuerzo> findByUsuarioId(Long usuarioId);

    List<Almuerzo> findByUsuarioIdAndId(Long usuarioId, Long id);
}
