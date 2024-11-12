﻿#Использовать cli
#Использовать "../internal"

Перем ОписаниеЗапроса;

#Область ПрограммныйИнтерфейс

Функция Конвертировать(КоманднаяСтрока, пГенераторПрограммногоКода = Неопределено) Экспорт
	
	Если пГенераторПрограммногоКода = Неопределено Тогда
		ГенераторПрограммногоКода = Новый ГенераторПрограммногоКода1С();
	Иначе
		ГенераторПрограммногоКода = пГенераторПрограммногоКода;
	КонецЕсли;

	Парсер = Новый ПарсерКонсольнойКоманды();
	АргументыКоманд = Парсер.Распарсить(КоманднаяСтрока);

	Приложение = Новый КонсольноеПриложение("curl", "", ЭтотОбъект);
	Приложение.УстановитьСпек("[URL...] [OPTIONS] [URL...]");

	Приложение.Аргумент("URL", "", "Адрес ресурса").ТМассивСтрок();
	Приложение.Опция("url", "", "URL").ТМассивСтрок();
	Приложение.Опция("H header", "", "HTTP заголовок").ТМассивСтрок();
	Приложение.Опция("X request", "", "Метод запроса").ТСтрока();
	Приложение.Опция("u user", "", "Пользователь и пароль").ТСтрока();
	Приложение.Опция("d data data-ascii", "", "Передаваемые данные по HTTP POST").ТМассивСтрок();
	Приложение.Опция("data-raw", "", "Передаваемые данные по HTTP POST без интерпретации символа @").ТМассивСтрок();
	Приложение.Опция("data-binary", "", "Передаваемые двоичные данные по HTTP POST").ТМассивСтрок();
	Приложение.Опция("data-urlencode", "", "Передаваемые данные по HTTP POST с URL кодированием").ТМассивСтрок();
	Приложение.Опция("T upload-file", "", "Загружаемый файл").ТМассивСтрок();
	Приложение.Опция("G get", Ложь, "Данные из опций -d и--data-... добавляются в URL как строка запроса").Флаговый();
	Приложение.Опция("I head", Ложь, "Получение заголовков").Флаговый();
	Приложение.Опция("E cert", "", "Сертификат клиента").ТМассивСтрок();
	Приложение.Опция("ca-native", Ложь, "Использование сертификатов УЦ из системного хранилища сертификатов операционной системы").Флаговый();
	Приложение.Опция("cacert", "", "Файл сертификатов удостоверяющих центров").ТМассивСтрок();

	Приложение.УстановитьОсновноеДействие(ЭтотОбъект);

	Если АргументыКоманд.Количество() = 0 Тогда
		ВызватьИсключение "Команда должна начинаться с ""curl""";
	КонецЕсли;

	Результат = "";
	Для Каждого АргументыКоманды Из АргументыКоманд Цикл
		Если Не (НРег(АргументыКоманды[0]) = "curl") Тогда
			ВызватьИсключение "Команда должна начинаться с ""curl""";
		КонецЕсли;

		ОписаниеЗапроса = Новый ОписаниеЗапроса();

		АргументыКоманды.Удалить(0);
		Приложение.Запустить(АргументыКоманды);

		Результат = Результат 
			+ ?(Результат = "", "", Символы.ПС + Символы.ПС)
			+ ГенераторПрограммногоКода.Получить(ОписаниеЗапроса);
	КонецЦикла;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьКоманду(Команда) Экспорт

	ПрочитатьURL(Команда);
	ПрочитатьЗаголовки(Команда);
	ПрочитатьПользователя(Команда);
	ПрочитатьДанныеДляОтправки(Команда);
	ПрочитатьМетодЗапроса(Команда);
	ПрочитатьПризнакПередачиОтправляемыхДанныхВСтрокуЗапроса(Команда);
	ПрочитатьСертификатКлиента(Команда);
	ПрочитатьИспользованиеСертификатыУЦИзХранилищаОС(Команда);
	ПрочитатьИмяФайлаСертификатовУЦ(Команда);
	
КонецПроцедуры

Процедура ПрочитатьМетодЗапроса(Команда)

	Метод = Команда.ЗначениеОпции("X");

	Если ЗначениеЗаполнено(Метод) Тогда
		ОписаниеЗапроса.Метод = Метод;
		Возврат;
	КонецЕсли;

	Если Команда.ЗначениеОпции("get") = Ложь И ЕстьОпцииГруппыData(Команда) Тогда
		ОписаниеЗапроса.Метод = "POST";
	ИначеЕсли ЕстьОпции(Команда, "T,upload-file") Тогда
		ОписаниеЗапроса.Метод = "PUT";
	ИначеЕсли Команда.ЗначениеОпции("head") = Истина Тогда
		ОписаниеЗапроса.Метод = "HEAD";
	КонецЕсли;

КонецПроцедуры

Процедура ПрочитатьURL(Команда)
    
	ОписаниеЗапроса.URL = Команда.ЗначениеАргумента("URL");

	Для Каждого АдресРесурса Из Команда.ЗначениеОпции("url") Цикл
		ОписаниеЗапроса.URL.Добавить(АдресРесурса);
	КонецЦикла;

