# Flashspeak
![Scene 3](https://github.com/DenDmitriev/flashspeak/assets/65191747/529b2651-ea3e-494c-b75b-bd0b406b1904)

Приложение iOS для изучения иностранных слов по наборам карточек.

## Содержание
<img src="FlashSpeak/FlashSpeak/Resources/Assets.xcassets/AppIcon.appiconset/256.png" width="128">

- [Обзор](#обзор)
    - [Возможности](#возможности)
       - [Выбор языка изучения](#выбор-языка)
       - [Списки слов](#списки-слов)
       - [Создание и редактирование списка слов](#создание-и-редактирование-списка-слов)
       - [Просмотр карточек](#просмотр-карточек)
       - [Редактирование карточки](#редактирование-карточки)
       - [Изучение](#изучение)
       - [Результаты изучения](#результаты-изучения)
       - [Темное оформление](#темное-оформление)
    - [Реализация](#реализация)
       - [API](#api)
            - [Перевод](#перевод)
            - [Изображения](#изображения)
       - [Архитектура](#архитектура)
       - [Паттерны](#паттерны)
       - [Библиотеки](#библиотеки)
       - [Хранение данных](#хранение-данных)
       - [Требования](#требования)
- [Как запустить](#как-запустить)
- [Зачем](#зачем)
- [To Do](#to-do)
- [Команда проекта](#команда-проекта)

## Обзор
| Создание списка  | Обучение | Список слов |
| ------------- | ------------- | ------------- |
| <video src="https://github.com/DenDmitriev/flashspeak/assets/65191747/efeb137d-c043-40f1-9192-1f23243f47b6.mov"> | <video src="https://github.com/DenDmitriev/flashspeak/assets/65191747/edf95854-0c09-4b87-b0d8-26b46ed25e66.mov">  |  <video src="https://github.com/DenDmitriev/flashspeak/assets/65191747/3a6dfa14-b895-4584-956b-bb61bb44b773.mov"> |

### Возможности
Пользователь, [выбрав язык изучения](#выбор-языка), может легко [создать свой список слов](#создание-и-редактирование-списка-слов) для изучения. Слова можно добавить через вставку или вводя по отдельности. Приложение [сформирует перевод](#перевод) и [найдет подходящие изображения](#изображения) для каждого слова. Пользователь [на главноем экране](#списки-слов) увидит новый список. По нажатию на него, можно [просмотреть получившиеся карточки](#просмотр-карточек), а если перевод и подобранное изображение не подойдут то [можно загрузить свое изображение или изменить перевод слова](#редактирование-карточки). [Изучение можно проходить по различным сценариям](#изучение). Карточку для изучения можно сделать из частей: исходное слово, перевод и изображение. Отвечать на предложенную карточку можно через тестирование или набирая ответ на клавиатуре. Для понимания звучания, есть кнопка произнести слово вслух. Результаты прохождения каждого изучения списка сохранаются и [формируются в статистику](#результаты-изучения), так же пользователю будут показаны ошибки для работы над ними.

#### Выбор языка
При первом открытии приложения, пользователь видит экран приветствия. Приложение просит выбрать родной язык и изучаемый. По кнопке "Начать" сценарий первого старта заканчивается и открывается основной [экран со списками](#списки-слов) слов[^1].
![Welcome](https://github.com/DenDmitriev/flashspeak/assets/65191747/c993d374-821f-4ee5-92db-a8e60ca4ef43)


#### Списки слов
Это главный экран, который пользователь будет видеть при последующих запусках приложения. Изначально экран пустой. Чтобы показать пользователю что делать дальше, показывается стрелочка, которая указывает на кнопку создания списка "+". После создания списка, пользователь может его увидеть на главном экране. При длительном нажатии на ячейку списка или по кнопке в верхнем правом углу, открывается меню для управления списком слов[^1]. Если пользователь решит изучать другой язык, то он может сменить его по кнопке с изображением флага в верхнем правом углу экрана[^3].
![List](https://github.com/DenDmitriev/flashspeak/assets/65191747/01fb9865-9cd1-46bf-99ba-26682f1b8d33)

#### Создание и редактирование списка слов
Создание списка начинается по кнопке "+" на главном экране списоков. По нажатию, открыватся модальное окно с полями для названия, выбора цвета для ориентации и переключателем изображний для слов. По нажатию на "Создать список", пользователь попадает на экран набора слов. Экран позволяет создавать и редактировать слова, на нем есть всего три элемента: поле для ввода, кнопка создания и кнопка помощи. Слова можно вводить набирая с клавиатуры, а также вставлять уже готовый список слов, которые отделены символом запятой или переходом строки. Чтобы сориентировать пользователя, есть кнопка с вопросом, которая открывает окно с описанием возможностей. У списка есть минимальные требования колличества слов, подсказки с этой информацией отображается на кнопке в процессе набора слов. Для добавления в список слова, можно использовать кнопку Enter, запятую или кнопку +, которая появляется справа от поля в момент начала ввода слова. Чтобы удалить или исправить уже введенное слово необходимо удерживать его пару секунд, активируются поле удаления и редактирования. Пользователю необходимо перенести слово в нужное поле. Если пользователь не нажмет на кнопку создать карточки и захочет вернуться на предыдущий экран, то приложение предложит два варианта: выйти без сохранения или вернуться, чтобы не потерять созданный список[^1][^3].
![ListMaker](https://github.com/DenDmitriev/flashspeak/assets/65191747/f62e3e5b-0147-42f8-8e26-987ce122bd53)


#### Просмотр карточек
После создания списка слов, открывается экран с карточками. На нем можно просматривать карточки вместе с картинками, есть возможность [редактировать](#редактирование-карточки) или удалять. Отредактировать весь список слов можно по кругой кнопке справа внизу. На экран можно попасть по меню с главного экрана и в обзорном экране перед изучением[^2].
![WordCards](https://github.com/DenDmitriev/flashspeak/assets/65191747/51f2b436-5741-4939-b77f-a0cddcbc93a7)

#### Редактирование карточки
Экран выполняет функцию редактирования карточки. Если сервис подобрал не верный перевод, то его можно изменить. А если не подходящее изображение, то сервис в карусели предлагает на выбор другие фотографии. Пролистав и выбрав нужное изображение в карусели, над карточкой меняется заглавный баннер. Последняя ячейка карусели является кнопкой, которая дает возможность загрузить свое изображение из галереи устройства. По нажатию на кнопку сохранить, карточка обновляется[^1].
![Card](https://github.com/DenDmitriev/flashspeak/assets/65191747/5da47334-b853-4562-a285-4b58a3723c8e)

#### Изучение
Перед запуском изучения, пользовтелю предлагается выбрать индивидуальные настройки карточки слова и функции редактирования списока. По нажатию на кнопку настроек, открывается меню, где можно выбрать отображение вопроса и способ ответа. Экран создается по паттерну Strategy. За сохранение ответов пользователя отвечает Caretaker, который потом дает данные для [экрана статистики](#результаты-изучения) и работы над ошибками[^1].
![Learn](https://github.com/DenDmitriev/flashspeak/assets/65191747/cbb33f18-1ed6-4a32-b389-b7134311cdbe)

#### Результаты изучения
После каждого прохождения изучения, открывается экран результатов. Он состоит из двух частей: статистика и допущенные ошибки. Есть возможность пройти изучение снова по кнопке "Повторить"[^1].
![Results](https://github.com/DenDmitriev/flashspeak/assets/65191747/a1a07ecb-40c8-4c15-b07e-19008e9f1b6b)

#### Темное оформление
Приложение поддерживает автоматическое переключение режима оформления.
![Scene 4](https://github.com/DenDmitriev/flashspeak/assets/65191747/16b0e3a5-68b9-434b-8e37-c095421addd0)

## Реализация

### API
Используются API сервисы для [перевода](#перевод) и [изображений](#изображения)

#### Перевод
Перевод осуществялется силами [Yandex Cloud Functions](https://cloud.yandex.ru/services/functions). Приложение отправляет список слов и получает ответ в виде переведенного списка[^4].

#### Изображения
Подбор изображений осуществляет сервис [Unsplash](https://unsplash.com/developers). Приложение отправляет ключевое слово и код языка, а ответ приходит в виде ссылок на изображения. Сервис не всегда присылает подходящие фотографии, поэтому в будущем он заменится на альтернативный, это будет лего сделать, так как сетевой слой написан универсально с использованием generic функции[^4][^1]. Хранятся изображения в виде ссылок. При загрузке фотографий используется cache, а индивидуальные фотографии пользователя для карточек сохраняются в папку приложения[^1].

### Архитектура
Используется ModelViewPresenter. Архитектура удобна в командной работе над проектом.

### Паттерны
- Delegate
- Strategy
- Caretaker
- Singleton
- Coordinator
- Router
- Builder

### Библиотеки
- UIKit
- CoreData
- Combine
- AVFoundation 

### Хранение данных
- CoreData[^2]
<img width="500" src="https://github.com/DenDmitriev/flashspeak/assets/67875958/be1480a4-8167-4b4b-9371-0a8735ce7ee4">

- UserDefaults[^2]
- Config.xcconfig[^4]

### Требования
- iOS 16.0+
- Xcode 14.3

## Как запустить
Для запуска приложения, нужно ввести ключи API в Config.xcconfig.

## Зачем
Проект создан в рамках курса "Командная разработка на Swift" в школе [GeekBrains](https://gb.ru). Преподаватель курса [Александр Рубцов](https://github.com/Lemonbrush).

## To Do
- [ ] Добавить трансфер списка слов на другой язык
- [ ] Сделать экран настроек приложения
- [ ] Сделать несколько списков слов по умолчанию при первом открытии приложения
- [ ] Добавить возможность сменить язык в приложении
- [ ] Заменить сервис изображений
- [ ] Добавить графики для отображения статистики

## Команда проекта
- [Денис Дмитриев](https://github.com/DenDmitriev)
- [Анастасия](https://github.com/losikova)
- [OksanaKam](https://github.com/OksanaKam)
- [Heoh888](https://github.com/Heoh888)
    
![Scene 1](https://github.com/DenDmitriev/flashspeak/assets/65191747/183f987e-11fc-4208-8cf9-a9836c6a188a)

[^1]: [Денис Дмитриев](https://github.com/DenDmitriev)
[^2]: [Анастасия](https://github.com/losikova)
[^3]: [OksanaKam](https://github.com/OksanaKam)
[^4]: [Heoh888](https://github.com/Heoh888)
