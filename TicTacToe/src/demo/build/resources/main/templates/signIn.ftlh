<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/css/main.css">
    <link rel="stylesheet" href="/static/css/default.css">
    <title>Вход</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f4f4f4;
            margin: 0;
        }

        .login-container {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            text-align: center;
        }

        .login-container h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }

        .form-group input[type="text"], .form-group input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-bottom: 10px; /* Добавил отступ снизу */
        }

        button:hover {
            background-color: #0056b3;
        }

        /* Стиль для кнопки регистрации */
        .signup-btn {
            background-color: transparent;
            color: #007bff;
            border: 1px solid #007bff;
            margin-top: 10px;
        }

        .signup-btn:hover {
            background-color: #f0f7ff;
        }

        .error-message {
            color: red;
            margin-top: 15px;
            display: none;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Вход</h2>
    <div id="error-message" class="error-message"></div>
    <form id="loginForm">
        <div class="form-group">
            <label for="login">Логин:</label>
            <input type="text" id="login" name="login" required>
        </div>
        <div class="form-group">
            <label for="password">Пароль:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit">Войти</button>
    </form>

    <button type="button" class="signup-btn" onclick="window.location.href='/signUp'">Нет аккаунта?</button>
</div>

<script>
    document.getElementById('loginForm').addEventListener('submit', async function (event) {
        event.preventDefault();

        const login = document.getElementById('login').value;
        const password = document.getElementById('password').value;
        const errorMessageDiv = document.getElementById('error-message');

        errorMessageDiv.style.display = 'none';
        errorMessageDiv.textContent = '';

        const jwtRequest = {
            login: login,
            password: password
        };

        try {
            const response = await fetch('/signIn', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(jwtRequest)
            });

            if (response.ok) {
                const successMessage = await response.text();
                console.log('Авторизация успешна:', successMessage);
                window.location.href = '/';
            } else {
                const errorText = await response.text();
                errorMessageDiv.textContent = errorText || 'Неизвестная ошибка авторизации.';
                errorMessageDiv.style.display = 'block';
                console.error('Ошибка авторизации:', response.status, errorText);
            }
        } catch (error) {
            console.error('Ошибка сети или сервера:', error);
            errorMessageDiv.textContent = 'Ошибка подключения к серверу. Попробуйте позже.';
            errorMessageDiv.style.display = 'block';
        }
    });
</script>
</body>
</html>