package TicTacToe.domain.service;

import TicTacToe.domain.model.Game;

import java.util.UUID;

public interface GameService {

    Game createNewGame(int playerSymbol, UUID userId);

    boolean checkCorrectGame(Game currentGame, UUID playerId);

    void makeMove(Game currentGame, UUID playerId, int index);
}
