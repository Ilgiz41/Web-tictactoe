package TicTacToe.web.controller;

import TicTacToe.datasource.mapper.GameMapper;
import TicTacToe.datasource.service.GameRepositoryService;
import TicTacToe.domain.model.Game;
import TicTacToe.domain.service.BotGameService;
import TicTacToe.domain.service.OnlineGameService;
import TicTacToe.web.mapper.DtoMapper;
import TicTacToe.web.model.GameDto;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.util.UUID;

@Controller
@AllArgsConstructor
public class WebSocketGameController {

    private final OnlineGameService onlineGameService;
    private final BotGameService botGameService;
    private final GameRepositoryService gameRepositoryService;
    private final SimpMessagingTemplate messagingTemplate;

    @Data
    public static class GameMoveMessage {
        private String gameId;
        private String playerId;
        private int index;
    }

    @MessageMapping("/onlineGame.makeMove")
    public void onlineGame(@Payload GameMoveMessage moveMessage) {
        UUID gameId = UUID.fromString(moveMessage.getGameId());
        UUID playerId = UUID.fromString(moveMessage.getPlayerId());
        int index = moveMessage.getIndex();
        Game currentGame = GameMapper.toDomain(gameRepositoryService.findGameById(gameId));
        onlineGameService.makeMove(currentGame, playerId, index);
        String currentHeader = onlineGameService.getHeaderForGamePage(currentGame);
        GameDto updateDto = DtoMapper.toDto(currentGame, currentHeader);
        messagingTemplate.convertAndSend("/topic/" + gameId, updateDto);
    }

    @MessageMapping({"/game.makeMove"})
    public void game(@Payload GameMoveMessage moveMessage) {
        UUID gameId = UUID.fromString(moveMessage.getGameId());
        int index = moveMessage.getIndex();
        Game currentGame = GameMapper.toDomain(gameRepositoryService.findGameById(gameId));
        botGameService.makeMove(currentGame, null, index);
        String currentHeader = botGameService.getHeaderForGamePage(currentGame);
        GameDto updateDto = DtoMapper.toDto(currentGame, currentHeader);
        messagingTemplate.convertAndSend("/topic/" + gameId, updateDto);
    }
}