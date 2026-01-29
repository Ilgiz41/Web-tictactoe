<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/css/main.css">
    <link rel="stylesheet" href="/static/css/default.css">
    <title>Профиль Игрока</title>
    <script src="https://cdn.tailwindcss.com"></script>
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

        .profile-game-card {
            background-color: #e4e6eb;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border: 1px solid #e0e6ed;
            transition: background-color 0.2s ease, transform 0.1s ease, box-shadow 0.2s ease;
        }

        .profile-game-card:hover {
            background-color: #f9fafb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .menu-container {
            position: absolute;
            top: 20px;
            right: 20px;
            z-index: 100;
        }

        .hamburger-icon {
            width: 30px;
            height: 25px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            cursor: pointer;
            padding: 5px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .hamburger-icon:hover {
            background-color: rgba(0, 0, 0, 0.05);
        }

        .hamburger-icon span {
            display: block;
            width: 100%;
            height: 3px;
            background-color: #333;
            border-radius: 2px;
        }

        .dropdown-menu {
            position: absolute;
            top: calc(100% + 10px);
            right: 0;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 10px 0;
            min-width: 180px;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .menu-container:hover .dropdown-menu {
            opacity: 1;
            visibility: visible;
        }

        .dropdown-menu a {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        .dropdown-menu a:hover {
            background-color: #f0f4f8;
            color: #457b9d;
        }
    </style>
</head>
<body>
<#if isLoggedIn?? && isLoggedIn>
    <div class="menu-container">
        <div class="hamburger-icon">
            <span></span>
            <span></span>
            <span></span>
        </div>
        <div class="dropdown-menu">
            <a href="/profileSettings">Настройки профиля</a>
        </div>
    </div>
</#if>

<div class="bg-white shadow-xl rounded-2xl p-8 max-w-xl w-full flex flex-col items-center space-y-8">
    <div class="flex flex-col items-center space-y-4">
        <img src="/avatars/${user.id!''}" alt="Аватар игрока"
             class="w-32 h-32 rounded-full border-4 border-blue-400 shadow-md object-cover"
             onerror="this.onerror=null;this.src='https://placehold.co/120x120/a8dadc/ffffff?text=Аватар';">
        <h1 class="text-4xl font-extrabold text-gray-800">${user.login! "Игрок_123"}</h1>
        <p class="text-lg text-gray-600">На сайте с: <span>${user.createDate! "15.03.2023"}</span></p>
    </div>

    <div class="w-full grid grid-cols-2 sm:grid-cols-4 gap-4 text-center">
        <div class="bg-green-100 p-4 rounded-xl shadow-sm">
            <p class="text-3xl font-bold text-green-700">${user.wins! 0}</p>
            <p class="text-sm text-green-600">Побед</p>
        </div>
        <div class="bg-red-100 p-4 rounded-xl shadow-sm">
            <p class="text-3xl font-bold text-red-700">${user.losses! 0}</p>
            <p class="text-sm text-red-600">Поражений</p>
        </div>
        <div class="bg-yellow-100 p-4 rounded-xl shadow-sm">
            <p class="text-3xl font-bold text-yellow-700">${user.draws! 0}</p>
            <p class="text-sm text-yellow-600">Ничьих</p>
        </div>
        <div class="bg-blue-100 p-4 rounded-xl shadow-sm">
            <p class="text-3xl font-bold text-blue-700">${(user.winRatio! 0)?string["0.##"]}%</p>
            <p class="text-sm text-blue-600">Процент побед</p>
        </div>
    </div>

    <div class="w-full">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-2xl font-bold text-gray-800 m-0">Последние игры</h2>
            <a href="/gameHistory/${user.id!''}"
               class="px-4 py-2 bg-blue-100 text-blue-700 font-semibold rounded-lg shadow-sm hover:bg-blue-200 transition duration-300 ease-in-out text-sm">
                Вся история игр
            </a>
        </div>

        <ul class="space-y-3">
            <#if games?has_content>
                <#list games as game>
                    <li class="profile-game-card p-4 flex justify-between items-center">
                        <div>
                            <p class="font-semibold text-gray-700 text-lg">vs. <span>${game.enemyName! "Бот"}</span></p>
                            <p class="text-sm text-gray-500">ID игры: <span>${game.gameId! "N/A"}</span></p>
                        </div>
                        <span class="font-bold text-lg
                        <#if game.gameStatus == 'WIN'>
                            text-green-600
                        <#elseif game.gameStatus == 'LOSE'>
                            text-red-600
                        <#elseif game.gameStatus == 'DRAW'>
                            text-yellow-600
                        <#else>
                            text-gray-600
                        </#if>
                        ">${game.gameStatus! "Неизвестно"}</span>
                    </li>
                </#list>
            <#else>
                <li class="profile-game-card p-4 flex justify-between items-center">
                    <div>
                        <p class="font-semibold text-gray-700">Нет последних игр</p>
                    </div>
                </li>
            </#if>
        </ul>
    </div>

    <button onclick="window.location.href='/'"
            class="mt-6 px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 transition duration-300 ease-in-out">
        На главную
    </button>
</div>
</body>
</html>
