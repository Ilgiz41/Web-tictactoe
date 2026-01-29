<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>История онлайн-игр</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="/static/css/main.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            color: #333;
            background-color: #f0f4f8;
            background-attachment: fixed;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            box-sizing: border-box;
        }

        button, .button-style {
            display: inline-block;
            background-color: #5cb85c;
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
            background-color: #4cae4c;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.25);
        }

        button:active, .button-style:active {
            background-color: #449d44;
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }

        button:disabled, .button-style:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
            opacity: 0.7;
            transform: translateY(0);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .history-main-panel {
            background-color: #f8faff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            padding: 30px 40px;
            max-width: 800px;
            width: 100%;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            box-sizing: border-box;
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 2em !important;
            position: relative;
            padding-bottom: 10px;
        }

        h1::after {
            content: '';
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
            width: 450px;
            height: 4px;
            background: linear-gradient(90deg, #6dd5ed, #2193b0);
            border-radius: 2px;
        }

        h2 {
            color: #34495e;
            font-weight: 600;
            font-size: 1.8em;
            margin-bottom: 15px;
        }

        .game-list-scrollable {
            height: 450px;
            overflow-y: auto;
            width: 100%;
            padding-right: 10px;
            box-sizing: border-box;
            border: 1px solid #e0e6ed;
            border-radius: 12px;
            background-color: #ffffff;
            box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.05);
        }

        .game-card {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 16px 20px;
            display: flex;
            flex-direction: column;
            align-items: stretch;
            color: #333;
            transition: background-color 0.2s ease, transform 0.1s ease;
            margin-bottom: 8px;
        }

        .game-card:last-child {
            margin-bottom: 0;
        }

        .game-card:hover {
            background-color: #f9fafb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .game-card-header {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 10px;
            position: relative;
            flex-wrap: wrap;
        }

        .game-card-details {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            flex-grow: 1;
            padding: 0;
            margin: 0;
            min-width: 0;
        }

        .game-card-players {
            font-family: 'Inter', sans-serif;
            font-size: 1.3em;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
            width: 100%;
            white-space: normal;
            word-break: break-word;
        }

        .game-card-id {
            font-size: 0.9em;
            color: #777;
            word-break: break-all;
            width: 100%;
            white-space: normal;
        }

        .game-card-status-wrapper {
            position: absolute;
            right: 20px;
            top: 16px;
            flex-shrink: 0;
        }

        .game-card-status {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.9em;
            font-weight: bold;
            color: #fff;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .game-card-status.win {
            background-color: #28a745;
        }

        .game-card-status.lose {
            background-color: #dc3545;
        }

        .game-card-status.draw {
            background-color: #ffc107;
        }

        .game-card-status.active {
            background-color: #007bff;
        }

        .game-card-status.completed {
            background-color: #6c757d;
        }

        .game-card-status.unknown {
            background-color: #6a6a6a;
        }


        .game-card-actions {
            display: flex;
            justify-content: center;
            width: 100%;
            margin-top: 10px;
        }

        .game-card-button {
            background-color: #457b9d;
            color: white;
            padding: 10px 20px;
            font-size: 1em;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.2s ease, transform 0.1s ease;
            border: none;
            min-width: 180px;
            text-align: center;
            text-decoration: none;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .game-card-button:hover {
            background-color: #3b6a8a;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .game-card-button:active {
            transform: translateY(0);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .info-message {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 1.1em;
        }

    </style>
</head>
<body>
<div class="history-main-panel">
    <h1>История онлайн-игр</h1>

    <div class="game-list-scrollable">
        <#if games?has_content>
            <#list games as game>
                <div class="game-card">
                    <div class="game-card-header">
                        <div class="game-card-details">
                            <div class="game-card-players">
                                <#if game.playerName?has_content>
                                    <strong>${game.playerName!''}</strong>
                                <#else>
                                    <strong>Неизвестен</strong>
                                </#if>
                                <#if game.enemyName?has_content>
                                    vs <strong>${game.enemyName!''}</strong>
                                <#else>
                                    (Ожидает игрока)
                                </#if>
                            </div>
                            <div class="game-card-id">ID: ${game.gameId!''}</div>
                        </div>
                        <div class="game-card-status-wrapper">
                            <span class="game-card-status
                                <#if game.gameStatus??>
                                    <#assign statusLower = game.gameStatus?lower_case>
                                    <#if statusLower == "win">win
                                    <#elseif statusLower == "lose">lose
                                    <#elseif statusLower == "draw">draw
                                    <#elseif statusLower == "active">active
                                    <#elseif statusLower == "completed">completed
                                    <#elseif statusLower == "waiting_player">active
                                    <#else>unknown
                                    </#if>
                                <#else>unknown
                                </#if>
                            ">
                                ${game.gameStatus!''}
                            </span>
                        </div>
                    </div>
                    <div class="game-card-actions">
                        <#if game.gameStatus?? && game.gameStatus?lower_case == "waiting_player">
                            <form action="/joinGame/${game.gameId!''}" method="post">
                                <button type="submit" class="game-card-button">Присоединиться к игре</button>
                            </form>
                        <#else>
                            <#if showViewButton?? && showViewButton>
                                <a href="/onlineGame/${game.gameId!''}" class="game-card-button">Посмотреть игру</a>
                            </#if>
                        </#if>
                    </div>
                </div>
            </#list>
        <#else>
            <p class="info-message">Онлайн-игры не найдены.</p>
        </#if>
    </div>

    <div class="navigation-buttons mt-6">
        <a href="/" class="button-style bg-blue-600 hover:bg-blue-700">На главную</a>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
    });
</script>

</body>
</html>
