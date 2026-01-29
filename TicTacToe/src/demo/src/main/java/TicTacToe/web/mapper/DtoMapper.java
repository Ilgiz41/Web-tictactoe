package TicTacToe.web.mapper;

import TicTacToe.domain.model.Game;
import TicTacToe.web.model.GameDto;
import TicTacToe.web.model.GameHistoryDto;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.UUID;

@Component
@AllArgsConstructor
public class DtoMapper {

    public static GameDto toDto(Game game, String header) {
        String player1Name = game.getPlayer1().getLogin();
        String player2Name = game.getPlayer2() == null ? "" : game.getPlayer2().getLogin();
        return new GameDto(header, game.getField().getField(), player1Name, player2Name, game.getId().toString());
    }

    public static ArrayList<GameHistoryDto> toHistoryDtoList(ArrayList<Game> games, UUID userId) {
        ArrayList<GameHistoryDto> dtos = new ArrayList<>();
        games.forEach(game -> {
            String gameId = game.getId().toString();
            String playerName = game.getPlayer1().getId().equals(userId) ? game.getPlayer1().getLogin() : game.getPlayer2() == null ? "" : game.getPlayer2().getLogin();
            String enemyName = game.getPlayer1().getId().equals(userId) ? game.getPlayer2() == null ? "" : game.getPlayer2().getLogin() : game.getPlayer1().getLogin();
            String gameState = game.getGameState().toString();
            if (!game.getWinnerId().equals("") && !game.getWinnerId().equals("DRAW")) {
                gameState = game.getWinnerId().equals(userId.toString()) ? "WIN" : "LOSE";
            }
            dtos.add(new GameHistoryDto(gameId, playerName, enemyName, gameState));
        });
        return dtos;
    }

    public static ArrayList<GameHistoryDto> toOnlineGamesPage(ArrayList<Game> games) {
        ArrayList<GameHistoryDto> dtos = new ArrayList<>();
        games.forEach(game -> {
            String gameId = game.getId().toString();
            String playerName = game.getPlayer1().getLogin();
            String player2Name = game.getPlayer2() == null ? "" : game.getPlayer2().getLogin();
            dtos.add(new GameHistoryDto(gameId, playerName, player2Name, game.getGameState().toString()));
        });
        return dtos;
    }
}