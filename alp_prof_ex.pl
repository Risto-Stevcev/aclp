:- dynamic ic/0, rich/1, professor/1, has/2, happy/1.

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
