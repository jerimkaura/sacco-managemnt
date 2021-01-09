% SWI-Prolog implementation

:- module(finance, [contribute_shares/0,loan_repayment/0,request_loan/0]).

:- use_module(library(persistency)).
:- use_module(utils).

:- persistent
    contribution(id:integer, contribution_amt:integer, total:integer, date_contributed:string),
    loan(member:integer, principle:integer, years:integer, outstanding, type:integer, date_requested:string).

:- db_attach('data/finance.journal', []).

request_loan :-
    format("\nEnter the member id:\n"), 
    read(Member),
    current_member_shares(Member, Shares), Previous is Shares,
    format("\nThe current Shares owned by that Member is: ~w\n", [Shares]),
    format("\nRequested loan amount:\n"),
    read(Principle),
    format("\nTime in years to repay:\n"),
    read(Years),
    Limit is Previous * 5,
    find_loans(Member, Outstanding), New_Limit is Limit - Outstanding,

    approve_loan(Member, Previous, New_Limit, Principle, Years).
    

approve_loan(_,Shares, _, _, _):-
    Shares < 1,
    format("\n\nThis member has zero shares, Sacco automatically rejects request.").

approve_loan(_,_, Limit, Principle, _):-
    Principle > Limit,
    nl, nl, format("The requested amount is past the limit for that member of(5 times the shares): ~w", [Limit]).

% this is what will be executed when the loan request is valid
approve_loan(Member, _, _, Principle, Years):-
    compound(Principle, Years, Amount), Outstanding is Amount, 
    get_time_str(Daterequested),
    Type is 0,
    assert_loan(Member, Principle, Years, Outstanding, Type, Daterequested).

loan_repayment :-
    format("\nEnter the member id:\n"),
    read(Member),
    find_loans(Member, Outstanding),
    format("\nEnter the amount you want to repay (as a float i.e. 2.0):\n"),
    read(Repayment),
    New_Outstanding is Outstanding - Repayment,
    get_time_str(Daterequested),
    Type is 1,
    assert_loan(Member, Repayment, 0, New_Outstanding, Type, Daterequested).


contribute_shares :-
    format("\nEnter the member id:\n"),
    read(Member),
    current_member_shares(Member, Shares), Previous is Shares,
    format("The member's previous total shares was: ~w\n", [Shares]),
    format("Enter the recent contribution:\n"),
    read(Contribution),
    Total is Previous + Contribution,
    get_time_str(DateContributed),
    assert_contribution(Member, Contribution, Total, DateContributed),
    format("Contribution recorded successfully.\n").


find_loans(Member, Remaining):-
    findall(Outstanding, loan(Member, _, _, Outstanding, _, _), Total),
    format("\nList of Loan Progression: ~w", [Total]),
    format("\nEnter the last Outstanding Loan amount:\n"),
    read(Remaining).

current_member_shares(Member, Shares):-
    findall(C, contribution(Member, _, C, _), Total),
    format("\nShares Contribution List: ~w\n", [Total]),
    format("Enter the last Total Shares:\n"),
    read(Shares).
 
compound(P, T, Total):-
	amount(P, T, Amount), Total is Amount.

amount(P, T, Amount):-
	I is 0.2 / 12,
	E is 12 * T,
	Total is (I + 1) ^ E,
	Amount is Total * P.