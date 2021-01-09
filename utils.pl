:- module(utils, [get_time_str/1]).

% returns the value of 'key' in current date i.e. get_date_time_value(month, Value)
% returns Value = 12 in December
get_date_time_value(Key, Value) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(Key, DateTime, Value).

% returns a string timestamp in the form DD/MM/YYYY HH:TT
get_time_str(Timestamp) :-
    get_date_time_value(day, DD),
    get_date_time_value(month, MM),
    get_date_time_value(year, YYYY),
    get_date_time_value(hour, HH),
    get_date_time_value(minute, TT),
    format(string(Timestamp), "~w/~w/~w ~w:~w", [DD, MM, YYYY, HH, TT]).