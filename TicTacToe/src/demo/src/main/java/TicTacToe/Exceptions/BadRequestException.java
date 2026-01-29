package TicTacToe.Exceptions;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.http.HttpStatus;

@Data
@EqualsAndHashCode(callSuper = false)
public class BadRequestException extends RuntimeException {

    String errorMessage;
    HttpStatus httpStatus;

    public BadRequestException(String message, HttpStatus httpStatus, String errorMessage) {
        super(message);
        this.errorMessage = errorMessage;
        this.httpStatus = httpStatus;
    }
}
