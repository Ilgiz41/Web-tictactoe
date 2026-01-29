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

@Service
@AllArgsConstructor
public class OnlineGameService implements GameService {

    private final GameRepositoryService gameRepositoryService;
    private final GameServiceLogic gameServiceLogic;
    private final GameMapper gameMapper;
    private final UserStatsService userStatsService;

    @Override
    public Game createNewGame(int playerSymbol, UUID userId) {
        User user = new User(userId);
        Game game = new Game(new GameField(), UUID.randomUUID(), GameState.WAITING_PLAYER, user, null, false, playerSymbol, playerSymbol * -1);
        gameRepositoryService.save(gameMapper.toDataSource(game));
        return game;
    }

    @Override
    public boolean checkCorrectGame(Game currentGame, UUID playerId) {
        if (currentGame.isWithBot()) {
            throw new BadRequestException("This game is designed for the online only.", HttpStatus.BAD_REQUEST, "Эта игра предназначена только для онлайн игр.");
        }
        if (currentGame.getPlayer2() == null || currentGame.getPlayer1().getId().equals(playerId) || currentGame.getPlayer2().getId().equals(playerId)) {
            return true;
        } else {
            throw new BadRequestException("Game is full.", HttpStatus.BAD_REQUEST, "Игра занята либо удалена.");
        }
    }

    @Override
    public void makeMove(Game currentGame, UUID playerId, int index) {
        if (!twoPlayersInGame(currentGame)) {
            throw new GameMotionException("Дождитесь подключения второго игрока!", currentGame.getId().toString());
        }

        if (gameServiceLogic.checkEndGame(currentGame)) {
            throw new GameMotionException("Игра уже завершена!", currentGame.getId().toString());
        }

        if (!checkCorrectMotion(currentGame, playerId)) {
            throw new GameMotionException("Дождитесь хода противника!", currentGame.getId().toString());
        }

        int playerSymbol = currentGame.getPlayer1().getId().equals(playerId) ? currentGame.getPlayerOneSymbol() : currentGame.getPlayerOneSymbol() * -1;
        gameServiceLogic.makeMove(currentGame, index, playerSymbol);
        currentGame.setGameState(currentGame.getGameState().equals(GameState.MOTION_PLAYER) ? GameState.MOTION_PLAYER2 : GameState.MOTION_PLAYER);
        checkWinner(currentGame);
        gameRepositoryService.save(gameMapper.toDataSource(currentGame));
    }

    public void joinGame(UUID userId, UUID gameId) {
        Game currentGame = GameMapper.toDomain(gameRepositoryService.findGameById(gameId));
        checkCorrectGame(currentGame, userId);

        if (currentGame.getGameState() != GameState.WAITING_PLAYER) {
            return;
        }

        if (!currentGame.getPlayer1().getId().equals(userId)) {
            currentGame.setPlayer2(new User(userId));
        }

        if (twoPlayersInGame(currentGame)) {
            currentGame.setGameState(GameState.MOTION_PLAYER);
        }

        gameRepositoryService.save(gameMapper.toDataSource(currentGame));
    }

    public boolean checkCorrectMotion(Game currentGame, UUID playerId) {
        return (currentGame.getPlayer1().getId().equals(playerId) && currentGame.getGameState().equals(GameState.MOTION_PLAYER)) || (currentGame.getPlayer2().getId().equals(playerId) && currentGame.getGameState().equals(GameState.MOTION_PLAYER2));
    }

    public boolean twoPlayersInGame(Game currentGame) {
        return currentGame.getPlayer1().getId() != null && currentGame.getPlayer2() != null;
    }

    public void checkWinner(Game currentGame) {
        if (currentGame.getPlayerOneSymbol() == gameServiceLogic.checkWin(currentGame)) {
            currentGame.setGameState(GameState.WIN_PLAYER1);
            userStatsService.updateUserStats(currentGame.getPlayer1(), "WIN");
            userStatsService.updateUserStats(currentGame.getPlayer2(), "LOSE");
            currentGame.setWinnerId(currentGame.getPlayer1().getId().toString());
        } else if (currentGame.getPlayerOneSymbol() * -1 == gameServiceLogic.checkWin(currentGame)) {
            currentGame.setGameState(GameState.WIN_PLAYER2);
            userStatsService.updateUserStats(currentGame.getPlayer1(), "LOSE");
            userStatsService.updateUserStats(currentGame.getPlayer2(), "WIN");
            currentGame.setWinnerId(currentGame.getPlayer2().getId().toString());
        } else if (gameServiceLogic.isDraw(currentGame)) {
            currentGame.setGameState(GameState.DRAW);
            userStatsService.updateUserStats(currentGame.getPlayer1(), "DRAW");
            userStatsService.updateUserStats(currentGame.getPlayer2(), "DRAW");
            currentGame.setWinnerId("DRAW");
        }
    }

    public String getHeaderForGamePage(Game currentGame) {
        return switch (currentGame.getGameState()) {
            case DRAW -> "Ничья!";
            case MOTION_PLAYER -> "Ход игрока: " + currentGame.getPlayer1().getLogin();
            case MOTION_PLAYER2 -> "Ход игрока: " + currentGame.getPlayer2().getLogin();
            case WAITING_PLAYER -> "Ожидание второго игрока";
            case WIN_PLAYER1 -> "Победа игрока: " + currentGame.getPlayer1().getLogin();
            case WIN_PLAYER2 -> "Победа игрока: " + currentGame.getPlayer2().getLogin();
            default -> "Пустота";
        };
    }
}