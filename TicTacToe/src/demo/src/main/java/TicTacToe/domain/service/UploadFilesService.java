package TicTacToe.domain.service;

import TicTacToe.Exceptions.FileException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Stream;

@Service
public class UploadFilesService {

    private final String avatarsPath;

    public UploadFilesService(@Value("${avatars.path}") String avatarsPath) {
        this.avatarsPath = avatarsPath;
    }

    public void uploadFile(MultipartFile file, UUID userId) {
        fileIsCorrect(file);
        String newFileName = userId.toString() + "_avatar" + getFileExtension(file);
        Path uploadPath = Paths.get(avatarsPath);
        uploadPath = uploadPath.resolve(newFileName);
        uploadFile(file, uploadPath);
    }

    private void uploadFile(MultipartFile file, Path uploadPath) {
        try {
            Files.copy(file.getInputStream(), uploadPath, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new FileException("Не удалось загрузить файл.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    public boolean doesFileExist(UUID userId) {
        Path file = getFilePath(userId);
        return file != null;
    }

    public Path getFilePath(UUID userId) {
        try (Stream<Path> paths = Files.list(Path.of(avatarsPath))) {
            return paths
                    .filter(Files::isRegularFile)
                    .filter(path -> path.getFileName().toString().startsWith(userId.toString() + "_avatar."))
                    .findFirst()
                    .orElse(null);
        } catch (IOException e) {
            throw new FileException("Аватар не найден.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    public ResponseEntity<String> deleteUserAvatar(UUID userId) {
        Path avatarFile = getFilePath(userId);
        if (avatarFile == null) {
            return new ResponseEntity<>("Аватар не найден.", HttpStatus.INTERNAL_SERVER_ERROR);
        } else {
            deleteFile(avatarFile);
        }
        return new ResponseEntity<>("Аватар успешно удален.", HttpStatus.OK);
    }

    public void deleteFile(Path filePath) {
        try {
            Files.delete(filePath);
        } catch (IOException e) {
            throw new FileException("Ошибка при удалении.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    public ResponseEntity<UrlResource> getUserAvatar(UUID userId) {
        Path avatarFile = getFilePath(userId);
        try {
            if (avatarFile != null) {

                UrlResource resource = new UrlResource(avatarFile.toUri());
                if (resource.exists() && resource.isReadable()) {

                    String contentType = Files.probeContentType(avatarFile);
                    if (contentType == null) {
                        contentType = "application/octet-stream";
                    }

                    return ResponseEntity.ok()
                            .contentType(MediaType.parseMediaType(contentType))
                            .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + resource.getFilename() + "\"")
                            .body(resource);
                }
            }
            return getDefaultAvatar();
        } catch (IOException e) {
            return getDefaultAvatar();
        }
    }

    public ResponseEntity<UrlResource> getDefaultAvatar() {
        try {
            UrlResource defaultAvatar = new UrlResource(Paths.get(avatarsPath).toUri());
            String contentType = Files.probeContentType(defaultAvatar.getFile().toPath());
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(defaultAvatar);
        } catch (IOException e) {
            throw new FileException("Не удалось загрузить аватар по умолчанию", HttpStatus.NOT_FOUND);
        }
    }

    public void fileIsCorrect(MultipartFile file) {
        if (file.isEmpty()) {
            throw new FileException("Пожалуйста, выберите файл для загрузки.", HttpStatus.BAD_REQUEST);
        }
        long fileSizeInMegabytes = getFileSizeInMegabytes(file);
        if (fileSizeInMegabytes > 10) {
            throw new FileException("Размер файла не должен превышать 10МБ.", HttpStatus.BAD_REQUEST);
        }

        String fileName = file.getOriginalFilename();
        if (fileName == null || fileName.isEmpty()) {
            throw new FileException("Файл не имеет расширения.", HttpStatus.BAD_REQUEST);
        }

        String fileExtension = getFileExtension(file);

        if (!fileExtension.equals(".jpg") && !fileExtension.equals(".png") && !fileExtension.equals(".jpeg")) {
            throw new FileException("Допустимые расширения файла: jpg, jpeg, png", HttpStatus.BAD_REQUEST);
        }
    }

    private String getFileExtension(MultipartFile file) {
        return Objects.requireNonNull(file.getOriginalFilename()).substring(file.getOriginalFilename().lastIndexOf("."));
    }

    private long getFileSizeInMegabytes(MultipartFile file) {
        return file.getSize() / (1024 * 1024);
    }
}
