<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Добро пожаловать!</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>

        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            color: #333;
            background: linear-gradient(135deg, #a8dadc 0%, #457b9d 100%);
            background-attachment: fixed;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            box-sizing: border-box;
        }

        button, .button {
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
            width: 100%;
        }

        button:hover, .button:hover {
            background-color: #4cae4c;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.25);
        }

        button:active, .button:active {
            background-color: #449d44;
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }

        button:disabled, .button:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
            opacity: 0.7;
            transform: translateY(0);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .main-panel {
            background-color: #f8faff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            padding: 30px 40px;
            max-width: 500px;
            width: 100%;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 2.0em !important;
            position: relative;
            padding-bottom: 10px;
        }

        h1::after {
            content: '';
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
            width: 100px;
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

<div class="main-panel p-8 md:p-12 max-w-md space-y-8">

    <div class="mb-4">
        <img src="https://placehold.co/100x100/457b9d/ffffff?text=XOX" alt="Логотип Крестики-Нолики"
             class="w-24 h-24 rounded-full border-4 border-blue-300 shadow-lg">
    </div>

    <h1>
        Добро пожаловать, ${username}!
    </h1>

    <div class="w-full flex flex-col space-y-4">
        <button id="openBotGameSymbolModalBtn" class="button bg-green-500 hover:bg-green-600">Играть против бота
        </button>
        <a href="/onlineGames/WAITING_PLAYER" class="button bg-blue-500 hover:bg-blue-600">Играть онлайн</a>
        <a href="/leaderboard" class="button bg-purple-600 hover:bg-purple-700">Таблица лидеров</a>
        <a href="/profile" class="button bg-yellow-500 hover:bg-yellow-600 text-gray-800">Мой Профиль</a>
    </div>

</div>

<div id="botGameSymbolModal" class="modal">
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
        const botGameSymbolModal = document.getElementById('botGameSymbolModal');
        const openBotGameSymbolModalBtn = document.getElementById('openBotGameSymbolModalBtn');
        const closeButtons = botGameSymbolModal.querySelectorAll('.close-button');
        const symbolOptions = botGameSymbolModal.querySelectorAll('.symbol-option');

        function openModal(modalElement) {
            modalElement.style.display = 'flex';
        }

        function closeModal(modalElement) {
            modalElement.style.display = 'none';
            modalElement.querySelectorAll('.symbol-option').forEach(option => option.classList.remove('selected'));
        }

        if (openBotGameSymbolModalBtn) {
            openBotGameSymbolModalBtn.addEventListener('click', function () {
                openModal(botGameSymbolModal);
            });
        }

        closeButtons.forEach(button => {
            button.addEventListener('click', function () {
                closeModal(botGameSymbolModal);
            });
        });

        window.addEventListener('click', function (event) {
            if (event.target === botGameSymbolModal) {
                closeModal(botGameSymbolModal);
            }
        });

        symbolOptions.forEach(option => {
            option.addEventListener('click', function () {
                symbolOptions.forEach(opt => opt.classList.remove('selected'));
                this.classList.add('selected');

                const playerSymbol = this.dataset.symbol;
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/game';

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
