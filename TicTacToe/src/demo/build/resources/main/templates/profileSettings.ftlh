<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Настройки профиля</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/main.css">
    <link rel="stylesheet" href="/static/css/default.css">
    <style>

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f4f8;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
            box-sizing: border-box;
            position: relative;
        }

        .profile-settings-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            text-align: center;
            max-width: 600px;
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 25px;
        }

        h1 {
            color: #2c3e50;
            font-weight: 700;
            font-size: 2.5em;
            margin-bottom: 15px;
            position: relative;
            padding-bottom: 10px;
        }

        h1::after {
            content: '';
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
            width: 150px;
            height: 4px;
            background: linear-gradient(90deg, #6dd5ed, #2193b0);
            border-radius: 2px;
        }

        .avatar-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
        }

        button, .button-style {
            display: inline-block;
            background-color: #457b9d;
            color: white;
            padding: 12px 25px;
            font-size: 1.1em;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.1s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
            margin: 5px;
            min-width: 150px;
            text-align: center;
        }

        button:hover, .button-style:hover {
            background-color: #3b6a8a;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.25);
        }

        button:active, .button-style:active {
            background-color: #345f7a;
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: #fefefe;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 450px;
            text-align: center;
            position: relative;
            animation-name: animatetop;
            animation-duration: 0.4s;
        }

        .modal-content h2 {
            color: #2c3e50;
            font-size: 1.8em;
            margin-bottom: 25px;
        }

        .close-button {
            color: #aaa;
            position: absolute;
            top: 15px;
            right: 25px;
            font-size: 30px;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .close-button:hover,
        .close-button:focus {
            color: #333;
        }

        .modal-content form {
            display: flex;
            flex-direction: column;
            gap: 20px;
            align-items: center;
        }

        .modal-content input[type="file"],
        .modal-content input[type="text"] {
            border: 2px dashed #a8dadc;
            border-radius: 8px;
            padding: 15px;
            width: 100%;
            text-align: center;
            color: #457b9d;
            cursor: pointer;
            transition: border-color 0.3s ease;
        }

        .modal-content input[type="file"]:hover,
        .modal-content input[type="text"]:hover {
            border-color: #2193b0;
        }

        .modal-content button[type="submit"] {
            background-color: #457b9d;
            min-width: 120px;
        }

        .modal-content button[type="submit"]:hover {
            background-color: #3b6a8a;
        }

        .modal-content button[type="submit"]:active {
            background-color: #345f7a;
        }

        .upload-status-message {
            margin-top: 20px;
            padding: 10px;
            border-radius: 8px;
            font-weight: bold;
            display: none;
        }

        .upload-status-message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .upload-status-message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @keyframes animatetop {
            from {
                top: -300px;
                opacity: 0
            }
            to {
                top: 0;
                opacity: 1
            }
        }

        #confirmationModal .modal-content {
            max-width: 400px;
        }

        #confirmationModal .modal-content p {
            font-size: 1.2em;
            color: #444;
            margin-bottom: 30px;
        }

        #confirmationModal .modal-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        #confirmationModal .modal-buttons button {
            min-width: 100px;
            padding: 10px 20px;
            font-size: 1em;
        }

        #confirmDeleteBtn {
            background-color: #dc3545;
        }

        #confirmDeleteBtn:hover {
            background-color: #c82333;
        }

        #cancelDeleteBtn {
            background-color: #6c757d;
        }

        #cancelDeleteBtn:hover {
            background-color: #5a6268;
        }

        .toast-message {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 15px 25px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            opacity: 0;
            transition: opacity 0.5s ease-in-out, transform 0.5s ease-in-out;
            pointer-events: none;
            text-align: center;
            max-width: 300px;
            word-wrap: break-word;
            transform: translateY(50px);
        }

        .toast-message.show {
            opacity: 1;
            pointer-events: auto;
            transform: translateY(0);
        }

        .toast-message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .toast-message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
<div class="profile-settings-container">
    <h1>Настройки профиля</h1>

    <div class="avatar-section">
        <button id="changeAvatarBtn" class="button-style">Сменить аватар</button>
        <#if hasAvatar?? && hasAvatar>
            <button id="deleteAvatarBtn" class="button-style bg-red-500 hover:bg-red-600">Удалить аватар</button>
        </#if>
    </div>

    <div class="username-section flex flex-col items-center gap-4 w-full">
        <button id="changeUsernameBtn" class="button-style bg-blue-500 hover:bg-blue-600">Сменить имя</button>
    </div>

    <a href="/profile" class="button-style bg-blue-600 hover:bg-blue-700">Перейти в профиль</a>
