#Использовать datetime

Перем ОписаниеОшибкиКласса;
Перем ФорматДаты;

Процедура ПриСозданииОбъекта(Знач ВходящийФорматДаты = "yyyy-MM-dd HH:mm:ss")
	
	ФорматДаты = ВходящийФорматДаты;

КонецПроцедуры

// Возвращает строковое представление значения типа
//
// Параметры:
//   Значение - Массив - значение типа
//
//  Возвращаемое значение:
//   строка - значение в строковом представлении
//
Функция ВСтроку(Знач Значение) Экспорт
	
	Возврат ПреобразоватьМассивВСтроку(Значение);
	
КонецФункции

// Преобразует и устанавливает входящее значение к значению типа
//
// Параметры:
//   ВходящееЗначение - строка - строковое представление значения
//   Значение - массив - переменная для установки значения
//
//  Возвращаемое значение:
//   массив - конвертированные значение
//
Функция УстановитьЗначение(Знач ВходящееЗначение, Значение) Экспорт

	Попытка
		ПроцессорДаты = Новый ДатаВремя();

		ВходящееЗначение = ПроцессорДаты.СтрокаВДату(ВходящееЗначение, ФорматДаты);
		Значение.Добавить(ВходящееЗначение);
	Исключение
		Значение = Дата("20010101");
		ОписаниеОшибкиКласса = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Значение;

КонецФункции 

// Возвращает описание ошибки и устанавливает признак ошибки 
//
// Параметры:
//   ЕстьОшибка - булево - произвольная переменная
//
//  Возвращаемое значение:
//   Строка - описание текущей ошибки преобразования типов
//
Функция Ошибка(ЕстьОшибка = Ложь) Экспорт

	Если НЕ ПустаяСтрока(ОписаниеОшибкиКласса) Тогда
		ЕстьОшибка = Истина;
	КонецЕсли;

	Возврат ОписаниеОшибкиКласса;
	
КонецФункции

Функция ПреобразоватьМассивВСтроку(Знач Значение)

	Если НЕ ТипЗнч(Значение) = Тип("Массив") Тогда
		Возврат "";
	КонецЕсли;

	Для каждого ЭлементМассива Из Значение Цикл
		
		ЭлементМассива = Формат(ЭлементМассива, ФорматДаты);

	КонецЦикла;

	Возврат СтрСоединить(Значение, ", ");

КонецФункции

ОписаниеОшибкиКласса = "";