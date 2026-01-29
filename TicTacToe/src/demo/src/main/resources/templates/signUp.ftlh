<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Регистрация пользователя</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <link rel="stylesheet" href="/static/css/default.css">
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

        .content1 {
            background-color: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 380px;
            /* Убрал фиксированную высоту height: 400px, чтобы кнопки не вылезали */
        }

        h1 {
            color: #333;
            margin-bottom: 25px;
        }

        form div {
            margin-bottom: 15px;
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }

        input[type="text"], input[type="password"] {
            width: 100%; /* Упростил для корректного отображения */
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1.1em;
            transition: background-color 0.3s ease;
            margin-top: 10px;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* Стиль для кнопки "Уже есть аккаунт?" */
        .signin-btn {
            background-color: transparent;
            color: #007bff;
            border: 1px solid #007bff;
            margin-top: 15px;
        }

        .signin-btn:hover {
            background-color: #f0f7ff;
        }

        .toast-error-message {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #dc3545;
            color: white;
            padding: 15px 25px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            opacity: 0;
            transition: opacity 0.5s ease-in-out;
            pointer-events: none;
            text-align: center;
            max-width: 300px;
        }

        .toast-error-message.show {
            opacity: 1;
            pointer-events: auto;
        }
    </style>
</head>
<body>
<div class="content1">
    <h1>Регистрация</h1>

    <form id="signUpForm">
        <div>
            <label for="login">Логин:</label>
            <input type="text" id="login" name="login" value="${(signUpRequest.login)!}" required>
        </div>
        <div>
            <label for="password">Пароль:</label>
            <input type="password" id="password" name="password" maxlength="50" required>
        </div>
        <button type="submit">Зарегистрироваться</button>
    </form>

    <button type="button" class="signin-btn" onclick="window.location.href='/signIn'">Уже есть аккаунт?</button>
</div>

<div id="toastErrorMessage" class="toast-error-message"></div>

<script>
    document.getElementById('signUpForm').addEventListener('submit', function (event) {
        event.preventDefault();

        const login = document.getElementById('login').value;
        const password = document.getElementById('password').value;
        const toastErrorMessageDiv = document.getElementById('toastErrorMessage');

        toastErrorMessageDiv.classList.remove('show');
        toastErrorMessageDiv.textContent = '';

        const signUpData = {
            login: login,
            password: password
        };

        fetch('/signUp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(signUpData)
        })
            .then(response => {
                if (response.ok) {
                    window.location.href = '/signIn'; // После регистрации лучше отправить на вход
                } else {
                    return response.text().then(errorMessage => {
                        toastErrorMessageDiv.textContent = errorMessage;
                        toastErrorMessageDiv.classList.add('show');
                        setTimeout(() => {
                            toastErrorMessageDiv.classList.remove('show');
                        }, 5000);
                    });
                }
            })
            .catch(error => {
                toastErrorMessageDiv.textContent = 'Ошибка сети или сервера. Пожалуйста, попробуйте еще раз.';
                toastErrorMessageDiv.classList.add('show');
                setTimeout(() => {
                    toastErrorMessageDiv.classList.remove('show');
                }, 5000);
            });
    });
</script>
</body>
</html>