package TicTacToe.domain.service;

import TicTacToe.Exceptions.IllegalRegistrationArgumentException;
import TicTacToe.datasource.service.GameRepositoryService;
import TicTacToe.datasource.service.RoleRepositoryService;
import TicTacToe.datasource.service.UserRepositoryService;
import TicTacToe.domain.model.Roles;
import TicTacToe.domain.model.User;
import TicTacToe.security.model.JwtRequest;
import TicTacToe.security.model.JwtResponse;
import TicTacToe.security.service.JwtProvider;
import TicTacToe.security.service.WebUtil;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@Data
@AllArgsConstructor
public class UserService {
    private final UserRepositoryService userRepositoryService;
    private final GameRepositoryService gameRepositoryService;
    private final RoleRepositoryService roleRepositoryService;
    private final WebUtil webUtil;
    private final JwtProvider jwtProvider;
    private final PasswordEncoder passwordEncoder;

    public JwtResponse registerNewUser(JwtRequest jwtRequest) {
        nameAndPasswordValidated(jwtRequest);
        User user = new User(jwtRequest.getLogin(), hashPassword(jwtRequest.getPassword()));
        user.addRole(roleRepositoryService.findByName(Roles.USER));
        userRepositoryService.save(user);
        return new JwtResponse(jwtProvider.createToken(user), jwtProvider.createRefreshToken(user));
    }

    public void nameAndPasswordValidated(JwtRequest jwtRequest) {
        if (jwtRequest.getLogin().isEmpty() || jwtRequest.getPassword().isEmpty()) {
            throw new IllegalRegistrationArgumentException("Поля не могут быть пустыми!");
        }

        if (!checkUserExists(jwtRequest.getLogin())) {
            throw new IllegalRegistrationArgumentException("Имя пользователя уже занято!");
        }

        if (jwtRequest.getLogin().length() > 20) {
            throw new IllegalRegistrationArgumentException("Имя не должно превышать длину в 20 символов!");
        }

        if (jwtRequest.getLogin().length() < 4) {
            throw new IllegalRegistrationArgumentException("Имя не должно быть короче 4 символов!");
        }

        if (jwtRequest.getPassword().length() < 5) {
            throw new IllegalRegistrationArgumentException("Пароль должен состоять из не менее 5 символов!");
        }
    }

    public ResponseEntity<String> changeUsername(UUID userId, String username) {
        if (!checkUserExists(username)) {
            return new ResponseEntity<>("Имя занято.", HttpStatus.CONFLICT);
        }

        User user = userRepositoryService.getReferenceById(userId).orElseThrow(() -> new IllegalRegistrationArgumentException("Пользователь не найден."));
        user.setLogin(username);
        userRepositoryService.save(user);
        return new ResponseEntity<>("Имя успешно изменено", HttpStatus.OK);
    }

    public String hashPassword(String password) {
        return passwordEncoder.encode(password);
    }

    public boolean checkUserExists(String login) {
        return !userRepositoryService.existsByLogin(login);
    }
}
