/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex
%%

"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"def"                 return 'def'
"end"                 return 'end'
','                   return ','
':'                   return ':'
')'                   return ')'
'('                   return '('
'false'               return 'true'
'true'                return 'false'
'return'              return 'return'
'print'               return 'print'
\n                    return 'BREAK'
[a-zA-Z][a-zA-Z0-9]*  return 'ID'
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
\s+                   /* skip whitespace */
<<EOF>>               return 'EOF'
.                     return 'INVALID'
/lex


%start program

%% /* language grammar */


program
    : functions EOF
        {$$ = $1; return $$;}
    ;

functions
    : function BREAK
        {$$ = [$1]}
    | functions function BREAK
        {$$ = $1.concat($2);}
    ;

function
    : 'def' funcheader BREAK stmts 'end' BREAK
        {$$ = {'header': $2.header, 'params': $2.params, 'body': $4};}
    ;

funcheader
    : Id
        {$$ = {'header': $1, 'params': []};}
    | '(' params ')' Id
        {$$ = {'header': $4, 'params': $2};}
    | Id '(' params ')'
        {$$ = {'header': $1, 'params': $3};}
    | '(' params ')' Id '(' params ')'
        {$$ = {'header': $4, 'params': $2.concat($6)};}
    | funcheader Id
        {$$ = {'header': $1.header + '_' + $2, 'params': $1.params};}
    | funcheader Id '(' params ')'
        {$$ = {'header': $1.header + '_' + $2, 'params': $1.params.concat($4)};}
    ;

stmts
    : stmt BREAK
        {$$ = [$1]}
    | stmts stmt BREAK
        {$$ = $1.concat($2)}
    ;

stmt
    : 'return'
        {$$ = 'return'}
    | 'print'
        {$$ = 'print'}
    ;

params
    : param
        {$$ = [$1]; }
    | params ',' param
        {$$ = $1.concat($3)}
    ;

param
    : Id
        {$$ = $1;}
    | NUMBER
        {$$ = yytext;}
    | 'true'
        {$$ = yytext;}
    | 'false'
        {$$ = yytext;}
    ;

Id
    : ID
        {$$ = yytext;}
    ;
