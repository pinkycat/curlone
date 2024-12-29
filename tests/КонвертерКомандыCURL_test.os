#Использовать asserts
#Использовать ".."

Перем юТест;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	
	СписокТестов.Добавить("ТестДолжен_ВыброситьИсключениеКомандаНачинаетсяНеСCurl");
	СписокТестов.Добавить("ТестДолжен_ВыброситьИсключениеЕслиПереданаПустаяКоманда");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОшибкуОпцияНеизвестна");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОшибкуОпцияНеПоддерживается");
	СписокТестов.Добавить("ТестДолжен_ВыброситьИсключениеПриНеудачномПолученииНомераПорта");

	Возврат СписокТестов;
	
КонецФункции

Процедура ТестДолжен_ВыброситьИсключениеКомандаНачинаетсяНеСCurl() Экспорт

	КонсольнаяКоманда = "myapp -H 'accept: text/html'";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КонсольнаяКоманда);
	ПараметрыМетода.Добавить(Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(КонвертерКомандыCURL)
		.Метод("Конвертировать", ПараметрыМетода)
		.ВыбрасываетИсключение("Команда должна начинаться с ""curl""");

КонецПроцедуры

Процедура ТестДолжен_ВыброситьИсключениеЕслиПереданаПустаяКоманда() Экспорт

	КонсольнаяКоманда = "";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КонсольнаяКоманда);
	ПараметрыМетода.Добавить(Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(КонвертерКомандыCURL)
		.Метод("Конвертировать", ПараметрыМетода)
		.ВыбрасываетИсключение("Передана пустая команда");

КонецПроцедуры


Процедура ТестДолжен_ПроверитьОшибкуОпцияНеизвестна() Экспорт

	КонсольнаяКоманда = "curl http://example.com/ --unknown-option";

	Ошибки = Неопределено;

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда,, Ошибки);

	Ожидаем.Что(Результат).Не_().Заполнено();
	Ожидаем.Что(Ошибки).Заполнено();
	Ожидаем.Что(Ошибки[0].Текст).Равно("Опция --unknown-option неизвестна");
	Ожидаем.Что(Ошибки[0].Критичная).ЭтоИстина();

КонецПроцедуры

Процедура ТестДолжен_ПроверитьОшибкуОпцияНеПоддерживается() Экспорт

	КонсольнаяКоманда = "curl http://example.com/ --hsts cache.txt";
	
	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	Ошибки = Неопределено;

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда,, Ошибки);

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	Ожидаем.Что(Ошибки).Заполнено();
	Ожидаем.Что(Ошибки[0].Текст).Равно("Опция --hsts не поддерживается");
	Ожидаем.Что(Ошибки[0].Критичная).ЭтоЛожь();

КонецПроцедуры

Процедура ТестДолжен_ВыброситьИсключениеПриНеудачномПолученииНомераПорта() Экспорт

	КонсольнаяКоманда = "curl http://example.com:port";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КонсольнаяКоманда);
	ПараметрыМетода.Добавить(Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(КонвертерКомандыCURL)
		.Метод("Конвертировать", ПараметрыМетода)
		.ВыбрасываетИсключение("Не удалось получить номер порта из URL 'http://example.com:port'");

КонецПроцедуры