package TicTacToe.datasource.service;

import TicTacToe.datasource.repository.UserRepository;
import TicTacToe.domain.model.User;
import lombok.Data;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
@Data
public class UserRepositoryService {
    private final UserRepository repository;

    UserRepositoryService(UserRepository repository) {
        this.repository = repository;
    }

    public void save(User user) {
        repository.save(user);
    }

    public Optional<User> getReferenceById(UUID id) {
        return repository.getReferenceById(id);
    }

    public User findById(UUID uuid) throws NullPointerException {
        Optional<User> optionalUser = repository.findById(uuid);
        if (optionalUser.isPresent()) {
            return optionalUser.get();
        }
        return null;
    }

    public boolean existsByLogin(String login) {
        return repository.existsUserByLogin(login);
    }

    public User getUserByLogin(String login) {
        Optional<User> optionalUser = repository.findUserByLogin(login);
        if (optionalUser.isPresent()) {
            return optionalUser.get();
        }
        return null;
    }
}
