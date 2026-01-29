package TicTacToe.domain.service;

import TicTacToe.Exceptions.BadRequestException;
import TicTacToe.Exceptions.GameMotionException;
import TicTacToe.datasource.mapper.GameMapper;
import TicTacToe.datasource.service.GameRepositoryService;
import TicTacToe.domain.model.Game;
import TicTacToe.domain.model.GameField;
import TicTacToe.domain.model.GameState;
import TicTacToe.domain.model.User;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.UUID;

import static TicTacToe.domain.service.GameServiceLogic.*;

@AllArgsConstructor
@Service("BotGameService")

public class BotGameService implements GameService {

    private final GameMapper gameMapper;
    private final GameServiceLogic gameServiceLogic;
    private final GameRepositoryService gameRepositoryService;

    public Game createNewGame(int playerOneSymbol, UUID uuid) {
        User user = new User(uuid);
        Game game = new Game(new GameField(), UUID.randomUUID(), GameState.MOTION_PLAYER, user, null, true, playerOneSymbol, playerOneSymbol * -1);
        gameRepositoryService.save(gameMapper.toDataSource(game));
        return game;
    }

    public boolean checkCorrectGame(Game currentGame, UUID playerId) {
        if (!currentGame.isWithBot()) {
            throw new BadRequestException("This game is designed for the bot only.", HttpStatus.BAD_REQUEST, "Эта игра может быть загружена только при игре с ботом.");
        }
        if (!currentGame.getPlayer1().getId().equals(playerId)) {
            throw new BadRequestException("Access denied.", HttpStatus.BAD_REQUEST, "Это не ваша игра.");
        }
        return true;
    }

    public void setBotSymbol(int playerOneSymbol) {
        PLAYER_TWO_SYMBOL = playerOneSymbol * -1;
    }

    public String getHeaderForGamePage(Game currentGame) {
        setBotSymbol(currentGame.getPlayerOneSymbol());
        String textMessage = "Ваш ход";
        if (gameServiceLogic.checkWin(currentGame) == currentGame.getPlayerOneSymbol()) {
            textMessage = "Вы победили!";
            currentGame.setGameState(GameState.WIN);
        } else if (gameServiceLogic.checkWin(currentGame) == PLAYER_TWO_SYMBOL) {
            textMessage = "Вы проиграли";
            currentGame.setGameState(GameState.LOSE);
        } else if (gameServiceLogic.checkWin(currentGame) == EMPTY && gameServiceLogic.isDraw(currentGame)) {
            textMessage = "Ничья!";
            currentGame.setGameState(GameState.DRAW);
        }
        gameRepositoryService.save(gameMapper.toDataSource(currentGame));
        return textMessage;
    }

    public int findBestMove(Game currentGame) {
        int bestScore = Integer.MIN_VALUE;
        int bestIndex = 0;

        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                if (gameServiceLogic.cellIsEmpty(i, j, currentGame)) {
                    currentGame.setCell(i, j, PLAYER_TWO_SYMBOL);
                    int score = minimax(0, false, currentGame);
                    currentGame.setCell(i, j, EMPTY);

                    if (score > bestScore) {
                        bestScore = score;
                        bestIndex = i * SIZE + j;
                    }
                }
            }
        }
        return bestIndex;
    }

    public int minimax(int depth, boolean isMaximising, Game game) {
        int score = evaluate(game);

        if (score == 10) {
            return score - depth;
        }
        if (score == -10) {
            return score + depth;
        }
        if (gameServiceLogic.isDraw(game) || depth > 200) {
            return 0;
        }

        if (isMaximising) {
            int best = Integer.MIN_VALUE;
            for (int i = 0; i < SIZE; i++) {
                for (int j = 0; j < SIZE; j++) {
                    if (gameServiceLogic.cellIsEmpty(i, j, game)) {
                        game.setCell(i, j, PLAYER_TWO_SYMBOL);
                        int currentScore = minimax(depth + 1, false, game);
                        best = Math.max(best, currentScore);
                        game.setCell(i, j, EMPTY);
                    }
                }
            }
            return best;
        } else {
            int best = Integer.MAX_VALUE;
            for (int i = 0; i < SIZE; i++) {
                for (int j = 0; j < SIZE; j++) {
                    if (gameServiceLogic.cellIsEmpty(i, j, game)) {
                        game.setCell(i, j, game.getPlayerOneSymbol());
                        int currentScore = minimax(depth + 1, true, game);
                        best = Math.min(best, currentScore);
                        game.setCell(i, j, EMPTY);
                    }
                }
            }
            return best;
        }
    }

    public void makeMove(Game currentGame, UUID userId, int index) {
        if (gameServiceLogic.checkEndGame(currentGame)) {
            throw new GameMotionException("Игра уже завершена!", currentGame.getId().toString());
        }
        if (gameServiceLogic.moveValidation(index, currentGame)) {
            gameServiceLogic.makeMove(currentGame, index, currentGame.getPlayerOneSymbol());
            botMakeMove(currentGame);
        }
        gameRepositoryService.save(gameMapper.toDataSource(currentGame));
    }

    public void botMakeMove(Game currentGame) {
        if (!gameServiceLogic.checkEndGame(currentGame)) {
            int bestIndex = findBestMove(currentGame);
            int bestRow = bestIndex / 3;
            int bestCol = bestIndex % 3;
            currentGame.setCell(bestRow, bestCol, PLAYER_TWO_SYMBOL);
        }
    }

    protected int evaluate(Game game) {
        if (gameServiceLogic.checkWin(game) == game.getPlayerOneSymbol()) return -10;
        if (gameServiceLogic.checkWin(game) == PLAYER_TWO_SYMBOL) return 10;
        return 0;
    }
}
