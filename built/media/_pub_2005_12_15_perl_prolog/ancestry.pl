is_father(Person)        :- is_parent(Person, _),
                            is_male(Person).
is_father(Person, Child) :- is_parent(Person, Child),
                            is_male(Person).

is_mother(Person)        :- is_parent(Person, _),
                            is_female(Person).
is_mother(Person, Child) :- is_parent(Person, Child),
                            is_female(Person).

grandparent(Person, Grandchild) :- is_parent(Person, Child), 
                                   is_parent(Child, Grandchild).
grandchild(Person, Grandparent) :- is_parent(_, Person),
                                   is_parent(Grandparent, _).
ancestor(Ancestor, Person) :- is_parent(Ancestor, Person).
ancestor(Ancestor, Person) :- is_parent(Ancestor, Child),
                              ancestor(Child, Person).

is_sibling(Person, Sibling) :- is_parent(X, Person),
                               is_parent(X, Sibling).

is_cousin(Person, Cousin) :- is_parent(X, Person),
                             is_parent(Y, Cousin),
                             is_sibling(X, Y).
                              




