package TicTacToe.datasource.repository;

import TicTacToe.datasource.model.EntityRole;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface RoleRepository extends CrudRepository<EntityRole, Integer> {
    Optional<EntityRole> findByName(String name);
}
