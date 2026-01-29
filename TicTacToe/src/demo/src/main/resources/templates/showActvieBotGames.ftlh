<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Активные игры против Бота</title>

    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        .game-list-container {
            max-height: 450px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background-color: #f9f9f9;
            margin-top: 20px;
            position: relative;
        }

        .game-item {
            background-color: #e0f7fa;
            margin-bottom: 10px;
            padding: 15px 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .game-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .game-item:last-child {
            margin-bottom: 0;
        }

        .game-details {
            flex-grow: 1;
            text-align: left;
        }

        .game-details p {
            margin: 0;
            padding: 2px 0;
            font-size: 0.95em;
            color: #555;
        }

        .game-details .game-id {
            font-size: 0.8em;
            color: #888;
            word-break: break-all;
        }

        .game-actions {
            flex-shrink: 0;
            margin-left: 20px;
        }

        .info-message {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 1.1em;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 90%;
            box-sizing: border-box;
        }
    </style>
</head>
<body>
<div class="main-panel p-8 md:p-12 max-w-lg">
    <h1>Активные игры против Бота</h1>

    <div class="game-list-container" id="gameListContainer">
        <#if games?has_content>
            <#list games as game>
                <div class="game-item">
                    <div class="game-details">
                        <p>Дата создания: <strong>${game.creationDate!''}</strong></p>
                        <p class="game-id">ID: ${game.gameId!''}</p>
                    </div>
                    <div class="game-actions">
                        <a href="/game/${game.gameId!''}" class="button action-button bg-blue-500 hover:bg-blue-600">Продолжить</a>
                    </div>
                </div>
            </#list>
        <#else>
            <p class="info-message">Активных игр против бота не найдено.</p>
        </#if>
    </div>

    <div class="game-controls mt-8 flex flex-col md:flex-row justify-center space-y-4 md:space-y-0 md:space-x-4">
        <button id="startNewGameButton" class="button bg-green-500 hover:bg-green-600">Начать новую игру</button>
        <a href="/" class="button bg-gray-500 hover:bg-gray-600">На главное меню</a>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const startNewGameButton = document.getElementById('startNewGameButton');

        if (startNewGameButton) {
            startNewGameButton.addEventListener('click', function () {
                window.location.href = '/game';
            });
        } else {
            console.error("Кнопка 'Начать новую игру' не найдена.");
        }
    });
</script>
</body>
</html>
