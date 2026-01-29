package TicTacToe.web.controller;

import TicTacToe.domain.service.UploadFilesService;
import lombok.AllArgsConstructor;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@AllArgsConstructor
@Controller
public class UploadFileController {

    private final UploadFilesService uploadFilesService;

    @PostMapping("/uploadAvatar")
    public ResponseEntity<String> uploadAvatar(@RequestParam("avatar") MultipartFile file, @AuthenticationPrincipal UUID userId) {
        uploadFilesService.uploadFile(file, userId);
        return new ResponseEntity<>("Файл успешно загружен.", HttpStatus.OK);
    }

    @GetMapping("/avatars/{userId}")
    public ResponseEntity<UrlResource> getUserAvatar(@PathVariable UUID userId) {
        return uploadFilesService.getUserAvatar(userId);
    }

    @DeleteMapping("/deleteAvatar")
    public ResponseEntity<String> deleteAvatar(@AuthenticationPrincipal UUID userId) {
        return uploadFilesService.deleteUserAvatar(userId);
    }
}
