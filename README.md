jsoncomparing
=============

Compare two JSON files (Etalon & Check)

Version 0.1

Как это работает?

На входе мы имеем эталонный JSON - с (теоретически) любой вложенностью
После первичной обработки - получаем "сокращённый" JSON - где для каждого поля описаны его возможные значения
К примеру firstName - "string" - значит, fistname в эталонном JSON-е всегда встречалось только как строка.
secondParam - ["number", "string"] - значит secondParam может быть как числом, так и строкой.

Берём проверяемый JSON. Первичная обработка (получаем "сокращённый" JSON). Далее производим сравнение с эталонным.
Если всё ок - отображаем как есть.
Если у проверяемого JSON-а поля принимают другие значения - значит выделяем "полужирным".

Красивого отображения не делал, но можно воспользоваться jsbeautifier.org - например.

В настоящий момент есть зависимость от underscore (_.isObject, _.isArray)
от jquery (загрузка, отображение)
от json - для отображения

How it works?

At first we have etalon JSON - with (teoreticaly) any deeps.
After first check we got "cut" JSON. Every key has array (or not) with any possibly type.
For example - firsName : "string". This means - in etalon JSON key firstName - was always string. Not number, not object.
For example secondParam: ["number", "string"] secondPara could be number or string

Now take a testJSON. After first turn - we got "cut" JSON wit list of possibly typeof.
NExt turn - we check - etalon cut JSON with tester cut JSON.

If "ok" - just show plain JSON.
If "bad" - we use "bold" for showing problem.

If you need more beauty - use jsbeautifier.org.

We have some dependens: underscore, jquery, json.