</div>

<div id="uploadAvatarModal" class="modal">
    <div class="modal-content">
        <span class="close-button">&times;</span>
        <h2>Загрузить новый аватар</h2>
        <form id="avatarUploadForm" enctype="multipart/form-data">
            <input type="file" id="avatarFile" name="avatarFile" accept="image/*" required>
            <button type="submit" class="button-style">Загрузить</button>
        </form>
        <div id="uploadStatusMessage" class="upload-status-message"></div>
    </div>
</div>

<div id="confirmationModal" class="modal">
    <div class="modal-content">
        <span class="close-button" id="closeConfirmationModalBtn">&times;</span>
        <h2>Подтвердите удаление</h2>
        <p>Вы уверены, что хотите удалить свой аватар? Это действие нельзя отменить.</p>
        <div class="modal-buttons">
            <button id="confirmDeleteBtn" class="button-style">Удалить</button>
            <button id="cancelDeleteBtn" class="button-style">Отмена</button>
        </div>
    </div>
</div>

<div id="changeUsernameModal" class="modal">
    <div class="modal-content">
        <span class="close-button" id="closeChangeUsernameModalBtn">&times;</span>
        <h2>Сменить имя пользователя</h2>
        <form id="changeUsernameForm">
            <input type="text" id="newUsernameInput" name="username" placeholder="Введите новое имя" required
                   minlength="3" maxlength="20">
            <button type="submit" class="button-style">Сохранить</button>
        </form>
        <div id="changeUsernameStatusMessage" class="upload-status-message"></div>
    </div>
</div>

