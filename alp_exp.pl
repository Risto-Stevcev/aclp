/* ************************** EX1 ********************************* */
/* This is a  simple example with NAF through abduction.            */
/* Try this example with the following goals (G1 and G2):           */
/* G1: demo([flies(tweety)],[],FinalExp).                           */
/* G2: demo([flies(sam)],[],FinalExp).                              */
/* Note here that only the second goal (G2) succeeds.               */
/* **************************************************************** */

:- dynamic flies/1,abnormal/1,bird/1,penguin/1,eagle/1.


flies(X) :- bird(X), not(abnormal(X)).

abnormal(X) :- penguin(X).

bird(X) :- penguin(X).
bird(X) :- eagle(X).

penguin(tweety).
eagle(sam).


/* Abducibles */

/* We don't define any abducibles */
abducible_predicate(none).


/* ************************** EX2 ********************************* */
/* This is an example with NAF through abduction.                   */
/* Try this example with the following goals (G1 and G2):           */
/* G1: demo([flies(sam)],[],FinalExp).                              */
/* G2: demo([not(flies(sam))],[],FinalExp).                         */
/* **************************************************************** */

:- dynamic flies/1,abnormal/1,light/1,heavy/1,bird/1,penguin/1,eagle/1.


flies(X) :- bird(X), not(abnormal(X)).

abnormal(X) :- penguin(X).
abnormal(X) :- not(light(X)).

light(X) :- not(heavy(X)).

heavy(X) :- not(light(X)).

bird(X) :- penguin(X).
bird(X) :- eagle(X).

penguin(tweety).
eagle(sam).


/* Abducibles */

/* We don't define any abducibles */
abducible_predicate(none).


/* ************************** EX3 ********************************* */
/* This is an example with NAF through abduction and                */
/* other abducibles (no integrity constraints).                     */
/* We assume here that our knowledge about birds is incomplete      */
/* and so we define a new abducible "bird_ab(X)" which states       */
/* that X is a bird. Also "slim" is an abducible predicate.         */
/* Try this example with the following goals (G1, G2 and G3):       */
/* G1: demo([flies(tweety)],[],FinalExp).                           */
/* G2: demo([flies(sam)],[],FinalExp).                              */
/* G3: demo([flies(john)],[],FinalExp).                             */
/* Note that now only the first goal (G1) fails.                    */
/* Note also that the second goal (G2) now has two explanations.    */
/* **************************************************************** */

:- dynamic flies/1,abnormal/1,heavy/1,light/1,bird/1,penguin/1,eagle/1.


flies(X) :- bird(X), not(abnormal(X)).

abnormal(X) :- penguin(X).
abnormal(X) :- heavy(X).

heavy(X) :- not(light(X)).

light(X) :- slim(X).

bird(X) :- penguin(X).
bird(X) :- eagle(X).
bird(X) :- bird_ab(X).

penguin(tweety).
eagle(sam).


/* Abducibles */

abducible_predicate(bird_ab).
abducible_predicate(slim).


/* ************************** EX4 ********************************* */
/* This is an example with abducibles and integrity constraints.    */
/* Try this example with the following goals (G1 and G2):           */
/* G1: demo([car_doesnt_start(mycar)],[],FinalExp).                 */
/* G2: demo([car_doesnt_start(yourcar)],[],FinalExp).               */
/* Note that there are two alternative explanations for G2.         */
/* **************************************************************** */

:- dynamic ic/0,car_doesnt_start/1,lights_go_on/1,fuel_indicator_empty/1.


car_doesnt_start(X) :- battery_flat(X).
car_doesnt_start(X) :- has_no_fuel(X).


lights_go_on(mycar).
fuel_indicator_empty(mycar).


/* Integrity Constraints */

ic :- battery_flat(X), lights_go_on(X).

ic :- has_no_fuel(X), not(fuel_indicator_empty(X)), not(broken_indicator(X)).

/* This second constraint is equivalent to : */
/* fuel_indicator_empty(X):- has_no_fuel(X), not(broken_indicator(X)). */
/* written as a denial. */


/* Abducibles */

abducible_predicate(battery_flat).
abducible_predicate(has_no_fuel).
abducible_predicate(broken_indicator).



