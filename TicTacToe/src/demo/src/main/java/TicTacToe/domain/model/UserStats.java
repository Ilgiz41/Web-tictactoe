package TicTacToe.domain.model;

import lombok.Data;

import java.util.UUID;

@Data
public class UserStats {

    private UUID id;
    private User user;
    private int winCount;
    private int loseCount;
    private int drawCount;
    private int totalCount;

    public double getWinRate() {
        if (totalCount == 0) {
            return 0.0;
        }
        return ((double) winCount / totalCount) * 100.0;
    }

    public UserStats(UUID id, User user, int winCount, int loseCount, int drawCount, int totalCount) {
        this.user = user;
        this.id = id;
        this.winCount = winCount;
        this.loseCount = loseCount;
        this.drawCount = drawCount;
        this.totalCount = totalCount;
    }

    public UserStats() {

    }
}