<div id="toastMessage" class="toast-message"></div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const changeAvatarBtn = document.getElementById('changeAvatarBtn');
        const deleteAvatarBtn = document.getElementById('deleteAvatarBtn');
        const uploadAvatarModal = document.getElementById('uploadAvatarModal');
        const closeUploadModalButton = uploadAvatarModal.querySelector('.close-button');
        const avatarUploadForm = document.getElementById('avatarUploadForm');
        const avatarFile = document.getElementById('avatarFile');
        const uploadStatusMessage = document.getElementById('uploadStatusMessage');

        const confirmationModal = document.getElementById('confirmationModal');
        const closeConfirmationModalBtn = document.getElementById('closeConfirmationModalBtn');
        const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
        const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

        const changeUsernameBtn = document.getElementById('changeUsernameBtn');
        const changeUsernameModal = document.getElementById('changeUsernameModal');
        const closeChangeUsernameModalBtn = document.getElementById('closeChangeUsernameModalBtn');
        const changeUsernameForm = document.getElementById('changeUsernameForm');
        const newUsernameInput = document.getElementById('newUsernameInput');
        const changeUsernameStatusMessage = document.getElementById('changeUsernameStatusMessage');

        const toastMessage = document.getElementById('toastMessage');

        function showToastMessage(message, type = 'success') {
            toastMessage.textContent = message;
            toastMessage.className = 'toast-message show ' + type;

            setTimeout(() => {
                toastMessage.classList.remove('show');
            }, 5000);
        }

        function openModal(modalElement) {
            console.log("Модальное окно " + modalElement.id + ": устанавливаем display: flex");
            modalElement.style.display = 'flex';
            console.log("Текущий display модального окна " + modalElement.id + " после установки: " + modalElement.style.display);
        }

        function closeModal(modalElement) {
            console.log("Модальное окно " + modalElement.id + ": устанавливаем display: none");
            modalElement.style.display = 'none';
        }

        if (changeAvatarBtn) {
            changeAvatarBtn.addEventListener('click', () => openModal(uploadAvatarModal));
        }
        if (closeUploadModalButton) {
            closeUploadModalButton.addEventListener('click', () => closeModal(uploadAvatarModal));
        }

        if (deleteAvatarBtn) {
            deleteAvatarBtn.addEventListener('click', () => openModal(confirmationModal));
        }
        if (closeConfirmationModalBtn) {
            closeConfirmationModalBtn.addEventListener('click', () => closeModal(confirmationModal));
        }
        if (cancelDeleteBtn) {
            cancelDeleteBtn.addEventListener('click', () => closeModal(confirmationModal));
        }

        if (changeUsernameBtn) {
            changeUsernameBtn.addEventListener('click', () => {
                console.log('Кнопка "Сменить имя" нажата. Открываем модальное окно.');
                newUsernameInput.value = '';
                changeUsernameStatusMessage.style.display = 'none';
                changeUsernameStatusMessage.textContent = '';
                openModal(changeUsernameModal);
            });
        }
        if (closeChangeUsernameModalBtn) {
            closeChangeUsernameModalBtn.addEventListener('click', () => closeModal(changeUsernameModal));
        }

        window.addEventListener('click', function (event) {
            if (event.target === uploadAvatarModal) {
                closeModal(uploadAvatarModal);
            }
            if (event.target === confirmationModal) {
                closeModal(confirmationModal);
            }
            if (event.target === changeUsernameModal) {
                closeModal(changeUsernameModal);
            }
        });

        if (avatarUploadForm) {
            avatarUploadForm.addEventListener('submit', function (event) {
                event.preventDefault();

                if (avatarFile.files.length === 0) {
                    uploadStatusMessage.textContent = 'Пожалуйста, выберите файл.';
                    uploadStatusMessage.className = 'upload-status-message error';
                    uploadStatusMessage.style.display = 'block';
                    return;
                }

                const file = avatarFile.files[0];
                const formData = new FormData();
                formData.append('avatar', file);

                uploadStatusMessage.textContent = 'Загрузка...';
                uploadStatusMessage.className = 'upload-status-message';
                uploadStatusMessage.style.display = 'block';

                fetch('/uploadAvatar', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => {
                        if (response.ok) {
                            uploadStatusMessage.textContent = 'Аватар успешно загружен!';
                            uploadStatusMessage.classList.add('success');
                            setTimeout(() => window.location.reload(), 1000);
                        } else {
                            return response.text().then(errorText => {
                                throw new Error(errorText || 'Неизвестная ошибка загрузки.');
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Ошибка загрузки аватара:', error);
                        uploadStatusMessage.textContent = 'Ошибка загрузки: ' + error.message;
                        uploadStatusMessage.classList.add('error');
                    })
                    .finally(() => {
                        uploadStatusMessage.style.display = 'block';
                    });
            });
        }

        if (confirmDeleteBtn) {
            confirmDeleteBtn.addEventListener('click', function () {
                closeModal(confirmationModal);

                fetch('/deleteAvatar', {
                    method: 'DELETE'
                })
                    .then(response => {
                        if (response.ok) {
                            showToastMessage('Аватар успешно удален!', 'success');
                            window.location.reload();
                        } else {
                            return response.text().then(errorText => {
                                showToastMessage('Ошибка при удалении аватара: ' + (errorText || 'Неизвестная ошибка.'), 'error');
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Ошибка сети при удалении аватара:', error);
                        showToastMessage('Произошла ошибка при попытке удалить аватар. Пожалуйста, попробуйте снова.', 'error');
                    });
            });
        }

        if (changeUsernameForm) {
            changeUsernameForm.addEventListener('submit', function (event) {
                event.preventDefault();

                const newUsername = newUsernameInput.value.trim();

                if (newUsername.length < 3 || newUsername.length > 20) {
                    changeUsernameStatusMessage.textContent = 'Имя пользователя должно быть от 3 до 20 символов.';
                    changeUsernameStatusMessage.className = 'upload-status-message error';
                    changeUsernameStatusMessage.style.display = 'block';
                    return;
                }

                changeUsernameStatusMessage.textContent = 'Сохранение...';
                changeUsernameStatusMessage.className = 'upload-status-message';
                changeUsernameStatusMessage.style.display = 'block';

                const params = new URLSearchParams();
                params.append('username', newUsername);

                fetch('/changeUsername', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params.toString()
                })
                    .then(response => {
                        if (response.ok) {
                            changeUsernameStatusMessage.textContent = 'Имя пользователя успешно изменено!';
                            changeUsernameStatusMessage.classList.add('success');
                            showToastMessage('Имя пользователя успешно изменено!', 'success');
                            setTimeout(() => window.location.reload(), 1000);
                        } else {
                            return response.text().then(errorText => {
                                throw new Error(errorText || 'Неизвестная ошибка при смене имени.');
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Ошибка смены имени пользователя:', error);
                        changeUsernameStatusMessage.textContent = 'Ошибка: ' + error.message;
                        changeUsernameStatusMessage.classList.add('error');
                        showToastMessage('Ошибка при смене имени: ' + error.message, 'error');
                    })
                    .finally(() => {
                        changeUsernameStatusMessage.style.display = 'block';
                    });
            });
        }
    });
</script>
</body>
</html>
