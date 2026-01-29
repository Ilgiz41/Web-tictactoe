package TicTacToe.datasource.service;

import TicTacToe.Exceptions.BadRequestException;
import TicTacToe.datasource.mapper.GameMapper;
import TicTacToe.datasource.model.EntityGame;
import TicTacToe.datasource.repository.GameRepository;
import TicTacToe.domain.model.Game;
import TicTacToe.domain.model.GameState;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Repository
@Data
@AllArgsConstructor
public class GameRepositoryService {
    private final GameRepository gameRepository;

    public EntityGame findGameById(UUID id) {
        Optional<EntityGame> game = gameRepository.findById(id);
        if (game.isPresent()) {
            return game.get();
        }
        throw new BadRequestException("Game not found", HttpStatus.BAD_REQUEST, "Игра с выбранным id не найдена.");
    }

    public ArrayList<Game> findOnlineGames() {
        ArrayList<Game> games = new ArrayList<>();
        gameRepository.findOnlineGames().forEach(gameEntity -> {
            Game gameDomain = GameMapper.toDomain(gameEntity);
            games.add(gameDomain);
        });
        return games;
    }

    public ArrayList<Game> findOnlineGamesByStatus(UUID userId, String status) {
        if (status.equals("WAITING_PLAYER")) return findOnlineGames();
        Iterable<EntityGame> entityGames = gameRepository.findByPlayer(userId, false);
        return StreamSupport.stream(entityGames.spliterator(), false)
                .map(GameMapper::toDomain)
                .filter(game -> game.getGameState() == GameState.MOTION_PLAYER || game.getGameState() == GameState.MOTION_PLAYER2)
                .collect(Collectors.toCollection(ArrayList::new));
    }

    public ArrayList<Game> findGamesByPlayerIdCompletedGames(UUID playerId) {
        return StreamSupport.stream(gameRepository.findByPlayer(playerId, false).spliterator(), false)
                .map(GameMapper::toDomain)
                .filter(game -> game.getGameState().equals(GameState.WIN_PLAYER2) || game.getGameState().equals(GameState.WIN_PLAYER1) || game.getGameState().equals(GameState.DRAW))
                .collect(Collectors.toCollection(ArrayList::new));
    }

    public ArrayList<Game> findByPlayerLimitOnlineGames(UUID userId) {
        Iterable<EntityGame> entityGames = gameRepository.findByPlayerLimitOnlineGames(userId);
        return StreamSupport.stream(entityGames.spliterator(), false)
                .map(GameMapper::toDomain)
                .collect(Collectors.toCollection(ArrayList::new));
    }

    public void save(EntityGame entityGame) {
        gameRepository.save(entityGame);
    }
}
