# Содержание

- [Review](#review)
- [Features](#features)
   - [Language selection](#language-selection)
   - [Word Lists](#word-lists)
   - [Creating and editing a list of words](#creating-and-editing-a-list-of-words))
   - [Viewing cards](#viewing-cards)
   - [Card editing](#card-editing)
   - [Study](#study)
   - [Study results](#study-results)
   - [Dark design](#dark-design)

# Review

<body>
   <header class="page-header" role="banner">
   <h1 class="page-title"><invert-color-text>Creating a list</invert-color-text ></h1>
   <video width="292" height="633" controls>
      <source src="https://github.com/DenDmitriev/Flashspeak/assets/65191747/58b89449-d0b4-4f5f-8aca-3a2d06f4c7d1">
   </video>
   <h1 class="page-title"><invert-color-text>Training</invert-color-text ></h1>
   <video width="292" height="633" controls>
      <source src="https://github.com/DenDmitriev/Flashspeak/assets/65191747/ce74edcc-260e-4e8c-9171-28be5a19f64d">
   </video>
   <h1 class="page-title"><invert-color-text>List of words</invert-color-text ></h1>
   <video width="292" height="633" controls>
      <source src="https://github.com/DenDmitriev/Flashspeak/assets/65191747/b81403d8-5ad2-4f0a-bd46-7828240b0543">
   </video>
   </header>
</body>

# Features
The user, by [selecting the language of study](#language-selection), can easily [create their own list of words](#creating-and-editing-a-list-of-words) to study. Words can be added via insertion or by entering individually. The application will [generate a translation](#translation) and find suitable images for each word. The user [on the main screen](#word lists) will see a new list. By clicking on it, you can [view the resulting cards](#view-cards), and if the translation and the selected image do not fit, then [you can upload your image or change the translation of the word](#card-editing). [The study can take place in various scenarios](#study). A study card can be made from parts: the source word, the translation and the image. You can answer the proposed card through testing or by typing the answer on the keyboard. To understand the sound, there is a button to say the word out loud. The results of each study of the list are saved and [generated into statistics](#results-studies), the user will also be shown errors to work on them.

## Language selection
When opening the application for the first time, the user sees a welcome screen. The application asks you to choose your native language and the one you are studying. By clicking the "Start" button, the script of the first start ends and the main [screen with lists](#word lists) of words opens.
![Welcome](https://github.com/DenDmitriev/Flashspeak/assets/65191747/ad9143c1-6773-4bdd-91d6-7cfdfde20d2d)

## Word Lists
This is the main screen that the user will see on subsequent launches of the application. Initially, the screen is empty. To show the user what to do next, an arrow is shown that points to the "+" list creation button. After creating the list, the user can see it on the main screen. When you long-press the list cell or the button in the upper right corner, a menu opens to manage the list of words. If the user decides to learn another language, he can change it by clicking the button with the flag image in the upper right corner of the screen.
![List](https://github.com/DenDmitriev/Flashspeak/assets/65191747/422521d3-a66c-4ab2-a38c-2642012701c6)

## Creating and editing a list of words
The creation of the list begins with the "+" button on the main list screen. When clicked, a modal window opens with fields for the name, a color selection for orientation and an image switch for words. By clicking on "Create a list", the user gets to the screen of a set of words. The screen allows you to create and edit words, it has only three elements: an input field, a create button and a help button. Words can be entered by typing from the keyboard, as well as inserting a ready-made list of words that are separated by a comma or a line transition. To orient the user, there is a button with a question that opens a window with a description of the possibilities. The list has minimum requirements for the number of words, hints with this information are displayed on the button during the typing process. To add a word to the list, you can use the Enter button, a comma, or the + button that appears to the right of the field when you start typing the word. To delete or correct an already entered word, you need to hold it for a couple of seconds, the delete and edit fields are activated. The user needs to move the word to the desired field. If the user does not click on the create cards button and wants to return to the previous screen, the application will offer two options: exit without saving or return so as not to lose the created list.
![ListMaker](https://github.com/DenDmitriev/Flashspeak/assets/65191747/384109c5-b65a-4cdf-8fe9-2936e212f8db)

## Viewing cards
After creating a list of words, a screen with cards opens. You can view cards with pictures on it, there is an option to [edit](#edit-cards) or delete. You can edit the entire list of words by clicking the circular button at the bottom right. The screen can be accessed via the menu from the main screen and in the overview screen before studying. The name and style of the list can be changed by clicking on the intuitive button in the navigation bar.
![WordCards](https://github.com/DenDmitriev/Flashspeak/assets/65191747/914ccf69-7edd-419d-873d-7307e4db3ee7)


## Card editing
The screen performs the card editing function. If the service has picked up an incorrect translation, then it can be changed. And if the image is not suitable, then the service in the carousel offers a choice of other photos. After scrolling through and selecting the desired image in the carousel, the title banner changes above the card. The last cell of the carousel is a button that allows you to upload your image from the device's gallery. By clicking on the save button, the card is updated.
![Card](https://github.com/DenDmitriev/Flashspeak/assets/65191747/5da47334-b853-4562-a285-4b58a3723c8e)

## Study
Before starting the study, the user is asked to select individual settings of the word card and the list editing functions. By clicking on the settings button, a menu opens where you can select the display of the question and the method of answer. The screen is created according to the Strategy pattern. Caretaker is responsible for saving the user's responses, which then gives data for [statistics screen](#results-study) and error correction.
![Learn](https://github.com/DenDmitriev/Flashspeak/assets/65191747/f1339dce-b8f4-4d96-9ba1-6c9c35fb9029)

## Study results
After each completion of the study, the results screen opens. It consists of two parts: statistics and mistakes made. It is possible to go through the study again by clicking the "Repeat" button.
![Results](https://github.com/DenDmitriev/Flashspeak/assets/65191747/84ccb82b-578c-4d78-8639-73c866354219)

## Dark design
The application supports automatic switching of the design mode.
![Scene 4](https://github.com/DenDmitriev/Flashspeak/assets/65191747/c6dcef4c-ffc2-4d82-9fea-3f179abeda9d)


