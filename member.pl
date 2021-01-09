read_members :-
    csv_read_file('members.csv', Rows, [functor(vehicle), arity(5)]),
    maplist(assert, Rows).

add_member:-
    findall(row(ID, FNAME, LNAME,SHARES,LOAN_STATUS),    member(ID, FNAME, LNAME, SHARES, LOAN_STATUS), Rows),
    csv_write_file('members.csv', Rows).

register_member:-
    format("\nEnter member ID Number:\n"),
    read(ID),
    format("Enter Member's Fisrt Name:\n"),
    read(FNAME),
    format("Enter Member's  Last Name:\n"),
    read(LNAME),
    format("Enter Member's shares count:\n"),
    read(SHARES),
    LOAN_STATUS is 400,
    assertz(member(ID, FNAME, LNAME,SHARES, LOAN_STATUS)),
    add_member.

show_members:-
    format("\n\nID_NUMBER\tFIRST_NAME.\tLAST_NAME\tSHARES\tLOAN_STATUS\n"),
    forall(member(ID, FNAME, LNAME,SHARES, LOAN_STATUS),
    format("~w\t\t~w\t\t~w\t\t~w\t~w~n", [ID, FNAME, LNAME,SHARES, LOAN_STATUS])).


search_member:-
    format("\nEnter member's ID Number:\n"),
    read(X),
    format("\n\nID_NUMBER\tFIRST_NAME.\tLAST_NAME\tSHARES\tLOAN_STATUS\n"),
    forall(member(X, FNAME, LNAME,SHARES, LOAN_STATUS),
    format("~w\t\t~w\t\t~w\t\t~w\t~w~n", [X, FNAME, LNAME,SHARES, LOAN_STATUS])).

members_with_loans:-
    format("\n\nID_NUMBER\tFIRST_NAME.\tLAST_NAME\tSHARES\tLOAN_STATUS\n"),
    forall(member(ID, FNAME, LNAME,SHARES, X) X is > 1,
    format("~w\t\t~w\t\t~w\t\t~w\t~w~n", [ID, FNAME, LNAME,SHARES, LOAN_STATUS])).



