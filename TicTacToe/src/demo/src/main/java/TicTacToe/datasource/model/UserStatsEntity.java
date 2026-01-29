package TicTacToe.datasource.model;

import TicTacToe.domain.model.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

import static jakarta.persistence.FetchType.LAZY;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "user_stats")
public class UserStatsEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @OneToOne(fetch = LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    @Column(name = "win_rate")
    private double winRate;
    @Column
    private int winCount;
    @Column
    private int loseCount;
    @Column
    private int drawCount;
    @Column
    private int totalCount;

    public UserStatsEntity(User user, double winRate, int winCount, int loseCount, int drawCount, int totalCount) {
        this.user = user;
        this.winRate = winRate;
        this.winCount = winCount;
        this.loseCount = loseCount;
        this.drawCount = drawCount;
        this.totalCount = totalCount;
    }
}
