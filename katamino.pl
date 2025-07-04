:- use_module(piezas).
%!sublista(+Descartar, +Tomar, +L, -R)
%Es reversible
sublista(Descartar, Tomar, Lista, Res) :- 
    append(Descarte1, Resto, Lista),
    length(Descarte1, Descartar), 
    append(Res, _, Resto),
    length(Res, Tomar).

%!lengthCompatiblesConMapList(?K,?L).
lengthCompatiblesConMapList(K,L) :- 
    length(L,K).

%!tablero(+K,-T)
tablero(K,T) :- 
    length(T,5), 
    maplist(lengthCompatiblesConMapList(K),T). %Aca hice correccion 7 (ver en readme)

%!tamanio(+M,-F,-C)
tamanio([Fila|Matriz], CantFilas, CantColumnas) :- 
    length([Fila|Matriz], CantFilas),    % Sacamos la longitud de la matriz (Cant Filas)
    length(Fila, CantColumnas).   % Sacamos la longitud de la fila (Cant Columnas)

%!coordenadas(+T,-IJ)
coordenadas(Matriz, (Fil,Col)) :- 
    tamanio(Matriz,CantFila,CantCol), 
    between(1, CantFila, Fil), 
    between(1, CantCol, Col).
          
%!estaOrdenado(?Lista, ?Res).
estaOrdenado(_,[]).
estaOrdenado([X|PS],[X|XS]) :- estaOrdenado(PS,XS).
estaOrdenado([_|PS],XS) :- estaOrdenado(PS,XS).

kPiezas(K, Res) :- 
    nombrePiezas(Piezas),
     setof(SolucionFiltrada, (estaOrdenado(Piezas, SolucionFiltrada), length(SolucionFiltrada, K)), ListaFiltrada), 
     member(Res, ListaFiltrada).

%!seccionTablero(+T,+ALTO, +ANCHO, +IJ, ?ST)
seccionTablero(Tablero, Alto, Ancho, (I,J), XS) :-
    DescarteAncho is J-1,
    DescarteAlto is I-1,
    maplist(sublista(DescarteAncho, Ancho), Tablero, TableroIntermedio),
    sublista(DescarteAlto,Alto,TableroIntermedio,XS).


%!ubicarPieza(+Tablero, +Identificador). 
ubicarPieza(Tablero, Identificador) :- 
    pieza(Identificador, ID), 
    tamanio(ID, AltoPieza, AnchoPieza),
    tamanio(Tablero, AltoTablero, AnchoTablero),
    between(1,AltoTablero,I),
    between(1,AnchoTablero,J),
    seccionTablero(Tablero, AltoPieza, AnchoPieza, (I, J), ID).

%!poda(+Poda, +Tablero)
poda(sinPoda, _). 
%poda(podaMod5, T) :- todosGruposLibresModulo5(T).



%!ubicarPiezas(+Tablero, +Poda, +Identificadores)
ubicarPiezas(_, _, []). 
ubicarPiezas(Tablero, Poda, Identificadores) :- 
    maplist(ubicarPieza(Tablero), Identificadores), 
    poda(Poda, Tablero).

%!llenarTablero(+Poda, +Columnas,-Tablero)
llenarTablero(Poda, Columnas, Tablero) :- 
    tablero(Columnas, Tablero), 
    kPiezas(Columnas, IDList), 
    ubicarPiezas(Tablero, Poda, IDList).



% 10: 
cantSoluciones(Poda, Columnas, N) :-
findall(T, llenarTablero(Poda, Columnas, T), TS),
length(TS, N).

% time(cantSoluciones(sinPoda, 3, N)). -> 8,926,330 inferences, 0.453 CPU in 0.456 seconds (99% CPU, 19699487 Lips), N = 28.
% time(cantSoluciones(sinPoda, 4, N)). -> 341,141,427 inferences, 17.516 CPU in 17.557 seconds (100% CPU, 19476406 Lips), N = 200.

todosGruposLibresModulo5(Tablero):-
    findall(IJ, (coordenadas(Tablero,IJ), estaLibre(Tablero, IJ)), CoordenadasLibres),
    agrupar(CoordenadasLibres, GrupoDeLibres),
    member(Grupo,GrupoDeLibres), 
    length(Grupo, X), 
    mod(X, 5) =:= 0.

%estaLibre(+Tab,?Res,?Cords)
estaLibre(Tab, (I,J)):-
    nth1(I,Tab,Fila),
    nth1(J,Fila,Elem),
    var(Elem).

