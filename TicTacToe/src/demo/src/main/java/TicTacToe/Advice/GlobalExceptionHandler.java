package TicTacToe.Advice;

import TicTacToe.Exceptions.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@AllArgsConstructor
@ControllerAdvice
public class GlobalExceptionHandler {

    SimpMessagingTemplate messagingTemplate;

    @ExceptionHandler(IllegalRegistrationArgumentException.class)
    public ResponseEntity<String> IllegalRegistrationArgumentException(IllegalRegistrationArgumentException ex) {
        return new ResponseEntity<>(ex.getMessage(), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(AuthorizationException.class)
    public ResponseEntity<String> AuthorizationException(AuthorizationException ex) {
        return new ResponseEntity<>(ex.getMessage(), ex.getStatus());
    }

    @ExceptionHandler(BadRequestException.class)
    public String BadRequestException(BadRequestException ex, Model model, RedirectAttributes redirectAttributes, HttpServletResponse response, HttpServletRequest request) {
        String requestUri = request.getRequestURI();
        if (requestUri.startsWith("/joinGame/")) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
            return "redirect:/showOnlineGames";
        }
        model.addAttribute("error", ex.getMessage());
        model.addAttribute("status", ex.getHttpStatus());
        model.addAttribute("message", ex.getErrorMessage());
        response.setStatus(HttpStatus.NOT_FOUND.value());
        return "errorPage";
    }

    @ExceptionHandler(FileException.class)
    public ResponseEntity<String> FileException(FileException ex) {
        return new ResponseEntity<>(ex.getMessage(), ex.getStatus());
    }

    @MessageExceptionHandler(GameMotionException.class)
    public void GameMotionException(GameMotionException ex) {
        messagingTemplate.convertAndSend("/topic/" + ex.getGameId() + "/error", ex.getMessage());
    }
}
