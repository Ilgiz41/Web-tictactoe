<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Крестики-Нолики Онлайн</title>

    <script src="/webjars/sockjs-client/sockjs.min.js"></script>
    <script src="/webjars/stomp-websocket/stomp.min.js"></script>

    <link rel="stylesheet" href="/css/main.css">
    <style>

        .board {
            display: grid;
            grid-template-columns: repeat(3, 100px);
            grid-template-rows: repeat(3, 100px);
            gap: 5px;
            margin: 20px auto;
            background-color: #eee;
            border: 5px solid #ccc;
            width: 315px;
            height: 315px;
        }

        .cell {
            width: 100px;
            height: 100px;
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3em;
            font-weight: bold;
            cursor: pointer;
            border: 1px solid #ddd;
            user-select: none;
            transition: background-color 0.2s ease;
        }

        .cell:hover {
            background-color: #f9f9f9;
        }

        .cell.occupied {
            cursor: not-allowed;
            background-color: #f0f0f0;
        }

        .cell.player-1 {
            color: #e74c3c;
        }

        .cell.player-2 {
            color: #3498db;
        }

        .status-message {
            margin-top: 20px;
            font-size: 1.2em;
            color: #555;
            min-height: 1.5em;
        }

        .error-message {
            color: #c0392b;
            font-weight: bold;
            margin-top: 10px;
            min-height: 1.5em;
        }

        .game-controls {
            margin-top: 20px;
        }

        .players-info {
            margin-top: 15px;
            font-size: 1em;
            color: #666;
        }
    </style>
</head>
<body>
<div class="main-panel p-8 md:p-12 max-w-lg">
    <h1 id="gameHeader">${gamePageHeader! "Крестики-Нолики Онлайн"}</h1>
    <div class="players-info">
        <p>Игрок 1: <span id="player1Name">Ожидание...</span></p>
        <p>Игрок 2: <span id="player2Name">Ожидание...</span></p>
    </div>
    <div class="board" id="gameBoard">
    </div>
    <div class="status-message" id="statusMessage"></div>
    <div class="error-message" id="errorMessage"></div>
    <div class="game-controls">
        <button id="mainMenuButton" class="button bg-blue-500 hover:bg-blue-600">На главную</button>
    </div>
</div>

<script>
    const gameId = "${gameId}";
    const playerId = "${playerId}";

    const initialGameDataDtoJson = '${initialGameDataDtoJson?no_esc}';
    let initialGameDataDto = null;

    try {
        if (initialGameDataDtoJson && initialGameDataDtoJson.trim() !== '') {
            initialGameDataDto = JSON.parse(initialGameDataDtoJson);
        }
    } catch (e) {
        console.error("Ошибка при парсинге initialGameDataDtoJson:", e);
        document.getElementById('errorMessage').textContent = "Ошибка при загрузке данных игры. Пожалуйста, попробуйте снова.";
    }

    let stompClient = null;
    let isConnected = false;

    const gameHeader = document.getElementById('gameHeader');
    const player1NameSpan = document.getElementById('player1Name');
    const player2NameSpan = document.getElementById('player2Name');
    const gameBoard = document.getElementById('gameBoard');
    const statusMessage = document.getElementById('statusMessage');
    const errorMessage = document.getElementById('errorMessage');
    const mainMenuButton = document.getElementById('mainMenuButton');

    function clearMessages() {
        statusMessage.textContent = '';
        errorMessage.textContent = '';
    }

    function showErrorMessage(message) {
        errorMessage.textContent = message;
        statusMessage.textContent = '';
    }

    function showStatusMessage(message) {
        statusMessage.textContent = message;
        errorMessage.textContent = '';
    }

    function renderGameUpdate(gameDto) {
        console.log("Рендеринг обновления игры:", gameDto);
        clearMessages();

        gameHeader.textContent = gameDto.header;

        player1NameSpan.textContent = gameDto.player1Name || 'Игрок 1';
        player2NameSpan.textContent = gameDto.player2Name || 'Игрок 2';

        gameBoard.innerHTML = '';
        gameDto.field.forEach((row, rowIndex) => {
            row.forEach((cellValue, colIndex) => {
                const cell = document.createElement('div');
                cell.classList.add('cell');
                cell.dataset.index = (rowIndex * gameDto.field[0].length) + colIndex;


                let symbol = '';
                if (cellValue === 1) {
                    symbol = 'X';
                    cell.classList.add('player-1');
                } else if (cellValue === -1) {
                    symbol = 'O';
                    cell.classList.add('player-2');
                }

                cell.textContent = symbol;

                if (cellValue !== 0) {
                    cell.classList.add('occupied');
                } else {
                    cell.addEventListener('click', onCellClick);
                }
                gameBoard.appendChild(cell);
            });
        });
    }

    function onCellClick(event) {
        if (!isConnected) {
            showErrorMessage("Нет соединения с сервером. Пожалуйста, обновите страницу.");
            return;
        }

        const cell = event.target;

        const index = parseInt(cell.dataset.index);

        const moveMessage = {
            gameId: gameId,
            playerId: playerId,
            index: index
        };

        stompClient.send("/app/onlineGame.makeMove", {}, JSON.stringify(moveMessage));
        console.log("Ход отправлен:", moveMessage);
        showStatusMessage("Отправка хода...");
    }

    function connect() {
        showStatusMessage("Подключение к игре...");
        const socket = new SockJS('/ws');
        stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            console.log('Подключено к WebSocket: ' + frame);
            isConnected = true
            stompClient.subscribe('/topic/' + gameId, function (updatePayload) {
                const gameDto = JSON.parse(updatePayload.body);
                console.log("Получено обновление GameDto:", gameDto);
                renderGameUpdate(gameDto);
            });

            stompClient.subscribe('/topic/' + gameId + '/error', function (errorPayload) {
                const errorMessageText = errorPayload.body;
                console.error("Ошибка с сервера:", errorMessageText);
                showErrorMessage("Ошибка: " + errorMessageText);
            });

            if (initialGameDataDto) {
                renderGameUpdate(initialGameDataDto);
                initialGameDataDto = null;
            }

        }, function (error) {
            console.error("Ошибка подключения STOMP:", error);
            showErrorMessage("Не удалось подключиться к серверу игры. Пожалуйста, обновите страницу.");
            isConnected = false;
            setTimeout(connect, 5000);
        });
    }

    document.addEventListener('DOMContentLoaded', connect);

    mainMenuButton.addEventListener('click', function () {
        if (stompClient !== null && isConnected) {
            stompClient.disconnect(function () {
                console.log("Отключено от WebSocket перед переходом на главную страницу.");
            });
        }
        window.location.href = '/';
    });

</script>
</body>
</html>
