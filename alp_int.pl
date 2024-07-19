/* ================================================================ */
/* ============== AN ABDUCTIVE PROOF PROCEDURE ==================== */
/* ================================================================ */
/* An abductive program is a triple <P,A,IC> where P is a normal    */
/* logic program, A is a set of abducible predicates and	    */
/* IC is a set of integrity constraints.			    */
/* Predicate symbols are declared as abducibles using the           */
/* predicate: "abducible_predicate" (eg. abducible_predicate(p). )  */
/* Abducibles must have no rules in the program.		    */
/* Integrity Constraints must be in the form of a denial with at    */
/* least one abducible condition, and must be written as rules      */
/* in the program in the form: 					    */
/* "ic:- conjunction of positive or negative literals."  	    */
/* All abducibles in the program must be ground at the time of call.*/
/* This procedure deals with NAF through Abduction.		    */
/* Negative conditions are written as not(p). 			    */
/* The semantics of NAF computed is that of partial stable models   */
/* (or equivalently preferred extensions).			    */
/* ================================================================ */
/* This abductive proof procedure runs in SICStus Prolog.	    */
/* A query is posed as: demo(List_of_Goals,[],Output_Variables).    */
/* ================================================================ */

/* ================================================================ */
/*              ABDUCTIVE PHASE                                     */
/* ================================================================ */


demo([],Exp,Exp).
demo(Goals,ExpSoFar,FinalExp) :-
    select_literal(Goals,SelectedLiteral,RestOfGoals),
    demo_one(SelectedLiteral,ExpSoFar,InterExp),
    demo(RestOfGoals,InterExp,FinalExp).

/* ============================================================ */

/* Positive non-abducible */
demo_one(SelectedLiteral,ExpSoFar,InterExp) :-
        is_positive(SelectedLiteral),
        \+ abducible(SelectedLiteral),
        clause_list(SelectedLiteral,Body),
        demo(Body,ExpSoFar,InterExp).

/* Positive Ground abducible which is already assumed */
demo_one(SelectedLiteral,ExpSoFar,InterExp) :-
        is_positive(SelectedLiteral),
	abducible(SelectedLiteral),
	ground(SelectedLiteral),
        in(SelectedLiteral,ExpSoFar),
        InterExp=ExpSoFar.

/* Negative Ground abducible or non-abducible which is already assumed */
demo_one(SelectedLiteral,ExpSoFar,InterExp) :-
        is_negative(SelectedLiteral),
	complement(SelectedLiteral,Complement),
        ground(Complement),
        in(SelectedLiteral,ExpSoFar),
        InterExp=ExpSoFar.

/* Negative Ground non-abducible */
demo_one(SelectedLiteral,ExpSoFar,InterExp) :-
        is_negative(SelectedLiteral),
	complement(SelectedLiteral,Complement),
	ground(Complement),
	\+ abducible(Complement),
	add_hypothesis(SelectedLiteral,ExpSoFar,InterExpSoFar),
        demo_failure_leaf([Complement],InterExpSoFar,InterExp).

/* Negative Ground abducible which is not assumed */
demo_one(SelectedLiteral,ExpSoFar,InterExp) :-
        is_negative(SelectedLiteral),
        complement(SelectedLiteral,Complement),
        ground(Complement),
	abducible(Complement),
	\+ in(Complement,ExpSoFar),
	add_hypothesis(SelectedLiteral,ExpSoFar,InterExp).

/* Positive Ground abducible which is not assumed */
demo_one(SelectedLiteral,ExpSoFar,InterExp) :-
        is_positive(SelectedLiteral),
        abducible(SelectedLiteral),
        ground(SelectedLiteral),
        \+ in(SelectedLiteral,ExpSoFar),
	complement(SelectedLiteral,Complement),
	\+ in(Complement,ExpSoFar),
        add_hypothesis(SelectedLiteral,ExpSoFar,InterExpSoFar),
	demo_fail_ICS(SelectedLiteral,InterExpSoFar,InterExp).


/* ================================================================ */
/*              CONSISTENCY PHASE				    */
/* ================================================================ */


demo_fail_ICS(Abducible,HypSoFar,NewHypSoFar) :-
    findall(IntConDenial,
            clause_list(ic,IntConDenial),
            ListOfIntConDenials),
    findall(OneResolventDenial,
            (in(OneConDenial,ListOfIntConDenials),
             resolve(Abducible,OneConDenial,OneResolventDenial)),
            ListOfResolventDenials),
    demo_failure(ListOfResolventDenials,HypSoFar,NewHypSoFar).

/* ============================================================ */

