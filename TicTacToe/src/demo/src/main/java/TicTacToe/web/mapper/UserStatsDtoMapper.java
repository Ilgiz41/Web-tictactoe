package TicTacToe.web.mapper;

import TicTacToe.domain.model.UserStats;
import TicTacToe.web.model.UserProfileDto;

public class UserStatsDtoMapper {

    public static UserProfileDto toUserProfileDto(UserStats userStats) {
        return new UserProfileDto(userStats.getUser().getId().toString(), userStats.getUser().getLogin(), userStats.getWinRate(), userStats.getLoseCount(), userStats.getWinCount(), userStats.getDrawCount(), userStats.getUser().getCreated().toString());
    }
}
