package TicTacToe.datasource.repository;

import TicTacToe.domain.model.User;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends CrudRepository<User, Long> {
    Optional<User> findById(UUID uuid);

    boolean existsUserByLogin(String login);

    Optional<User> findUserByLogin(String login);

    Optional<User> getReferenceById(UUID uuid);
}
