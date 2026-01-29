package TicTacToe.Exceptions;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.http.HttpStatus;

@EqualsAndHashCode(callSuper = false)
@Data
public class AuthorizationException extends RuntimeException {
    private final HttpStatus status;

    public AuthorizationException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
}
