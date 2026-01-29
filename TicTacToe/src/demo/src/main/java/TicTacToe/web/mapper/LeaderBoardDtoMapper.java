package TicTacToe.web.mapper;

import TicTacToe.domain.model.UserStats;
import TicTacToe.web.model.LeaderBoardDto;

import java.util.ArrayList;
import java.util.List;

public class LeaderBoardDtoMapper {

    public static ArrayList<LeaderBoardDto> toDtoList(List<UserStats> userStats) {
        ArrayList<LeaderBoardDto> leaderBoardDtos = new ArrayList<>();
        for (int i = 0; i < userStats.size(); i++) {
            leaderBoardDtos.add(new LeaderBoardDto(i + 1, userStats.get(i).getUser().getLogin(), userStats.get(i).getUser().getId(), userStats.get(i).getWinRate()));
        }
        return leaderBoardDtos;
    }
}
