package TicTacToe.web.model;


import lombok.AllArgsConstructor;
import lombok.Data;

@AllArgsConstructor
@Data
public class GameHistoryDto {
    String gameId;
    String playerName;
    String enemyName;
    String gameStatus;
}
