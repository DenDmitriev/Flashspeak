# Contenido

- [Revisión](#revisión)
- [Oportunidades](#oportunidades)
   - [Selección de idioma](#selección-de-idioma)
   - [Listas de palabras](#listas-de-palabras)
   - [Crear y editar una lista de palabras](#crear-y-editar-una-lista-de-palabras)
   - [Ver tarjetas](#ver-tarjetas)
   - [Edición de tarjetas](#edición-de-tarjetas)
   - [Estudio](#estudio)
   - [Resultados del estudio](#resultados-del-estudio)
   - [Decoración oscura](#decoración-oscura)

# Revisión

<body>
   <header class="page-header" role="banner">
   <h1 class="page-title"><invert-color-text>Crear una lista</invert-color-text ></h1>
   <video width="292" height="633" controls>
      <source src="https://github.com/DenDmitriev/Flashspeak/assets/65191747/58b89449-d0b4-4f5f-8aca-3a2d06f4c7d1">
   </video>
   <h1 class="page-title"><invert-color-text>Formación</invert-color-text ></h1>
   <video width="292" height="633" controls>
      <source src="https://github.com/DenDmitriev/Flashspeak/assets/65191747/ce74edcc-260e-4e8c-9171-28be5a19f64d">
   </video>
   <h1 class="page-title"><invert-color-text>Lista de palabras</invert-color-text ></h1>
   <video width="292" height="633" controls>
      <source src="https://github.com/DenDmitriev/Flashspeak/assets/65191747/b81403d8-5ad2-4f0a-bd46-7828240b0543">
   </video>
   </header>
</body>

## Oportunidades
El usuario, al seleccionar el idioma de estudio, puede crear fácilmente su lista de palabras para aprender. Las palabras se pueden agregar a través de la inserción o escribiendo individualmente. La aplicación formará la traducción y encontrará las imágenes adecuadas para cada palabra. El usuario en la pantalla de Inicio verá una nueva lista. Al hacer clic en él, puede ver las tarjetas resultantes, y si la traducción y la imagen seleccionada no encajan, puede cargar su imagen o cambiar la traducción de la palabra. El estudio se puede realizar en diferentes escenarios. La tarjeta de estudio se puede hacer a partir de partes: la palabra original, la traducción y la imagen. Puede responder a la tarjeta propuesta a través de pruebas o escribiendo la respuesta en el teclado. Para entender el sonido, hay un botón para pronunciar la palabra en voz alta. Los resultados de cada examen de la lista se guardan y se forman en estadísticas, así como al usuario se le mostrarán los errores para trabajar en ellos.

## Selección de idioma
La primera vez que se abre la aplicación, el usuario ve una pantalla de bienvenida. La aplicación le pide que seleccione el idioma nativo y que se está estudiando. Al hacer clic en el botón" Iniciar", el script del primer Inicio termina y se abre la pantalla principal con listas de palabras.
![Welcome](https://github.com/DenDmitriev/Flashspeak/assets/65191747/ad9143c1-6773-4bdd-91d6-7cfdfde20d2d)

## Listas de palabras
Esta es la pantalla de Inicio que el usuario verá cuando inicie la aplicación posteriormente. Inicialmente, la pantalla está en blanco. Para Mostrar al usuario qué hacer a continuación, se muestra una flecha que apunta al botón crear lista "+". Después de crear la lista, el usuario puede verla en la pantalla principal. Al hacer clic largo en una celda de la lista o en el botón en la esquina superior derecha, se abre un menú para controlar la lista de palabras. Si el usuario decide aprender otro idioma, puede cambiarlo a través del botón con la imagen de la bandera en la esquina superior derecha de la pantalla.
![List](https://github.com/DenDmitriev/Flashspeak/assets/65191747/422521d3-a66c-4ab2-a38c-2642012701c6)

## Crear y editar una lista de palabras
La creación de una lista comienza con el botón " + " en la pantalla principal de listas. Al hacer clic, se abre una ventana modal con campos para el título, un selector de color para la orientación y un interruptor de imagen para las palabras. Al hacer clic en" Crear lista", el usuario llega a la pantalla de conjunto de palabras. La pantalla le permite crear y editar palabras, solo tiene tres elementos: un campo de entrada, un botón crear y un botón de ayuda. Las palabras se pueden escribir escribiendo desde el teclado, así como insertar una lista ya hecha de palabras, que están separadas por una coma o una transición de línea. Para orientar al usuario, hay un botón de pregunta que abre una ventana que describe las posibilidades. La lista tiene requisitos mínimos de número de palabras, las pistas con esta información se muestran en el botón durante el proceso de escribir palabras. Para agregar una palabra a la lista, puede usar el botón Enter, la coma o el botón + que aparece a la derecha del campo en el momento en que comienza a escribir la palabra. Para eliminar o corregir una palabra ya introducida, debe mantenerla presionada durante un par de segundos, aparecen los campos eliminar y editar. El usuario debe mover la palabra al campo deseado. Si el usuario no hace clic en el botón crear tarjetas y desea volver a la pantalla anterior, la aplicación ofrecerá dos opciones: salir sin guardar o volver, para no perder la lista creada.
![ListMaker](https://github.com/DenDmitriev/Flashspeak/assets/65191747/384109c5-b65a-4cdf-8fe9-2936e212f8db)

## Ver tarjetas
Después de crear una lista de palabras, se abre una pantalla con tarjetas. En él, puede ver las tarjetas junto con las imágenes, existe la posibilidad de editar o eliminar. Puede editar toda la lista de palabras en el botón redondo en la parte inferior derecha. Se puede acceder a la pantalla a través del menú desde la pantalla de Inicio y en la pantalla de Resumen antes de estudiar. Puede cambiar el nombre y el estilo de la lista haciendo clic en el botón intuitivo de la barra de navegación.
![WordCards](https://github.com/DenDmitriev/Flashspeak/assets/65191747/914ccf69-7edd-419d-873d-7307e4db3ee7)


## Edición de tarjetas
La pantalla realiza la función de edición de tarjetas. Si el Servicio no recogió la traducción correcta, entonces puede cambiarla. Y si no es una imagen adecuada, el Servicio en el carrusel ofrece una selección de otras fotos. Al deslizar y seleccionar la imagen deseada en el carrusel, el banner del título cambia sobre la tarjeta. La Última celda del carrusel es un botón que le da la opción de cargar su imagen desde la galería del dispositivo. Al hacer clic en el botón guardar, la tarjeta se actualiza.
![Card](https://github.com/DenDmitriev/Flashspeak/assets/65191747/5da47334-b853-4562-a285-4b58a3723c8e)

## Estudio
Antes de iniciar el estudio, se le pide al usuario que seleccione la configuración individual de la tarjeta de palabras y la función de edición de la lista. Al hacer clic en el botón de configuración, se abre un menú donde puede seleccionar la visualización de la pregunta y el método de respuesta. La pantalla se crea según el patrón Strategy. Caretaker es responsable de guardar las respuestas del usuario, que luego proporciona datos para la pantalla de estadísticas y el trabajo sobre errores.
![Learn](https://github.com/DenDmitriev/Flashspeak/assets/65191747/f1339dce-b8f4-4d96-9ba1-6c9c35fb9029)

## Resultados del estudio
Después de cada paso del estudio, se abre la pantalla de resultados. Consta de dos partes: estadísticas y errores cometidos. Existe la posibilidad de pasar el estudio de nuevo por el botón "Repetir".
![Results](https://github.com/DenDmitriev/Flashspeak/assets/65191747/84ccb82b-578c-4d78-8639-73c866354219)

## Decoración oscura
La aplicación Admite el cambio automático del modo de diseño.
![Scene 4](https://github.com/DenDmitriev/Flashspeak/assets/65191747/c6dcef4c-ffc2-4d82-9fea-3f179abeda9d)