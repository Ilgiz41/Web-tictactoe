package TicTacToe.datasource.service;

import TicTacToe.datasource.model.EntityRole;
import TicTacToe.datasource.repository.RoleRepository;
import TicTacToe.domain.model.Roles;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@AllArgsConstructor
@Service
public class RoleRepositoryService {

    private final RoleRepository roleRepository;

    public EntityRole findByName(Roles role) {
        return roleRepository.findByName(role.getAuthority()).orElseGet(() -> {
            EntityRole entityRole = new EntityRole(role.getAuthority());
            return roleRepository.save(entityRole);
        });
    }

}
