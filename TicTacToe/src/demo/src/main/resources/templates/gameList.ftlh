<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>История игр с ботом</title>
    <style>

        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            color: #333;
            background: linear-gradient(to bottom, #57D7E6, #7CED61);
            background-attachment: fixed;

            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        button, .button {
            display: inline-block;
            background-color: #5cb85c;
            color: white;
            padding: 12px 25px;
            font-size: 1.1em;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.1s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        button:hover, .button:hover {
            background-color: #4cae4c;
            transform: scale(1.05);
        }

        button:active, .button:active {
            background-color: #449d44;
            transform: scale(0.95);
        }

        button:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
            opacity: 0.7;
            transform: scale(1);
        }

        .container {
            width: 800px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.4);
            z-index: 1;
            position: relative;
        }

        h1 {
            color: #0056b3;
            text-align: center;
            margin-bottom: 20px;
            font-size: 2.2em;
        }

        .filter-controls {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .filter-group label {
            font-weight: bold;
            margin-bottom: 5px;
            color: #555;
        }

        .filter-group select {
            margin-right: 5px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .game-list-container {
            height: 400px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
            background-color: #f9f9f9;
            position: relative;
        }

        .game-item-button {
            display: block;
            background-color: #e9e9e9;
            margin-bottom: 8px;
            padding: 10px 15px;
            border-radius: 5px;
            border-left: 5px solid #007bff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            text-decoration: none;
            color: #333;
            transition: background-color 0.2s ease;
        }

        .game-item-button:hover {
            background-color: #dcdcdc;
            cursor: pointer;
        }

        .game-item-button:last-child {
            margin-bottom: 0;
        }

        .game-details {
            flex-grow: 1;
        }

        .game-id {
            font-weight: bold;
            color: #333;
            word-break: break-all;
        }

        .game-player {
            font-size: 0.9em;
            color: #777;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 0.8em;
            font-weight: bold;
            color: #fff;
            text-transform: uppercase;
        }

        .status-badge.active {
            background-color: #ffc107;
        }

        .status-badge.completed {
            background-color: #28a745;
        }

        .status-badge.win {
            background-color: #28a745;
        }

        .status-badge.lose {
            background-color: #dc3545;
        }

        .status-badge.draw {
            background-color: #6c757d;
        }

        .status-badge.unknown {
            background-color: #6a6a6a;
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
            width: 100%;
            box-sizing: border-box;
        }

        .error-box {
            position: fixed;
            bottom: 20px;
            left: 20px;
            background-color: #dc3545;
            color: white;
            padding: 15px 20px;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            max-width: 300px;
            word-wrap: break-word;
        }

        .navigation-buttons {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>История игр с ботом</h1>

    <div class="filter-controls">
        <div class="filter-group">
            <label for="gameStatusFilter">Статус:</label>
            <select id="gameStatusFilter" name="gameStatus">
                <option value="ALL" <#if selectedGameStatus?? && selectedGameStatus == "ALL">selected</#if>>Все</option>
                <option value="ACTIVE" <#if selectedGameStatus?? && selectedGameStatus == "ACTIVE">selected</#if>>
                    Активные
                </option>
                <option value="COMPLETED" <#if selectedGameStatus?? && selectedGameStatus == "COMPLETED">selected</#if>>
                    Завершенные
                </option>
            </select>
        </div>
    </div>

    <div class="game-list-container">
        <#if games?has_content>
            <#list games as game>
                <a href="/game/${game.id!''}" class="game-item-button">
                    <div class="game-details">
                        <div class="game-id">ID игры: <span style="color: purple;">Игра_</span>${game.id!''}</div>
                        <div class="game-player">Против компьютера</div>
                    </div>

                    <span class="status-badge
                        <#assign statusLower = (game.gameState!object)?lower_case>
                        <#if statusLower == "win">win
                        <#elseif statusLower == "lose">lose
                        <#elseif statusLower == "draw">draw
                        <#elseif statusLower == "active">active
                        <#elseif statusLower == "completed">completed
                        <#else>unknown
                        </#if>
                    ">
                        ${game.gameState!''}
                    </span>
                </a>
            </#list>
        <#else>
            <p class="info-message">Игры не найдены.</p>
        </#if>
    </div>

    <div class="navigation-buttons">
        <a href="/" class="button">На главную</a>
    </div>

</div>

<#if errorMessage?? && errorMessage?has_content>
    <div class="error-box">
        ${errorMessage}
    </div>
</#if>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const gameStatusFilter = document.getElementById('gameStatusFilter');

        if (!gameStatusFilter) {
            console.error("Элемент 'gameStatusFilter' не найден.");
            return;
        }

        function applyFilters() {
            let url = '/games';
            url += `?gameStatus=` + encodeURIComponent(gameStatusFilter.value);
            window.location.href = url;
        }

        gameStatusFilter.addEventListener('change', applyFilters);
    });
</script>

</body>
</html>