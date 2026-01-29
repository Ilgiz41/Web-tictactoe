package TicTacToe.datasource.mapper;

import TicTacToe.datasource.model.UserStatsEntity;
import TicTacToe.domain.model.User;
import TicTacToe.domain.model.UserStats;

public class UserStatsMapper {

    public static UserStats toDomain(UserStatsEntity userStatsEntity) {
        User user = new User(userStatsEntity.getUser().getId(), userStatsEntity.getUser().getLogin(), userStatsEntity.getUser().getCreated());
        return new UserStats(userStatsEntity.getId(), user, userStatsEntity.getWinCount(), userStatsEntity.getLoseCount(), userStatsEntity.getDrawCount(), userStatsEntity.getTotalCount());
    }

    public static UserStatsEntity toDataSource(UserStats userStats) {
        return new UserStatsEntity(userStats.getId(), userStats.getUser(), userStats.getWinRate(), userStats.getWinCount(), userStats.getLoseCount(), userStats.getDrawCount(), userStats.getTotalCount());
    }

}
