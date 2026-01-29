package TicTacToe.domain.model;

import lombok.Data;

@Data
public class GameField {
    private static final int BOARD_SIZE = 3;
    private int[][] field;

    public GameField() {
        field = new int[BOARD_SIZE][BOARD_SIZE];
        for (int i = 0; i < BOARD_SIZE; i++) {
            for (int j = 0; j < BOARD_SIZE; j++) {
                field[i][j] = 0;
            }
        }
    }
}
