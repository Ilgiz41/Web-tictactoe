package TicTacToe.web.model;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserProfileDto {
    private String id;
    private String login;
    private double winRatio;
    private int losses;
    private int wins;
    private int draws;
    private String createDate;
}
