package TicTacToe.domain.service;

import TicTacToe.Exceptions.AuthorizationException;
import TicTacToe.datasource.service.UserRepositoryService;
import TicTacToe.domain.model.User;
import TicTacToe.security.model.JwtRequest;
import TicTacToe.security.model.JwtResponse;
import TicTacToe.security.service.JwtProvider;
import TicTacToe.security.service.WebUtil;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@Data
@AllArgsConstructor
public class AuthenticationService {

    private final PasswordEncoder passwordEncoder;
    private final UserRepositoryService userRepositoryService;
    private final JwtProvider jwtProvider;
    private final WebUtil webUtil;

    public User authenticate(String token) {
        User user = userRepositoryService.findById(UUID.fromString(jwtProvider.getSubject(token)));
        if (user == null) {
            throw new AuthenticationServiceException("Invalid token");
        }
        return user;
    }

    public JwtResponse refreshAccessToken(String refreshToken) {
        if (!jwtProvider.validateToken(refreshToken)) {
            return null;
        }
        User user = userRepositoryService.findById(UUID.fromString(jwtProvider.getSubject(refreshToken)));
        String token = jwtProvider.createToken(user);
        return new JwtResponse(token, UUID.randomUUID().toString());
    }

    public JwtResponse authorize(JwtRequest jwtRequest) {
        User user = new User();
        user.setLogin(jwtRequest.getLogin());
        user.setPassword(jwtRequest.getPassword());
        User userFromDB = getUserFromDB(user);
        if (userFromDB == null) {
            throw new AuthorizationException("Неверное имя пользователя", HttpStatus.UNAUTHORIZED);
        }
        if (passwordsIsEquals(user.getPassword(), userFromDB.getPassword())) {
            return new JwtResponse(jwtProvider.createToken(userFromDB), jwtProvider.createRefreshToken(userFromDB));
        } else {
            throw new AuthorizationException("Неверный пароль!", HttpStatus.UNAUTHORIZED);
        }
    }

    public User getUserFromDB(User user) {
        return userRepositoryService.getUserByLogin(user.getLogin());
    }

    public boolean passwordsIsEquals(String rawPassword, String hashedPassword) {
        return passwordEncoder.matches(rawPassword, hashedPassword);
    }
}
