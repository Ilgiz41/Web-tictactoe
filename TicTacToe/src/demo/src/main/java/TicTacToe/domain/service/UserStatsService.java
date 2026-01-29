package TicTacToe.domain.service;

import TicTacToe.datasource.mapper.UserStatsMapper;
import TicTacToe.datasource.service.UserStatsRepositoryService;
import TicTacToe.domain.model.User;
import TicTacToe.domain.model.UserStats;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class UserStatsService {
    private final UserStatsRepositoryService userStatsRepositoryService;

    public void updateUserStats(User user, String state) {

        UserStats userStats = userStatsRepositoryService.findUserStatsByUserId(user.getId()) == null ? new UserStats() : userStatsRepositoryService.findUserStatsByUserId(user.getId());

        switch (state) {
            case "WIN":
                userStats.setWinCount(userStats.getWinCount() + 1);
                break;
            case "LOSE":
                userStats.setLoseCount(userStats.getLoseCount() + 1);
                break;
            case "DRAW":
                userStats.setDrawCount(userStats.getDrawCount() + 1);
                break;
        }

        userStats.setTotalCount(userStats.getTotalCount() + 1);

        userStatsRepositoryService.save(UserStatsMapper.toDataSource(userStats));
    }
}