package TicTacToe.domain.model;

import lombok.Data;

import java.util.UUID;

@Data
public class Game {
    private GameField field;
    private UUID id;
    private GameState gameState;
    private User player1;
    private User player2;
    private boolean withBot;
    private int playerOneSymbol;
    private int playerTwoSymbol;
    private String winnerId;

    public Game(GameField field, UUID id, GameState state, User player1, User player2, boolean withBot, int playerOneSymbol, int playerTwoSymbol) {
        this.field = field;
        this.id = id;
        this.gameState = state;
        this.player1 = player1;
        this.player2 = player2;
        this.withBot = withBot;
        this.playerOneSymbol = playerOneSymbol;
        this.playerTwoSymbol = playerTwoSymbol;
    }

    public Game() {

    }

    public void setCell(int row, int column, int symbol) {
        field.getField()[row][column] = symbol;
    }

    public int getCell(int row, int column) {
        return field.getField()[row][column];
    }

}
