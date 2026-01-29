package TicTacToe.datasource.mapper;

import TicTacToe.datasource.model.EntityField;
import TicTacToe.datasource.model.EntityGame;
import TicTacToe.datasource.service.UserRepositoryService;
import TicTacToe.domain.model.Game;
import TicTacToe.domain.model.GameField;
import TicTacToe.domain.model.User;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@AllArgsConstructor
@Component
public class GameMapper {

    UserRepositoryService userRepositoryService;

    public EntityGame toDataSource(Game game) {
        EntityGame entityGame = new EntityGame();
        EntityField field = new EntityField();
        field.setField(game.getField().getField());
        entityGame.setField(field);
        entityGame.setState(game.getGameState());
        entityGame.setUuid(game.getId());
        entityGame.setWithBot(game.isWithBot());
        entityGame.setPlayerOneSymbol(game.getPlayerOneSymbol());
        entityGame.setWinner(game.getWinnerId() == null ? null : game.getWinnerId());
        User user1 = userRepositoryService.getReferenceById(game.getPlayer1().getId()).get();
        entityGame.setPlayer1(user1);
        if (game.getPlayer2() != null) {
            User user2 = userRepositoryService.getReferenceById(game.getPlayer2().getId()).get();
            entityGame.setPlayer2(user2);
        }
        return entityGame;
    }

    public static Game toDomain(EntityGame storageGame) {
        Game game = new Game();
        GameField field = new GameField();
        User user1 = new User();
        User user2 = new User();

        user1.setId(storageGame.getPlayer1().getId());
        user1.setLogin(storageGame.getPlayer1().getLogin());

        field.setField(storageGame.getField().getField());
        game.setField(field);
        game.setId(storageGame.getUuid());

        game.setPlayer1(user1);

        game.setWithBot(storageGame.isWithBot());
        game.setPlayerOneSymbol(storageGame.getPlayerOneSymbol());
        game.setPlayerTwoSymbol(storageGame.getPlayerOneSymbol() * -1);
        game.setGameState(storageGame.getState());
        game.setWinnerId(storageGame.getWinner() == null ? "" : storageGame.getWinner());

        if (storageGame.getPlayer2() != null) {
            user2.setId(storageGame.getPlayer2().getId());
            user2.setLogin(storageGame.getPlayer2().getLogin());
            game.setPlayer2(user2);
        }
        return game;
    }
}