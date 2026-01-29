<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/css/main.css">
    <link rel="stylesheet" href="/static/css/default.css">
    <title>Таблица Лидеров</title>
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
        }

        .player-card {
            background-color: #e4e6eb;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 16px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: #2c3e50;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: 1px solid #d0d6dd;
        }

        .player-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }

        .player-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: #a8dadc;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #2c3e50;
            font-weight: bold;
            font-size: 1.5rem;
            overflow: hidden;
        }

        .player-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .player-link {
            color: #3b82f6;
            text-decoration: none;
            transition: color 0.2s ease-in-out;
        }

        .player-link:hover {
            color: #2563eb;
            text-decoration: underline;
        }

    </style>
</head>
<body>
<div class="bg-white shadow-xl rounded-2xl p-8 max-w-xl w-full flex flex-col items-center space-y-8">

    <div class="flex flex-col items-center space-y-4">
        <h1 class="text-5xl font-extrabold text-gray-900">Таблица Лидеров</h1>
        <p class="text-xl text-gray-600">Топ-игроки по проценту побед</p>
    </div>

    <div class="w-full flex flex-col space-y-4">
        <#if leaderboard?has_content>
            <#list leaderboard as player>
                <div class="player-card">

                    <div class="w-10 text-center font-bold text-2xl text-gray-700">
                        ${player.rank!0}.
                    </div>

                    <div class="flex items-center space-x-4 flex-grow ml-4">

                        <div class="player-avatar">
                            <img src="/avatars/${player.userId!''}"
                                 alt="Аватар игрока ${player.login!''}"
                                 onerror="this.onerror=null;this.src='https://placehold.co/40x40/a8dadc/2c3e50?text=Аватар';"
                                 class="w-full h-full object-cover rounded-full">
                        </div>

                        <a href="/profile/${player.userId!}" class="player-link text-xl font-semibold">
                            ${player.login!}
                        </a>
                    </div>

                    <div class="flex flex-col items-end">
                        <div class="text-xl font-bold text-blue-600">
                            ${(player.winRatio! 0)?string["0.##"]}%
                        </div>
                        <div class="text-sm text-gray-500">
                            Винрейт
                        </div>
                    </div>
                </div>
            </#list>
        <#else>

            <div class="bg-gray-100 p-4 rounded-xl shadow-sm text-center text-gray-500">
                Пока нет данных в таблице лидеров.
            </div>
        </#if>
    </div>


    <button onclick="window.location.href='/'"
            class="mt-8 px-8 py-4 bg-blue-600 text-white font-semibold text-lg rounded-xl shadow-md hover:bg-blue-700 transition duration-300 ease-in-out">
        На главную
    </button>
</div>
</body>
</html>
