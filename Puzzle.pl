% "Logic Puzzle" 
% CECS 342

% Days mentioned in logic puzzle
day(tuesday).
day(wednesday).
day(thursday).
day(friday).

% Sightings that UFO enthusiats saw 
sighting(balloon).
sighting(clothesline).
sighting(frisbee).
sighting(watertower).

% Rule to figure out earlier day of the week 
earlier(X, wednesday):- X = tuesday.
earlier(X, thursday):- X = tuesday ; X = wednesday.
earlier(X, friday):- X = tuesday ; X = wednesday ; X = thursday. 

% Solve the puzzle
solve :-
    % Create a sighting associated with each person and make sure each one is different 
	sighting(BarradaSighting), sighting(GortSighting), sighting(KlatuSighting), sighting(NikitoSighting),
    all_different([BarradaSighting, GortSighting, KlatuSighting, NikitoSighting]),
    
    % Create a day associated with each person and make sure each one is different 
    day(BarradaDay), day(GortDay), day(KlatuDay), day(NikitoDay),
    all_different([BarradaDay, GortDay, KlatuDay, NikitoDay]),
    
    % Create a list of person, sighting, and day of sighting 
    Triples = [[barrada, BarradaSighting, BarradaDay],
               [gort, GortSighting, GortDay],
               [klatu, KlatuSighting, KlatuDay],
               [nikito, NikitoSighting, NikitoDay]],
				
	% 1. Mr. Klatu made his sighting at some point earlier in the week than the one who
	% saw the balloon, but at some point later in the week than the one who spotted the 
	% Frisbee (who isn't Ms. Gort).
    
    % Klatu didn't see the frisbee 
    \+ member([klatu, frisbee, _], Triples),
    
    % Klatu also did not see the balloon 
    \+ member([klatu, balloon, _], Triples),
    
    % The person who saw the frisbee is not Gort 
    \+ member([gort, frisbee, _], Triples),
    
    % Klatu saw his sighting before the balloon sighting which means it could have been seen by 
    % Barrada, Nikito, or Gort
   ( earlier(KlatuDay, GortDay), GortSighting = balloon ; 
    earlier(KlatuDay, NikitoDay), NikitoSighting = balloon ; 
    earlier(KlatuDay, BarradaDay), BarradaSighting = balloon ),
    
    % Klatu saw his sighting after the frisbee sighting which could have been seen by Barrada or Nikto
    ( earlier(BarradaDay, KlatuDay), BarradaSighting = frisbee ; 
    earlier(NikitoDay, KlatuDay), NikitoSighting = frisbee ),
    
    
    % 2. Friday's sighting was made by either Ms. Barrada or the one who saw the clothesline (or both)
    ( member([_, clothesline, friday], Triples);
    member([barrada, _, friday], Triples);
    member([barrada, clothesline, friday], Triples)),
    
    % 3. Mr. Nikito did not make his sighting on Tuesday
    \+ member([nikito, _, tuesday], Triples),
    
    % 4. Mr. Klatu isn't the one whose object turned out to be a water tower
    \+ member([klatu, watertower, _], Triples),
    
    % Display results of solve
    tell(barrada, BarradaSighting, BarradaDay),
    tell(gort, GortSighting, GortDay),
    tell(klatu, KlatuSighting, KlatuDay),
    tell(nikito, NikitoSighting, NikitoDay).

% Succeed if all elements of the argument list are bound and different.
% Fail if any elements are unbound or equal to some other element.
all_different([H | T]) :- member(H, T), !, fail.        % (1)
all_different([_ | T]) :- all_different(T).             % (2)
all_different([_]).                                     % (3)
    
% Write out an English sentence with the solution.
tell(X, Y, Z) :-
    write(X), write(' saw a '), write(Y),
    write(' on '), write(Z), write('.'), nl.
    
    
    
