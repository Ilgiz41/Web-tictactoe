package TicTacToe.web.controller;

import TicTacToe.datasource.mapper.GameMapper;
import TicTacToe.datasource.service.GameRepositoryService;
import TicTacToe.domain.model.Game;
import TicTacToe.domain.service.BotGameService;
import TicTacToe.web.mapper.DtoMapper;
import TicTacToe.web.model.GameDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@AllArgsConstructor
@Controller
public class BotGameController {

    private final BotGameService botGameService;
    private final BotGameService gameService;
    private final GameRepositoryService gameRepositoryService;

    @PostMapping("/game")
    public String createGame(@AuthenticationPrincipal UUID userId, @RequestParam int playerSymbol) {
        Game currentGame = gameService.createNewGame(playerSymbol, userId);
        return "redirect:/game/" + currentGame.getId();
    }

    @GetMapping("/game/{gameId}")
    public String game(@AuthenticationPrincipal UUID userId, @PathVariable UUID gameId, Model model) throws JsonProcessingException {
        Game currentGame = GameMapper.toDomain(gameRepositoryService.findGameById(gameId));
        gameService.checkCorrectGame(currentGame, userId);
        ObjectMapper mapper = new ObjectMapper();
        GameDto gameDto = DtoMapper.toDto(currentGame, botGameService.getHeaderForGamePage(currentGame));
        model.addAttribute("initialGameDataDtoJson", mapper.writeValueAsString(gameDto));
        return "gamePage";
    }
}