package TicTacToe.web.controller;

import TicTacToe.datasource.mapper.GameMapper;
import TicTacToe.datasource.service.GameRepositoryService;
import TicTacToe.domain.model.Game;
import TicTacToe.domain.service.OnlineGameService;
import TicTacToe.web.mapper.DtoMapper;
import TicTacToe.web.model.GameDto;
import TicTacToe.web.model.GameHistoryDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.UUID;

@Controller
@AllArgsConstructor
public class OnlineGameController {

    private final OnlineGameService onlineGameService;
    private final GameRepositoryService gameRepositoryService;
    private final SimpMessagingTemplate messagingTemplate;

    @PostMapping("/onlineGame")
    public String onlineGame(@RequestParam int playerSymbol, @AuthenticationPrincipal UUID userId) {
        Game currentGame = onlineGameService.createNewGame(playerSymbol, userId);
        return "redirect:/onlineGame/" + currentGame.getId();
    }

    @GetMapping("/onlineGame/{gameId}")
    public String onlineGame(@AuthenticationPrincipal UUID userId, @PathVariable UUID gameId, Model model) throws JsonProcessingException {
        Game game = GameMapper.toDomain(gameRepositoryService.findGameById(gameId));
        onlineGameService.joinGame(userId, gameId);

        String headerText = onlineGameService.getHeaderForGamePage(game);
        GameDto initialDto = DtoMapper.toDto(game, headerText);
        ObjectMapper mapper = new ObjectMapper();
        String initialGameDataDtoJson = mapper.writeValueAsString(initialDto);

        messagingTemplate.convertAndSend("/topic/" + gameId, initialGameDataDtoJson);
        model.addAttribute("initialGameDataDtoJson", initialGameDataDtoJson);
        model.addAttribute("playerId", userId.toString());
        return "onlineGame";
    }

    @GetMapping("/onlineGames/{status}")
    public String onlineGames(@AuthenticationPrincipal UUID userId, @PathVariable String status, Model model) {
        model.addAttribute("games", DtoMapper.toOnlineGamesPage(gameRepositoryService.findOnlineGamesByStatus(userId, status)));
        model.addAttribute("selectedGameStatus", status);
        return "onlineGames";
    }

    @PostMapping("/joinGame/{gameId}")
    public String joinGame(@PathVariable UUID gameId, @AuthenticationPrincipal UUID userId) {
        onlineGameService.joinGame(userId, gameId);
        return "redirect:/onlineGame/" + gameId;
    }

    @GetMapping("/gameHistory/{userId}")
    public String showOnlineGames(@PathVariable UUID userId, Model model, @AuthenticationPrincipal UUID currentUserId) {
        ArrayList<Game> games = gameRepositoryService.findGamesByPlayerIdCompletedGames(userId);
        ArrayList<GameHistoryDto> gameHistoryDtos = DtoMapper.toHistoryDtoList(games, userId);
        model.addAttribute("selectedGameStatus");
        if (games.isEmpty()) {
            model.addAttribute("message", "Игры с данным фильтром не найдены");
        }
        model.addAttribute("games", gameHistoryDtos);
        model.addAttribute("showViewButton", userId.equals(currentUserId));
        return "onlineGameHistory";
    }
}
