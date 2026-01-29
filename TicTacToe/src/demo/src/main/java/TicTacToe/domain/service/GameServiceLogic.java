package TicTacToe.domain.service;

import TicTacToe.domain.model.Game;
import org.springframework.stereotype.Service;

@Service
public class GameServiceLogic {

    static final int X = 1;
    static final int O = -1;
    static int PLAYER_TWO_SYMBOL;
    static final int EMPTY = 0;
    static final int SIZE = 3;

    public boolean checkEndGame(Game game) {
        return checkWin(game) == X || checkWin(game) == O || isDraw(game);
    }

    public boolean moveValidation(int index, Game currentGame) {
        int row = index / 3;
        int column = index % 3;
        return currentGame.getCell(row, column) == EMPTY;
    }

    public int checkWin(Game game) {
        for (int i = 0; i < SIZE; i++) {
            if (game.getCell(i, 0) == game.getCell(i, 1) && game.getCell(i, 1) == game.getCell(i, 2) && game.getCell(i, 2) != EMPTY) {
                return game.getCell(i, 2);
            }
            if (game.getCell(0, i) == game.getCell(1, i) && game.getCell(1, i) == game.getCell(2, i) && game.getCell(2, i) != EMPTY) {
                return game.getCell(2, i);
            }
        }
        if (game.getCell(0, 0) == game.getCell(1, 1) && game.getCell(1, 1) == game.getCell(2, 2) && game.getCell(2, 2) != EMPTY) {
            return game.getCell(2, 2);
        }
        if (game.getCell(0, 2) == game.getCell(1, 1) && game.getCell(1, 1) == game.getCell(2, 0) && game.getCell(2, 0) != EMPTY) {
            return game.getCell(2, 0);
        }
        return 0;
    }

    public boolean isDraw(Game game) {
        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                if (game.getCell(i, j) == EMPTY) {
                    return false;
                }
            }
        }
        return true;
    }

    public void makeMove(Game currentGame, int index, int playerSymbol) {
        if (moveValidation(index, currentGame)) {
            int row = index / 3;
            int column = index % 3;
            currentGame.setCell(row, column, playerSymbol);
        }
    }

    public boolean cellIsEmpty(int row, int column, Game game) {
        return game.getCell(row, column) == EMPTY;
    }
}
