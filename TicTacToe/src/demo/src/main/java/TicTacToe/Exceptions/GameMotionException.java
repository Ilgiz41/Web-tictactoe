package TicTacToe.Exceptions;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class GameMotionException extends RuntimeException {

    String gameId;

    public GameMotionException(String message, String gameId) {
        super(message);
        this.gameId = gameId;
    }
}
