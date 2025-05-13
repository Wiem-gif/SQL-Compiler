%{
#include <stdio.h>
#include "y.tab.h"
%}

lettre [A-Za-z]
chiffre [0-9]
string \'[^\']*\'

%%
[ \t\n]         ;
--[^\n]*\n      ;
"select"        return SELECT;
"from"          return FROM;
"distinct"      return DISTINCT;
"where"         return WHERE;
"and"           return AND;
"group by"      return GROUP;
"having"        return HAVING;
"order by"      return ORDER;
"desc"          return DESC;
"sum"           return SUM;
"avg"           return AVG;
"min"           return MIN;
"max"           return MAX;
"delete"        return DELETE;
"insert"        return INSERT;
"into"          return INTO;
"values"        return VALUES;
"update"        return UPDATE;
"set"           return SET;
"create"        return CREATE;
"table"         return TABLE;
"int"           return INT;
"varchar"       return VARCHAR;
"="             return EGAL;
">"             return SUP;
{lettre}({lettre}|{chiffre})* return ID;
{chiffre}+      return NOMBRE;
{string}        return STRING;
[,;()*]         return yytext[0];
.               return yytext[0];
%%

int yywrap() {
    return 1;
}