КонецПроцедуры

Процедура ПрочитатьЗаголовки(Команда)

	ОписаниеЗапроса.Заголовки = РазобратьЗаголовки(Команда);
	ДополнитьЗаголовкиПриНаличииОпцииГруппыData(Команда);

КонецПроцедуры

Процедура ДополнитьЗаголовкиПриНаличииОпцииГруппыData(Команда)
	Если ЕстьОпцииГруппыData(Команда)
		И Команда.ЗначениеОпции("get") = Ложь
		И Не ЗначениеЗаполнено(ЗначениеЗаголовка(ОписаниеЗапроса.Заголовки, "Content-Type")) Тогда
		ОписаниеЗапроса.Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	КонецЕсли;
КонецПроцедуры

Функция РазобратьЗаголовки(Команда)

	Заголовки = Новый Соответствие;
	МассивЗаголовков = Команда.ЗначениеОпции("H");
	Для Каждого Строка Из МассивЗаголовков Цикл
		Имя = "";
		Значение = "";

		ПозицияДвоеточия = СтрНайти(Строка, ":");
		Если ПозицияДвоеточия Тогда
			Имя = СокрЛП(Сред(Строка, 1, ПозицияДвоеточия - 1));
			Значение = СокрЛП(Сред(Строка, ПозицияДвоеточия + 1));
		Иначе
			Имя = Строка;
		КонецЕсли;

		Заголовки.Вставить(Имя, Значение);
	КонецЦикла;

	Возврат Заголовки;

КонецФункции

Функция ЗначениеЗаголовка(Заголовки, Имя)

	Для Каждого КлючЗначение Из Заголовки Цикл
		Если НРег(КлючЗначение.Ключ) = НРег(Имя) Тогда
			Возврат КлючЗначение.Значение;
		КонецЕсли;
	КонецЦикла;

КонецФункции

Процедура ПрочитатьПользователя(Команда)
	ПользовательИПароль = Команда.ЗначениеОпции("u");
	МассивПодстрок = СтрРазделить(ПользовательИПароль, ":");

	ОписаниеЗапроса.ИмяПользователя = МассивПодстрок[0];
	Если МассивПодстрок.Количество() = 2 Тогда
		ОписаниеЗапроса.ПарольПользователя = МассивПодстрок[1];
	КонецЕсли
КонецПроцедуры

Процедура ПрочитатьДанныеДляОтправки(Команда)

	ПрочитатьData(Команда);
	ПрочитатьDataRaw(Команда);
	ПрочитатьDataBinary(Команда);
	ПрочитатьDataUrlencode(Команда);
	ПрочитатьUploadFile(Команда);

КонецПроцедуры

Процедура ПрочитатьData(Команда)

	МассивДанных = Команда.ЗначениеОпции("d"); // -d, --data

	Для Каждого Данные Из МассивДанных Цикл

		Если Лев(Данные, 1) = "@" Тогда
			ИмяФайла = Сред(Данные, 2);

			ПередаваемыеДанные = ОписаниеПередаваемогоФайла();
			ПередаваемыеДанные.ИмяФайла = ИмяФайла;
			ПередаваемыеДанные.ПрочитатьСодержимое = Истина;
			ПередаваемыеДанные.УдалятьПереводыСтрок = Истина;
			
			ОписаниеЗапроса.Файлы.Добавить(ПередаваемыеДанные);
		Иначе
			ОписаниеЗапроса.ОтправляемыеТекстовыеДанные.Добавить(Данные);
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры

Процедура ПрочитатьDataRaw(Команда)

	МассивДанных = Команда.ЗначениеОпции("data-raw");

	Для Каждого Данные Из МассивДанных Цикл
		ОписаниеЗапроса.ОтправляемыеТекстовыеДанные.Добавить(Данные);
	КонецЦикла;

КонецПроцедуры

Процедура ПрочитатьDataBinary(Команда)

	МассивДанных = Команда.ЗначениеОпции("data-binary");
	Для Каждого ИмяФайла Из МассивДанных Цикл		
		Если Лев(ИмяФайла, 1) = "@" Тогда
			ИмяФайла = Сред(ИмяФайла, 2);
		КонецЕсли;
		
		ПередаваемыеДанные = ОписаниеПередаваемогоФайла();
		ПередаваемыеДанные.ИмяФайла = ИмяФайла;

		ОписаниеЗапроса.Файлы.Добавить(ПередаваемыеДанные);
	КонецЦикла;

КонецПроцедуры

