package TicTacToe.datasource.service;

import TicTacToe.Exceptions.BadRequestException;
import TicTacToe.datasource.mapper.UserStatsMapper;
import TicTacToe.datasource.model.UserStatsEntity;
import TicTacToe.datasource.repository.UserStatsRepository;
import TicTacToe.domain.model.User;
import TicTacToe.domain.model.UserStats;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
@AllArgsConstructor
public class UserStatsRepositoryService {
    private final UserStatsRepository userStatsRepository;
    private final UserRepositoryService userRepositoryService;

    public UserStats findUserStatsByUserId(UUID userId) {
        return UserStatsMapper.toDomain(userStatsRepository.findByUserId(userId).orElseGet(() -> {
            User user = userRepositoryService.getReferenceById(userId).orElseThrow(() -> new BadRequestException("User not found", HttpStatus.NOT_FOUND, "Пользователь с данным id не найден."));
            userStatsRepository.save(new UserStatsEntity(user, 0, 0, 0, 0, 0));
            return new UserStatsEntity(user, 0, 0, 0, 0, 0);
        }));
    }

    public ArrayList<UserStats> findBestFivePlayers() {
        Iterable<UserStatsEntity> userStats = userStatsRepository.findBestPlayers();
        return StreamSupport.stream(userStats.spliterator(), false)
                .map(UserStatsMapper::toDomain)
                .collect(Collectors.toCollection(ArrayList::new));
    }

    public void save(UserStatsEntity userStatsEntity) {
        userStatsRepository.save(userStatsEntity);
    }
}
