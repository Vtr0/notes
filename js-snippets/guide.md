# HELP

This folder contains javascript files that can add to Chrome, Coccoc developer tools' Snippet part of Sources tab.

## bookCharset.js

Function `fixBookCharSet(_book)` is used to fix charset for a book in my Audio Book webapp. the `_book` parameter should be the object (or json) of ONE book

Function `fixCharSet(bookVar)` is used to fix charset for all books inside a book variables

There are also some handy function such as `titleCase(str)`, `properCase(str)` to convert a string to corresponding text case

## makeBookIds.js
used to create 10 unique book ids for Audio Book webapp database.

## toHHMMSS.js
contain `toHhMmSs(sec)` to conver from number of seconds (integer) into string of format `H:mm:ss`

## split_nhattruyen
Some function to make DB from a json get from nhattruyen. You have to read the code to know what it does, remove this file if you want