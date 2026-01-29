package TicTacToe.Exceptions;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.http.HttpStatus;

@Data
@EqualsAndHashCode(callSuper = false)
public class FileException extends RuntimeException {
    HttpStatus status;

    public FileException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
}
