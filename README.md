# ACLP

Abductive Constraint Logic Programming

A single-file abduction system for prolog. Doesn't need/use CHR for abduction.

## Examples

Tested with SWI, Trealla, Scryer, and Tau:

```
?- [alp_int].
Warning: singleton: RestOfLiterals, near alp_int:160
Warning: singleton: RestOfLiterals, near alp_int:169
Warning: singleton: Y, near alp_int:177
Warning: singleton: Z, near alp_int:178
   true.
?- [alp_prof_ex].
   true.
?- demo([professor(henning)], [], FinalExp).
   FinalExp = [not(rich(henning)),professor(henning)]
;  false.
?- demo([happy(henning)], [], FinalExp).
   FinalExp = [not(professor(henning)),rich(henning)]
;  FinalExp = [has(henning,nice_students),not(rich(henning)),professor(henning)]
;  false.
```

See more examples in `alp_exp.pl`.

## Notes

- Integrity constraints (`ic`) tell the abductive system what can't be true. For
example, in `alp_prof_ex`, you can't have a rich professor.
- Abducibles tell the abductive system how to think about facts that it's seeing
for the first time (open world). For example, in EX3 of `alp_exp`, if you ask
about a new bird that isn't `tweety` or `sam`, then the system will say that
this new bird is either `slim` or `bird_ab`. Abducibles represent [default
logic](https://en.m.wikipedia.org/wiki/Default_logic).

## References

- [Website](https://www.cs.ucy.ac.cy/aclp/)  
- [Abduction and language processing with CHR](https://met.guc.edu.eg/CHR2013/Material/abduction.pdf)
