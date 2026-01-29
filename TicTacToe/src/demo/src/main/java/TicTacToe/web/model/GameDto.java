package TicTacToe.web.model;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class GameDto {
    private String header;
    private int[][] field;
    private String player1Name;
    private String player2Name;
    private String gameId;
}
