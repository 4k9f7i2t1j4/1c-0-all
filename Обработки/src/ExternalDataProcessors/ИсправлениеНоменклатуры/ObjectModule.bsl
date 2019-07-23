Перем СсылкаНаОбъект Экспорт;

Процедура Инициализировать(Объект, ИмяТабличнойЧасти, ТабличноеПоле) Экспорт;
	СсылкаНаОбъект = Объект;
	ПроверкаНоменклатуры();
КонецПроцедуры

Процедура ПроверкаНоменклатуры() Экспорт;
	// проверка артикулов номенклатуры (изделий)
	// "правильные" артикулы изделий начинаются с А
	// кнопка "Проверить номенклатуру"
	
	ТекДок = СсылкаНаОбъект.ИсходныеКомплектующие.Выгрузить(,"Номенклатура");
	Список = Новый СписокЗначений;
	Для каждого стр Из ТекДок Цикл
		Если СтрНайти(стр.Номенклатура, "C")=1 Тогда Список.Добавить(стр.Номенклатура); КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КомплектующиеНоменклатуры.Номенклатура.Наименование КАК Наименование
		|ПОМЕСТИТЬ НаССКомплектующими
		|ИЗ
		|	РегистрСведений.КомплектующиеНоменклатуры КАК КомплектующиеНоменклатуры
		|ГДЕ
		|	КомплектующиеНоменклатуры.Номенклатура В (&Список)
		|
		|СГРУППИРОВАТЬ ПО
		|	КомплектующиеНоменклатуры.Номенклатура.Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Номенклатура.Наименование,
		|	Номенклатура.Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Наименование В
		|			(ВЫБРАТЬ
		|				""A"" + НаССКомплектующими.Наименование КАК Наименование
		|			ИЗ
		|				НаССКомплектующими)";
	
	Запрос.УстановитьПараметр("Список", Список);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	Иначе
		Если Вопрос("Исправить список номенклатуры?", РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет, "Внимание!", КодВозвратаДиалога.Нет) = КодВозвратаДиалога.Да  Тогда 
 			ИсправитьСписокНоменклатуры(РезультатЗапроса.Выгрузить());
			Возврат;
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ИсправитьСписокНоменклатуры(ТЗИсправленнаяНоменклатура)
	// исправляет номенклатуру в документе
	// артикулы С.... заменяются на артикулы АС....
	Для каждого строка Из СсылкаНаОбъект.ИсходныеКомплектующие Цикл
		НоменклатураДокумента = Строка(строка.Номенклатура);
		строкаТЗ = ТЗИсправленнаяНоменклатура.Найти("A"+НоменклатураДокумента);
		строка.Номенклатура = ?(строкаТЗ = Неопределено, строка.Номенклатура, строкаТЗ.Ссылка);
	КонецЦикла;
КонецПроцедуры

//Функция ПроверкаВведеннойНоменклатуры(НаименованиеНом)
//	// Проверка артикулов изделий на "С", на наличие "клонов" с комплектующими на "А"
//	// Запуск от ТоварыПриВыводеСтроки()
//	Если НЕ ЭтоНовый() ИЛИ НЕ ДатаСозданияСчета>'20190707' Тогда Возврат Ложь; КонецЕсли;
//	Если СтрНайти(НаименованиеНом, "C")<>1 Тогда Возврат Ложь; КонецЕсли;

//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	КомплектующиеНоменклатуры.Номенклатура.Наименование КАК Наименование
//		|ИЗ
//		|	РегистрСведений.КомплектующиеНоменклатуры КАК КомплектующиеНоменклатуры
//		|ГДЕ
//		|	КомплектующиеНоменклатуры.Номенклатура.Наименование В
//		|			(ВЫБРАТЬ
//		|				Номенклатура.Наименование
//		|			ИЗ
//		|				Справочник.Номенклатура КАК Номенклатура
//		|			ГДЕ
//		|				Номенклатура.Наименование = ""A"" + &Номенклатура)";
//	Запрос.УстановитьПараметр("Номенклатура", НаименованиеНом);
//	РезультатЗапроса = Запрос.Выполнить();

//	Если НЕ РезультатЗапроса.Пустой() Тогда
//		Возврат Истина;
//	КонецЕсли;
//	
//	Возврат Ложь;
//КонецФункции