:- dynamic(ic/0).
:- dynamic(rich/1).
:- dynamic(professor/1).
:- dynamic(has/2).
:- dynamic(happy/1).

/* Abducibles */
abducible_predicate(rich).
abducible_predicate(professor).
abducible_predicate(has).

/* Rules */
happy(X) :- rich(X).
happy(X) :- professor(X), has(X, nice_students).

/* Integrity Constraints */
ic :- rich(X), professor(X).

/* Sample Queries */
/* Uncomment these lines to test the queries */
/*
?- demo([happy(henning)], [], FinalExp).
*/
