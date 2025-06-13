:- use_module(piezas).
%sublista(+Descartar, +Tomar, +L, -R)
sublista(Descartar, Tomar, Lista, Res) :- 
    length(Descarte1, Descartar), 
    append(Descarte1, Resto, Lista), 
    length(Res, Tomar), 
    append(Res, Descarte2, Resto).

% Completar ...
luca(X) :-  jero(X).
=======

%length_aux(?K,?L).
    length_aux(K,L) :- length(L,K).

%tablero(+K,-T)
    tablero(K,T) :- length(T,5), maplist(length_aux(K),T).

%tamanio(+M,-F,-C)
tamanio(Matriz, CantFilas, CantColumnas) :- 
    last(Matriz, UltimaFila),           % Instanciamos una fila de la matriz
    length(Matriz, CantFilas),          % Sacamos la longitud de la matriz (Cant Filas)
    length(UltimaFila, CantColumnas).   % Sacamos la longitud de la fila (Cant Columnas)

%coordenadas(+T,-IJ)
coordenadas(Matriz, (Fil,Col)) :- 
    tamanio(Matriz,CantFila,CantCol), 
    between(1, CantFila, Fil), 
    between(1, CantCol, Col).
