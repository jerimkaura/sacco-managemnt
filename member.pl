% SWI-Prolog implementation

:- module(member, [register_member/0,list_members/0,search_member/0,delete_member/0]).

:- use_module(library(persistency)).
:- use_module(vehicle).

% Use persistent library to save data persistently
:- persistent
    member(id:integer, fname:atom, lname:atom).

% File to save data in
:- db_attach('data/member.journal', []).

% Saves a Sacco Member to the database (and persistent journal file file)
save_member(ID, FName, LName) :-
    assert_member(ID, FName, LName).

% Read user input on member details and save it
register_member :-
    format("\nEnter member ID number:\n"),
    read(ID),
    format("Enter member's first name:\n"),
    read(FName),
    format("Enter member's  last name:\n"),
    read(LName),
    save_member(ID, FName, LName).

% Prints all members in the Sacco
list_members :-
    forall(member(ID, _, _), print_member(ID)).

% Read user-input ID, search for that member, and print their details
search_member :-
    format("\nEnter member's ID Number:\n"),
    read(ID),
    print_member(ID).

% Print member details
print_member(OwnerID) :-
    member(OwnerID, OwnerFName, OwnerLName),
    setof(RegNo, vehicle:vehicle(OwnerID, RegNo, _, _, _), Vehicles),
    format("\nMember ID: ~w\nName: ~w ~w\nVehicles Owned: ~w\n", [OwnerID, OwnerFName, OwnerLName, Vehicles]).

% Read user-input member ID, and delete that member
delete_member :-
    format("\nEnter member's ID Number:\n"),
    read(ID),
    retract_member(ID, _, _).