demo_failure([],HypSoFar,HypSoFar).
demo_failure(ListOfResolventDenials,HypSoFar,NewHypSoFar) :-
    select_first_denial(ListOfResolventDenials,SelectedDenial,RestOfDenials),
    \+ empty(SelectedDenial),
    demo_failure_leaf(SelectedDenial,HypSoFar,InterHyp),
    demo_failure(RestOfDenials,InterHyp,NewHypSoFar).

/* ============================================================ */

demo_failure_leaf(SelectedDenial,HypSoFar,InterHyp) :-
    select(SelectedDenial,SelectedLiteral,RestOfLiterals),
    demo_failure_on_literal(SelectedLiteral,RestOfLiterals,
                            HypSoFar,InterHyp).

/* ============================================================ */

/* Positive non-abducible */
demo_failure_on_literal(SelectedLiteral,RestOfLiterals,
                        HypSoFar,InterHyp) :-
    is_positive(SelectedLiteral),
    \+ abducible(SelectedLiteral),
    findall(OneNewConjunction,
            (clause_list(SelectedLiteral,Body),
             concat(Body,RestOfLiterals,OneNewConjunction)),
            ListOfNewConjunctions),
    demo_failure(ListOfNewConjunctions,HypSoFar,InterHyp).

/* Positive Ground abducible which is already assumed */
demo_failure_on_literal(SelectedLiteral,RestOfLiterals,
                        HypSoFar,InterHyp) :-
    is_positive(SelectedLiteral),
    abducible(SelectedLiteral),
    ground(SelectedLiteral),
    in(SelectedLiteral,HypSoFar),
    demo_failure([RestOfLiterals],HypSoFar,InterHyp).

/* Negative Ground abducible or non-abducible which is already assumed */
demo_failure_on_literal(SelectedLiteral,RestOfLiterals,
                        HypSoFar,InterHyp) :-
    is_negative(SelectedLiteral),
    complement(SelectedLiteral,Complement),
    ground(Complement),
    in(SelectedLiteral,HypSoFar),
    demo_failure([RestOfLiterals],HypSoFar,InterHyp).

/* Positive Ground abducible which is not assumed */
demo_failure_on_literal(SelectedLiteral,RestOfLiterals,
                        HypSoFar,InterHyp) :-
    is_positive(SelectedLiteral),
    abducible(SelectedLiteral),
    ground(SelectedLiteral),
    \+ in(SelectedLiteral,HypSoFar),
    complement(SelectedLiteral,Complement),
    add_hypothesis(Complement,HypSoFar,InterHyp).

/* Negative Ground abducible or non-abducible */
demo_failure_on_literal(SelectedLiteral,RestOfLiterals,
                        HypSoFar,InterHyp) :-
    is_negative(SelectedLiteral),
    complement(SelectedLiteral,Complement),
    ground(Complement),
    \+ in(SelectedLiteral,HypSoFar),
    demo([Complement],HypSoFar,InterHyp).



/* ============================================================ */
/*              LOW-LEVEL PREDICATES                            */
/* ============================================================ */

in(X,[X|Y]).
in(X,[Z|Y]):- in(X,Y).

concat([],L,L).
concat([X|L1],L2,[X|L3]) :- concat(L1,L2,L3).

select([X|Y],X,Y).
select([Z|Y],X,[Z|Rest]) :- select(Y,X,Rest).

select_literal([SelectedLiteral|RestOfLiterals],SelectedLiteral,RestOfLiterals).

select_first_denial([FirstDenial|RestDenials],FirstDenial,RestDenials).

abducible(Atom) :- get_predicate_name(Atom,PredicateName),
                   abducible_predicate(PredicateName).

get_predicate_name(Atom,PredicateName) :-
                        (Atom)=..[PredicateName|RestOfAtom].

clause_list(Head,[]) :-
												%prolog:current_predicate(_,Head),!,
                        catch(call(Head), _, fail).
clause_list(Head,Body) :-
                        clause(Head,Bod),
                        convert_to_list(Bod,Body).

convert_to_list((X,Y),[X|Z]) :- !, convert_to_list(Y,Z).
convert_to_list(true,[]):- !.
convert_to_list(X,[X]).

add_hypothesis(Hypothesis,ExpSoFar,[Hypothesis|ExpSoFar]).

empty([]).


resolve(Literal,[L1|ClauseList],ClauseList) :- Literal=L1.
resolve(Literal,[L1|ClauseList],[L1|Resolvent]) :-
                Literal \== L1,
                resolve(Literal,ClauseList,Resolvent).


complement(SelectedLiteral,Complement) :-
                SelectedLiteral= not(Complement), !.
complement(SelectedLiteral,Complement) :-
		Complement = not(SelectedLiteral).


is_positive(SelectedLiteral) :-
                \+ is_negative(SelectedLiteral).

is_negative(SelectedLiteral) :-
                SelectedLiteral= not(PositiveLiteral).



/* ========================================================== */
/* ========================================================== */


