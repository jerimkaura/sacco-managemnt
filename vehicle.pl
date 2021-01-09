read_data :-
    csv_read_file('vehicle_info.csv', Rows, [functor(vehicle), arity(5)]),
    maplist(assert, Rows).

save_data :-
    findall(row(ID,Reg,Manufacturer,Model,Year), vehicle(ID,Reg,Manufacturer,Model,Year), Rows),
    csv_write_file('vehicle_info.csv', Rows).

get_action(X) :-
    menu('Sacco Management Menu',
        [register_vehicle   : 'Register Vehicle',
         list_vehicles      : 'List Vehicles',
         delete_vehicle     : 'Delete Vehicle',
         quit               : 'Quit'], X).

menu_action(register_vehicle) :-
    format("\nEnter owner's ID:\n"),
    read(ID),
    format("Enter vehicle plate number:\n"),
    read(Reg),
    format("Enter vehicle manufacturer:\n"),
    read(Manufacturer),
    format("Enter vehicle model:\n"),
    read(Model),
    format("Enter vehicle year of manufacture:\n"),
    read(Year),
    assertz(vehicle(ID, Reg, Manufacturer, Model, Year)),
    save_data.

menu_action(list_vehicles) :-
    format("\n\nOwner\'s ID\tPlate No.\tManufacturer\tModel\tYear of Manufacture\n"),
    forall(vehicle(ID,Reg,Manufacturer,Model,Year),
    format("~w\t\t~w\t\t~w\t\t~w\t~w~n", [ID,Reg,Manufacturer,Model,Year])).

menu_action(delete_vehicle) :- 
    format("\nEnter vehicle's plate number:\n"),
    read(X),
    retract(vehicle(_,X,_,_,_)),
    format("Vehicle deleted successfully.\n"),
    save_data.

menu_action(quit) :-
    halt.

menu_loop :-
    get_action(X),
    menu_action(X),
    format("\nEnter c. to continue:\n"),
    read(_),
    menu_loop.

sacco :-
    retractall(vehicle),
    read_data,
    menu_loop.