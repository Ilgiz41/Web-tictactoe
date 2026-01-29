package TicTacToe.security.service;

import TicTacToe.datasource.model.EntityRole;
import TicTacToe.domain.model.User;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Date;
import java.util.stream.Collectors;

@Service
public class JwtProvider {

    private final SecretKey secretKey;

    public JwtProvider(@Value("${jwt.secret}") String secret) {
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes());
    }

    public String createToken(User user) {
        ArrayList<String> roleList = user.getRoles().stream()
                .map(EntityRole::getAuthority)
                .collect(Collectors.toCollection(ArrayList::new));
        return Jwts.builder()
                .subject(user.getId().toString())
                .claim("role", roleList)
                .issuer("TicTacToe")
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + Duration.ofMinutes(5).toMillis()))
                .signWith(secretKey)
                .compact();
    }

    public String createRefreshToken(User user) {
        return Jwts.builder()
                .subject(user.getId().toString())
                .issuer("TicTacToe")
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + Duration.ofHours(14).toMillis()))
                .signWith(secretKey)
                .compact();
    }

    public String getSubject(String token) {
        return Jwts.parser().setSigningKey(secretKey).build().parseSignedClaims(token).getPayload().getSubject();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .setSigningKey(secretKey)
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}