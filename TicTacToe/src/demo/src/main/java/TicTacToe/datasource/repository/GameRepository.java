package TicTacToe.datasource.repository;

import TicTacToe.datasource.model.EntityGame;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;
import java.util.UUID;

public interface GameRepository extends CrudRepository<EntityGame, UUID> {

    @EntityGraph(attributePaths = {"player1", "player2"})
    Optional<EntityGame> findById(UUID uuid);

    @EntityGraph(attributePaths = {"player1", "player2"})
    Iterable<EntityGame> findAll();

    @EntityGraph(attributePaths = {"player1", "player2"})
    @Query("SELECT g FROM EntityGame AS g WHERE g.withBot = :withBot AND (g.player1.id = :playerId OR g.player2.id = :playerId) ORDER BY g.uuid DESC")
    Iterable<EntityGame> findByPlayer(UUID playerId, boolean withBot);

    @EntityGraph(attributePaths = {"player1", "player2"})
    @Query("SELECT g FROM EntityGame AS g WHERE g.withBot = false AND g.state = 'WAITING_PLAYER'")
    Iterable<EntityGame> findOnlineGames();

    @EntityGraph(attributePaths = {"player1", "player2"})
    @Query("SELECT g FROM EntityGame AS g WHERE g.withBot = false AND (g.player1.id = :playerId OR g.player2.id =: playerId) AND (g.state = 'WIN_PLAYER1' OR g.state = 'WIN_PLAYER2' OR g.state = 'DRAW') ORDER BY g.createDate DESC LIMIT 4")
    Iterable<EntityGame> findByPlayerLimitOnlineGames(UUID playerId);

}
