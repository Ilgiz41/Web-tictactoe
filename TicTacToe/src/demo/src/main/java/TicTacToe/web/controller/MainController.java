package TicTacToe.web.controller;

import TicTacToe.datasource.service.GameRepositoryService;
import TicTacToe.datasource.service.UserRepositoryService;
import TicTacToe.datasource.service.UserStatsRepositoryService;
import TicTacToe.domain.model.User;
import TicTacToe.domain.service.UploadFilesService;
import TicTacToe.domain.service.UserService;
import TicTacToe.web.mapper.DtoMapper;
import TicTacToe.web.mapper.LeaderBoardDtoMapper;
import TicTacToe.web.mapper.UserStatsDtoMapper;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@AllArgsConstructor
@Controller
public class MainController {

    private final UserRepositoryService userRepositoryService;
    private final UserStatsRepositoryService userStatsRepositoryService;
    private final GameRepositoryService gameRepositoryService;
    private final UploadFilesService uploadFilesService;
    private final UserService userService;

    @GetMapping("/")
    public String mainPage(@AuthenticationPrincipal UUID userId, Model model) {
        User user = userRepositoryService.findById(userId);
        model.addAttribute("username", user.getLogin());
        return "mainPage";
    }

    @GetMapping("/profile")
    public String profilePage(@AuthenticationPrincipal UUID userId) {
        return "redirect:/profile/" + userId;
    }

    @GetMapping("/profile/{userId}")
    public String userProfilePage(@PathVariable UUID userId, Model model, @AuthenticationPrincipal UUID userId2) {
        model.addAttribute("user", UserStatsDtoMapper.toUserProfileDto(userStatsRepositoryService.findUserStatsByUserId(userId)));
        model.addAttribute("games", DtoMapper.toHistoryDtoList(gameRepositoryService.findByPlayerLimitOnlineGames(userId), userId));
        model.addAttribute("isLoggedIn", userId2.equals(userId));
        return "userProfile";
    }

    @GetMapping("/leaderboard")
    public String leaderboardPage(Model model) {
        model.addAttribute("leaderboard", LeaderBoardDtoMapper.toDtoList(userStatsRepositoryService.findBestFivePlayers()));
        return "leaderBoard";
    }

    @GetMapping("/profileSettings")
    public String profileSettingPage(Model model, @AuthenticationPrincipal UUID userId) {
        model.addAttribute("hasAvatar", uploadFilesService.doesFileExist(userId));
        return "profileSettings";
    }

    @PutMapping("/changeUsername")
    public ResponseEntity<String> changeUsername(@AuthenticationPrincipal UUID userId, @RequestParam("username") String username) {
        return userService.changeUsername(userId, username);
    }
}
