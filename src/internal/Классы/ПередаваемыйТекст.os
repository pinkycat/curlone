// BSLLS:ExportVariables-off

// Имя поля на форме или в строке запроса
Перем ИмяПоля Экспорт; // Строка, Неопределено

// Текстовое значение
Перем Значение Экспорт; // Строка

// Назначение текста
Перем Назначение Экспорт; // см. НазначенияПередаваемыхДанных

// Кодировать значение
Перем КодироватьЗначение Экспорт; // Булево

// Разделитель при формировании тела запроса или строки запроса
Перем РазделительТелаЗапроса Экспорт; // Строка

// MIME-тип файла (multipart/form-data)
Перем ТипMIME Экспорт; // Строка

// HTTP заголовки запроса (multipart/form-data)
Перем Заголовки Экспорт; // Соответствие

Функция ПолноеЗначение(Разделитель = "=") Экспорт
	
	Если КодироватьЗначение Тогда
		НовоеЗначение = КодироватьСтроку(Значение, СпособКодированияСтроки.КодировкаURL);
	Иначе
		НовоеЗначение = Значение;
	КонецЕсли;

	Если ИмяПоля <> Неопределено Тогда
		ПолноеЗначение = СтрШаблон("%1%2%3", ИмяПоля, Разделитель, НовоеЗначение);
	Иначе
		ПолноеЗначение = НовоеЗначение;
	КонецЕсли;

	Возврат ПолноеЗначение;

КонецФункции

Процедура ПриСозданииОбъекта(ТекстовоеЗначение, НазначениеТекста)

	ИмяПоля = Неопределено;
	Значение = ТекстовоеЗначение;
	Назначение = НазначениеТекста;
	КодироватьЗначение = Ложь;
	РазделительТелаЗапроса = "&";
	ТипMIME = "";
	Заголовки = Новый Соответствие();
    
КонецПроцедуры
