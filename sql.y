%{
#include <stdio.h>
#include <string.h>
extern int yylex(void);
void yyerror(const char *s);

int error_occurred = 0;
int attribute_count = 0;  // Compteur pour les attributs (pas affiché)
int column_count = 0;     // Compteur pour les colonnes (INSERT, CREATE)
int value_count = 0;      // Compteur pour les valeurs dans INSERT
%}

%token ID NOMBRE STRING SELECT FROM DISTINCT WHERE AND GROUP HAVING ORDER DESC SUM AVG MAX MIN EGAL SUP
%token DELETE INSERT INTO VALUES UPDATE SET CREATE TABLE INT VARCHAR BY

%left AND
%left EGAL SUP

%%
input           : liste_requetes end_of_input
                ;

liste_requetes  : liste_requetes requete
                | requete
                | /* vide */
                ;

requete         : selection ';' { 
                    // N'affiche plus le nombre d'attributs
                    if (!error_occurred) 
                        printf("REQUETE ACCEPTEE: SELECT\n"); 
                    error_occurred = 0; attribute_count = 0; column_count = 0; value_count = 0;
                }
                | deletion ';' { 
                    // N'affiche plus le nombre d'attributs
                    if (!error_occurred) 
                        printf("REQUETE ACCEPTEE: DELETE\n"); 
                    error_occurred = 0; attribute_count = 0; column_count = 0; value_count = 0; 
                }
                | insertion ';' { 
                    // Vérifie si le nombre de colonnes correspond au nombre de valeurs dans INSERT
                    if (!error_occurred) {
                        if (column_count > 0 && column_count != value_count) {
                            printf("Erreur: Le nombre de colonnes (%d) ne correspond pas au nombre de valeurs (%d)\n", column_count, value_count);
                            error_occurred = 1;
                        } else {
                            printf("REQUETE ACCEPTEE: INSERT (Nombre de colonnes: %d)\n", column_count != 0 ? column_count : value_count); 
                        }
                    }
                    error_occurred = 0; attribute_count = 0; column_count = 0; value_count = 0;
                }
                | update ';' { 
                    // N'affiche plus le nombre d'attributs
                    if (!error_occurred) 
                        printf("REQUETE ACCEPTEE: UPDATE\n"); 
                    error_occurred = 0; attribute_count = 0; column_count = 0; value_count = 0;
                }
                | creation ';' { 
                    // Conserve l'affichage du nombre de colonnes pour CREATE
                    if (!error_occurred) 
                        printf("REQUETE ACCEPTEE: CREATE (Nombre de colonnes: %d)\n", column_count); 
                    error_occurred = 0; attribute_count = 0; column_count = 0; value_count = 0;
                }
                | error ';' { 
                    // Gère les erreurs de syntaxe générales
                    yyerror("Syntaxe de requête invalide"); 
                    error_occurred = 0; attribute_count = 0; column_count = 0; value_count = 0;
                }
                ;

end_of_input    : /* vide */
                | error { yyerror("Caractères invalides après la requête"); }
                ;

selection       : SELECT liste_attributs FROM liste_tables clauses
                | SELECT DISTINCT liste_attributs FROM liste_tables clauses
                ;

deletion        : DELETE FROM ID clauses
                | DELETE FROM error { yyerror("Erreur dans la table de DELETE"); }
                ;

insertion       : INSERT INTO ID insertion_columns VALUES '(' liste_valeurs_explicit ')'
                | INSERT INTO ID VALUES '(' liste_valeurs_implicit ')'
                | INSERT INTO error { yyerror("Erreur dans la table de INSERT"); }
                ;

insertion_columns   : '(' liste_colonnes_insertion ')'
                    ;

liste_colonnes_insertion : ID { column_count++; } // Compte les colonnes spécifiées dans INSERT
                         | ID ',' liste_colonnes_insertion { column_count++; }
                         | error { yyerror("Erreur dans la liste des colonnes"); }
                         ;

liste_valeurs_explicit : valeur { value_count++; } // Compte les valeurs explicites dans INSERT
                       | valeur ',' liste_valeurs_explicit { value_count++; }
                       ;

liste_valeurs_implicit : valeur { column_count++; value_count++; } // Compte colonnes et valeurs implicites
                       | valeur ',' liste_valeurs_implicit { column_count++; value_count++; }
                       ;

update          : UPDATE ID SET liste_assignations clauses
                | UPDATE error { yyerror("Erreur dans la table de UPDATE"); }
                ;

liste_assignations  : assignation
                    | assignation ',' liste_assignations
                    | error { yyerror("Erreur dans les assignations de UPDATE"); }
                    ;

assignation     : ID EGAL valeur { attribute_count++; } // Compte les attributs dans UPDATE
                ;

creation        : CREATE TABLE ID '(' liste_colonnes ')'
                ;

liste_colonnes  : colonne
                | colonne ',' liste_colonnes
                ;

colonne         : ID type { column_count++; } // Compte les colonnes dans CREATE TABLE
                | ID error { yyerror("Erreur : type de colonne manquant"); }
                ;

type            : INT
                | VARCHAR
                ;

clauses         : WHERE condition autres_clauses
                | autres_clauses
                | error { yyerror("Erreur dans les clauses (WHERE, GROUP, HAVING, ORDER)"); }
                ;

autres_clauses  : GROUP liste_attributs suite_clauses // Gère GROUP BY
                | suite_clauses
                ;

suite_clauses   : HAVING condition fin_clauses // Gère HAVING
                | fin_clauses
                ;

fin_clauses     : ORDER liste_attributs tri // Gère ORDER BY
                |
                ;

tri             : DESC
                |
                ;

condition       : condition AND condition
                | '(' condition ')'
                | comparaison
                | error { yyerror("Erreur dans la condition (WHERE ou HAVING)"); }
                ;

comparaison     : valeur EGAL valeur
                | valeur SUP valeur
                | fonction SUP valeur
                | fonction EGAL valeur
                ;

valeur          : ID
                | NOMBRE
                | STRING
                ;

fonction        : SUM '(' ID ')' // Gère les fonctions d'agrégation
                | AVG '(' ID ')' // Fonction AVG
                | MIN '(' ID ')' // Fonction MIN
                | MAX '(' ID ')' // Fonction MAX
                ;

liste_attributs : attribut { attribute_count = 1; } // Premier attribut (pas affiché)
                | liste_attributs ',' attribut { attribute_count++; } // Attributs supplémentaires (pas affichés)
                | error { yyerror("Erreur dans la liste des attributs"); }
                ;

attribut        : ID // Un attribut simple (colonne)
                | fonction // Une fonction d'agrégation
                ;

liste_tables    : ID
                | ID ',' liste_tables
                | error { yyerror("Erreur dans la liste des tables"); }
                ;
%%

void yyerror(const char *s) {
    printf("%s\n", s); // Affiche un message d'erreur
    error_occurred = 1; // Indique qu'une erreur s'est produite
}

int main(void) {
    yyparse(); // Lance l'analyse syntaxique
    return 0;
}