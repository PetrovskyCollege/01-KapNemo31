-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Ноя 04 2023 г., 18:01
-- Версия сервера: 8.0.24
-- Версия PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `my_financial_app`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accounts`
--

CREATE TABLE `accounts` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL COMMENT 'ID пользователя, владельца счета',
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Имя счета',
  `balance` decimal(10,2) NOT NULL COMMENT 'Баланс',
  `currency` varchar(3) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Валюта счета',
  `icon` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Иконка счета',
  `background_color` varchar(7) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Фоновый цвет',
  `include_in_balance` tinyint(1) DEFAULT '1' COMMENT 'Учитывать в общем балансе'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL COMMENT 'ID пользователя, владельца категории',
  `category_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Название категории',
  `category_type` enum('income','expense') COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Тип категории (доход или расход)',
  `icon` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Иконка категории',
  `background_color` varchar(7) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Фоновый цвет'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `recurring_payments`
--

CREATE TABLE `recurring_payments` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL COMMENT 'ID пользователя, владельца регулярного платежа',
  `payment_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Название платежа',
  `payment_type` enum('income','expense') COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Тип платежа (доход или расход)',
  `amount` decimal(10,2) NOT NULL COMMENT 'Сумма платежа',
  `category_id` int DEFAULT NULL COMMENT 'ID категории платежа',
  `comment` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Комментарий к платежу',
  `next_payment_date` date NOT NULL COMMENT 'Дата следующего платежа',
  `automatic_payment` tinyint(1) DEFAULT '1' COMMENT 'Автоматический платеж',
  `payment_period` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Периодичность платежа',
  `payment_time` time DEFAULT NULL COMMENT 'Время платежа',
  `from_account_id` int DEFAULT NULL COMMENT 'ID счета, с которого производится платеж'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `transactions`
--

CREATE TABLE `transactions` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL COMMENT 'ID пользователя, владельца транзакции',
  `account_id` int DEFAULT NULL COMMENT 'ID счета, связанного с транзакцией',
  `transaction_type` enum('income','expense') COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Тип транзакции (доход или расход)',
  `amount` decimal(10,2) NOT NULL COMMENT 'Сумма транзакции',
  `category_id` int DEFAULT NULL COMMENT 'ID категории транзакции',
  `comment` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Комментарий к транзакции',
  `date` date NOT NULL COMMENT 'Дата транзакции'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `transfer_history`
--

CREATE TABLE `transfer_history` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL COMMENT 'ID пользователя, владельца истории переводов',
  `from_account_id` int DEFAULT NULL COMMENT 'ID счета, с которого произведен перевод',
  `to_account_id` int DEFAULT NULL COMMENT 'ID счета, на который произведен перевод',
  `amount` decimal(10,2) NOT NULL COMMENT 'Сумма перевода',
  `date` date NOT NULL COMMENT 'Дата перевода'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Имя пользователя',
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Почта пользователя',
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Пароль'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `recurring_payments`
--
ALTER TABLE `recurring_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `from_account_id` (`from_account_id`);

--
-- Индексы таблицы `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Индексы таблицы `transfer_history`
--
ALTER TABLE `transfer_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `from_account_id` (`from_account_id`),
  ADD KEY `to_account_id` (`to_account_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `recurring_payments`
--
ALTER TABLE `recurring_payments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `transfer_history`
--
ALTER TABLE `transfer_history`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `recurring_payments`
--
ALTER TABLE `recurring_payments`
  ADD CONSTRAINT `recurring_payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `recurring_payments_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `recurring_payments_ibfk_3` FOREIGN KEY (`from_account_id`) REFERENCES `accounts` (`id`);

--
-- Ограничения внешнего ключа таблицы `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`),
  ADD CONSTRAINT `transactions_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Ограничения внешнего ключа таблицы `transfer_history`
--
ALTER TABLE `transfer_history`
  ADD CONSTRAINT `transfer_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `transfer_history_ibfk_2` FOREIGN KEY (`from_account_id`) REFERENCES `accounts` (`id`),
  ADD CONSTRAINT `transfer_history_ibfk_3` FOREIGN KEY (`to_account_id`) REFERENCES `accounts` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
