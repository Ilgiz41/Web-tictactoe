package TicTacToe.datasource.repository;

import TicTacToe.datasource.model.UserStatsEntity;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserStatsRepository extends CrudRepository<UserStatsEntity, UUID> {

    @EntityGraph(attributePaths = {"user"})
    Optional<UserStatsEntity> findByUserId(UUID userId);

    @EntityGraph(attributePaths = {"user"})
    @Query("SELECT u FROM UserStatsEntity AS u ORDER BY u.winRate DESC LIMIT 5")
    Iterable<UserStatsEntity> findBestPlayers();

}