Процедура ПрочитатьDataUrlencode(Команда)

	МассивДанных = Команда.ЗначениеОпции("data-urlencode");
	Для Каждого Данные Из МассивДанных Цикл
		ПозицияРавенства = СтрНайти(Данные, "=");
		ПозицияСобачки = СтрНайти(Данные, "@");
		Если ПозицияРавенства > 0 Тогда
			Ключ = Сред(Данные, 1, ПозицияРавенства - 1);
			Значение = Сред(Данные, ПозицияРавенства + 1);
			
			ПередаваемыеДанные = КодироватьСтроку(Значение, СпособКодированияСтроки.URLВКодировкеURL);
			Если ЗначениеЗаполнено(Ключ) Тогда
				ПередаваемыеДанные = СтрШаблон("%1=%2", Ключ, ПередаваемыеДанные);
			КонецЕсли;

			ОписаниеЗапроса.ОтправляемыеТекстовыеДанные.Добавить(ПередаваемыеДанные);
		ИначеЕсли ПозицияСобачки > 0 Тогда
			Ключ = Сред(Данные, 1, ПозицияСобачки - 1);
			ИмяФайла = СокрЛП(Сред(Данные, ПозицияСобачки + 1));	
			
			ПередаваемыеДанные = ОписаниеПередаваемогоФайла();
			ПередаваемыеДанные.Ключ = Ключ;
			ПередаваемыеДанные.ИмяФайла = ИмяФайла;
			ПередаваемыеДанные.ПрочитатьСодержимое = Истина;
			ПередаваемыеДанные.КодироватьСодержимое = Истина;

			ОписаниеЗапроса.Файлы.Добавить(ПередаваемыеДанные);
		Иначе
			ПередаваемыеДанные = КодироватьСтроку(Данные, СпособКодированияСтроки.URLВКодировкеURL);
			ОписаниеЗапроса.ОтправляемыеТекстовыеДанные.Добавить(ПередаваемыеДанные);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПрочитатьUploadFile(Команда)

	МассивДанных = Команда.ЗначениеОпции("T"); // T, --upload-file

	Для Каждого ИмяФайла Из МассивДанных Цикл

		ОписаниеФайла = ОписаниеПередаваемогоФайла();
		ОписаниеФайла.ИмяФайла = ИмяФайла;

		ОписаниеЗапроса.Файлы.Добавить(ОписаниеФайла);

	КонецЦикла;

КонецПроцедуры

Процедура ПрочитатьПризнакПередачиОтправляемыхДанныхВСтрокуЗапроса(Команда)
	
	ОписаниеЗапроса.ПередаватьОтправляемыеДанныеВСтрокуЗапроса = Команда.ЗначениеОпции("get");

КонецПроцедуры

Процедура ПрочитатьСертификатКлиента(Команда)

	СертификатКлиента = "";

	МассивЗначений = Команда.ЗначениеОпции("E");
	Если МассивЗначений.Количество() Тогда
		СертификатКлиента = МассивЗначений[МассивЗначений.ВГраница()];
	КонецЕсли;

	Если Не ЗначениеЗаполнено(СертификатКлиента) Тогда
		Возврат;
	КонецЕсли;

	ПозицияДвоеточия = СтрНайти(СертификатКлиента, ":");
	Если ПозицияДвоеточия > 0 Тогда
		ОписаниеЗапроса.ИмяФайлаСертификатаКлиента = Сред(СертификатКлиента, 1, ПозицияДвоеточия - 1);
		ОписаниеЗапроса.ПарольСертификатаКлиента = Сред(СертификатКлиента, ПозицияДвоеточия + 1);
	Иначе
		ОписаниеЗапроса.ИмяФайлаСертификатаКлиента = СертификатКлиента;
	КонецЕсли;

КонецПроцедуры

Процедура ПрочитатьИмяФайлаСертификатовУЦ(Команда)

	МассивЗначений = Команда.ЗначениеОпции("cacert");
	Если МассивЗначений.Количество() Тогда
		ОписаниеЗапроса.ИмяФайлаСертификатовУЦ = МассивЗначений[МассивЗначений.ВГраница()];
	КонецЕсли;

КонецПроцедуры

Процедура ПрочитатьИспользованиеСертификатыУЦИзХранилищаОС(Команда)

	ОписаниеЗапроса.ИспользоватьСертификатыУЦИзХранилищаОС = Команда.ЗначениеОпции("ca-native");

КонецПроцедуры

Функция ЕстьОпции(Команда, Опции)
	Для Каждого Опция Из СтрРазделить(Опции, ",") Цикл
		Если ЗначениеЗаполнено(Команда.ЗначениеОпции(Опция)) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Функция ЕстьОпцииГруппыData(Команда)
	Возврат ЕстьОпции(Команда, "d,data,data-raw,data-binary,data-urlencode,data-ascii");
КонецФункции

Функция ОписаниеПередаваемогоФайла()
	ОписаниеФайла = Новый Структура();
	ОписаниеФайла.Вставить("ИмяФайла", """");	
	ОписаниеФайла.Вставить("ПрочитатьСодержимое", Ложь);		
	ОписаниеФайла.Вставить("КодироватьСодержимое", Ложь);	
	ОписаниеФайла.Вставить("УдалятьПереводыСтрок", Ложь);
	ОписаниеФайла.Вставить("Ключ", "");	
	Возврат ОписаниеФайла;
КонецФункции

#КонецОбласти