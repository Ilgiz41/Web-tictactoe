package TicTacToe.datasource.model;

import TicTacToe.domain.model.GameState;
import TicTacToe.domain.model.User;
import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Data
@Table(name = "Games")
public class EntityGame {
    @Getter
    @Embedded
    private EntityField field;
    @Setter
    @Getter
    @Id
    private UUID uuid;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createDate;

    @Enumerated(EnumType.STRING)
    private GameState state;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player1_id")
    private User player1;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player2_id")
    private User player2;
    @Column(name = "game_with_bot")
    private boolean withBot;
    @Column(name = "player_one_symbol")
    private int playerOneSymbol;
    @Column(name = "winner_id")
    private String winner;

    public EntityGame(EntityField field, UUID id, GameState state, User player1, User player2, boolean withBot, int playerOneSymbol) {
        this.field = field;
        this.uuid = id;
        this.state = state;
        this.player1 = player1;
        this.player2 = player2;
        this.withBot = withBot;
        this.playerOneSymbol = playerOneSymbol;
    }

    public EntityGame() {

    }
}
