<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/css/main.css">
    <title>Онлайн-игры</title>
    <script src="https://cdn.tailwindcss.com"></script>
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

        .online-games-panel {
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
            width: 300px;
            height: 4px;
            background: linear-gradient(90deg, #6dd5ed, #2193b0);
            border-radius: 2px;
        }

        .filter-controls {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
            width: 100%;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-group label {
            font-weight: bold;
            color: #555;
            font-size: 1em;
        }

        .filter-group select {
            padding: 10px 30px 10px 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background-color: #fff;
            font-size: 1em;
            color: #333;
            appearance: none;
            background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23007bff%22%20d%3D%22M287%2C114.7L154.7%2C28.4c-11.9-11.9-31.1-11.9-43.1%2C0l-132.3%2C126.3c-11.9%2C11.9-11.9%2C31.1%2C0%2C43.1l21.5%2C21.5c11.9%2C11.9%2C31.1%2C11.9%2C43.1%2C0l90.7-90.7l90.7%2C90.7c11.9%2C11.9%2C31.1%2C11.9%2C43.1%2C0l21.5-21.5C298.9%2C145.8%2C298.9%2C126.6%2C287%2C114.7z%22%2F%3E%3C%2Fsvg%3E');
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 12px auto;
            cursor: pointer;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .filter-group select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
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
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .game-card:last-child {
            margin-bottom: 0;
        }

        .game-card:hover {
            background-color: #f9fafb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
            animation-name: animatetop;
            animation-duration: 0.4s;
            text-align: center;
            border-radius: 8px;
        }

        .close-button {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close-button:hover,
        .close-button:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        .symbol-selection {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }

        .symbol-option {
            cursor: pointer;
            padding: 15px;
            border: 2px solid #ccc;
            border-radius: 8px;
            font-size: 3em;
            font-weight: bold;
            color: #333;
            transition: all 0.3s ease;
            width: 100px;
            height: 100px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .symbol-option:hover {
            border-color: #5cb85c;
            box-shadow: 0 0 10px rgba(92, 184, 92, 0.5);
        }

        .symbol-option.selected {
            background-color: #5cb85c;
            color: white;
            border-color: #4cae4c;
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
    </style>
</head>
<body>
<div class="online-games-panel">
    <h1>Онлайн-игры</h1>

    <div class="filter-controls">
        <div class="filter-group">
            <label for="gameStatusFilter">Показать:</label>
            <select id="gameStatusFilter" name="gameStatus">
                <option value="ACTIVE" <#if selectedGameStatus?? && selectedGameStatus == "ACTIVE">selected</#if>>
                    Активные
                </option>
                <option value="WAITING_PLAYER"
                        <#if selectedGameStatus?? && selectedGameStatus == "WAITING_PLAYER">selected</#if>>Ожидают
                    игрока
                </option>
            </select>
        </div>
    </div>

    <div class="game-list-scrollable">
        <#if games?has_content>
            <#list games as game>
                <div class="game-card">
                    <div class="game-card-details">
                        <div class="game-card-players">
                            <#if game.gameStatus?? && game.gameStatus?lower_case == "waiting_player">
                                <strong>${game.playerName!''}</strong> (Ожидает второго игрока)
                            <#else>
                                <strong>${game.playerName!''}</strong> vs <strong>${game.enemyName!''}</strong>
                            </#if>
                        </div>
                        <div class="game-card-id">ID: ${game.gameId!''}</div>
                    </div>
                    <div class="game-card-actions">
                        <#if game.gameStatus?? && game.gameStatus?lower_case == "waiting_player">
                            <form action="/joinGame/${game.gameId!''}" method="post">
                                <button type="submit" class="game-card-button">Присоединиться к игре</button>
                            </form>
                        <#else>
                            <a href="/onlineGame/${game.gameId!''}" class="game-card-button">Посмотреть игру</a>
                        </#if>
                    </div>
                </div>
            </#list>
        <#else>
            <p class="info-message">Онлайн-игры не найдены.</p>
        </#if>
    </div>

    <div class="navigation-buttons mt-6">
        <button id="openOnlineGameSymbolModalBtn" class="button-style bg-green-600 hover:bg-green-700">Начать новую
            игру
        </button>
        <a href="/" class="button-style bg-blue-600 hover:bg-blue-700">На главную</a>
    </div>

</div>

<div id="onlineGameSymbolModal" class="modal">
    <div class="modal-content">
        <span class="close-button">&times;</span>
        <h2>Выберите ваш символ:</h2>
        <div class="symbol-selection">
            <div class="symbol-option" data-symbol="1">X</div>
            <div class="symbol-option" data-symbol="-1">O</div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const gameStatusFilter = document.getElementById('gameStatusFilter');
        const onlineGameSymbolModal = document.getElementById('onlineGameSymbolModal');
        const openOnlineGameSymbolModalBtn = document.getElementById('openOnlineGameSymbolModalBtn');
        const closeButtons = onlineGameSymbolModal.querySelectorAll('.close-button');
        const symbolOptions = onlineGameSymbolModal.querySelectorAll('.symbol-option');

        if (gameStatusFilter) {
            gameStatusFilter.addEventListener('change', function () {
                const selectedStatus = this.value;
                window.location.href = '/onlineGames/' + selectedStatus;
            });
        }

        function openModal(modalElement) {
            modalElement.style.display = 'flex';
        }

        function closeModal(modalElement) {
            modalElement.style.display = 'none';
            modalElement.querySelectorAll('.symbol-option').forEach(option => option.classList.remove('selected'));
        }

        if (openOnlineGameSymbolModalBtn) {
            openOnlineGameSymbolModalBtn.addEventListener('click', function () {
                openModal(onlineGameSymbolModal);
            });
        }

        closeButtons.forEach(button => {
            button.addEventListener('click', function () {
                closeModal(onlineGameSymbolModal);
            });
        });

        window.addEventListener('click', function (event) {
            if (event.target === onlineGameSymbolModal) {
                closeModal(onlineGameSymbolModal);
            }
        });

        symbolOptions.forEach(option => {
            option.addEventListener('click', function () {
                symbolOptions.forEach(opt => opt.classList.remove('selected'));
                this.classList.add('selected');

                const playerSymbol = this.dataset.symbol;

                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/onlineGame';

                const hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = 'playerSymbol';
                hiddenInput.value = playerSymbol;
                form.appendChild(hiddenInput);

                document.body.appendChild(form);
                form.submit();
            });
        });
    });
</script>

</body>
</html>
