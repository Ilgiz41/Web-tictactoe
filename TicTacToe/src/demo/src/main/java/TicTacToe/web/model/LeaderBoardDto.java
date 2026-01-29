package TicTacToe.web.model;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
public class LeaderBoardDto {
    private int rank;
    private String login;
    private UUID userId;
    private double winRatio;
}
