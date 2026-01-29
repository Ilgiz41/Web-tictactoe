package TicTacToe.web.controller;

import TicTacToe.domain.service.AuthenticationService;
import TicTacToe.domain.service.UserService;
import TicTacToe.security.model.JwtRequest;
import TicTacToe.security.model.JwtResponse;
import TicTacToe.security.service.WebUtil;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
@Controller
public class AuthenticationController {

    private final UserService userService;
    private final AuthenticationService authenticationService;
    private final WebUtil webUtil;

    @GetMapping("/signUp")
    public String signUp(Model model) {
        model.addAttribute(new JwtRequest());
        return "/signUp";
    }

    @PostMapping("/signUp")
    public ResponseEntity<String> signUp(@RequestBody JwtRequest jwtRequest, HttpServletResponse response) {
        JwtResponse jwtResponse = userService.registerNewUser(jwtRequest);
        webUtil.addCookie(response, "JWTAccessToken", jwtResponse.getAccessToken(), false);
        webUtil.addCookie(response, "JWTRefreshToken", jwtResponse.getRefreshToken(), true);
        return new ResponseEntity<>("Успешная регистрация.", HttpStatus.OK);
    }

    @GetMapping("/signIn")
    public String signIn() {
        return "signIn";
    }

    @PostMapping("/signIn")
    public ResponseEntity<String> signIn(@RequestBody JwtRequest jwtRequest, HttpServletResponse response) {
        JwtResponse jwtResponse = authenticationService.authorize(jwtRequest);
        webUtil.addCookie(response, "JWTAccessToken", jwtResponse.getAccessToken(), false);
        webUtil.addCookie(response, "JWTRefreshToken", jwtResponse.getRefreshToken(), true);
        return new ResponseEntity<>("Успешная авторизация.", HttpStatus.OK);
    }
}