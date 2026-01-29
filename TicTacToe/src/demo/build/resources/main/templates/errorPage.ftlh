<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ошибка</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        body {
            position: relative;
            min-height: 100vh;
            margin: 0;
            overflow-x: hidden;
        }

        .error-panel {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            text-align: center;
            max-width: 600px;
            margin: 50px auto;
        }

        .error-panel h1 {
            color: #d9534f;
        }

        .error-panel p {
            color: #555;
            margin-bottom: 20px;
        }

        .error-details {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
            font-size: 0.9em;
            color: #777;
        }

        .sliding-image {
            position: fixed;
            bottom: -400px;
            left: 50%;
            transform: translateX(-50%);
            width: 400px;
            height: auto;
            transition: bottom 1s ease-out;
            z-index: -1;
        }

        .sliding-image.show {
            bottom: 0;
        }
    </style>
</head>
<body>
<div class="error-panel">
    <h1>Произошла ошибка</h1>
    <p>К сожалению, не удалось загрузить страницу или обработать ваш запрос.</p>

    <div class="error-details">
        <p><strong>Тип:</strong> ${error!}</p>
        <p><strong>Статус:</strong> ${status!}</p>
        <p><strong>Сообщение:</strong> ${message!}</p>
    </div>

    <form action="/" method="get">
        <button type="submit">На главную</button>
    </form>
</div>

<img src="/static/images/okak.jpg" alt="Фоновая картинка" class="sliding-image" id="slidingImage">

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const image = document.getElementById('slidingImage');
        setTimeout(function () {
            image.classList.add('show');
        }, 500);
    });
</script>

</body>
</html>