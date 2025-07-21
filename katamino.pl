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
sublistasOrdenadas(_,[]).
sublistasOrdenadas([X|PS],[X|XS]) :- sublistasOrdenadas(PS,XS).
sublistasOrdenadas([_|PS],XS) :- sublistasOrdenadas(PS,XS).

%!kPiezas(+K, -PS)
kPiezas(K, Res) :- 
    nombrePiezas(Piezas), 
    setof(SolucionFiltrada, (sublistasOrdenadas(Piezas, SolucionFiltrada), length(SolucionFiltrada, K)), ListaFiltrada), 
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
poda(podaMod5, T) :- todosGruposLibresModulo5(T).



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

% time(cantSoluciones(sinPoda, 3, N)). 54,978,023 inferences, 3.734 CPU in 3.747 seconds (100% CPU, 14722148 Lips) --> N = 28.
% time(cantSoluciones(sinPoda, 4, N)). 2,997,509,413 inferences, 178.625 CPU in 179.485 seconds (100% CPU, 16781018 Lips) --> N = 200.

%11
todosGruposLibresModulo5(Tablero) :-
    findall((I,J), (coordenadas(Tablero,(I,J)), estaLibre(Tablero,(I,J))), CoordenadasLibres),
    agrupar(CoordenadasLibres, GruposDeLibres),
    forall(member(Grupo, GruposDeLibres), (length(Grupo, Len), 0 is Len mod 5)).


%estaLibre(+Tab,?Res,?Cords)
estaLibre(Tab, (I,J)):-
    nth1(I,Tab,Fila),
    nth1(J,Fila,Elem),
    var(Elem).

% time(cantSoluciones(podaMod5, 3, N)). 54,982,053 inferences, 3.842 CPU in 3.842 seconds (100% CPU, 14310473 Lips) --> N = 28.
% time(cantSoluciones(podaMod5, 4, N)). 2,997,475,470 inferences, 211.116 CPU in 211.133 seconds (100% CPU, 14198264 Lips) --> N = 200.

/*
Predicado original:
sublista(+Descartar, +Tomar, +Lista, -Res) :- 
    append(Descarte1, Resto, Lista),
    length(Descarte1, Descartar), 
    append(Res, _, Resto),
    length(Res, Tomar).
    
QVQ: (-Descartar, +Tomar, +L, +R).
Para ver estaticamente si el predicado es reversible con el patron de instanciacion
(-Descartar, +Tomar, +Lista, +Res) tenemos que ver la reversibilidad de los predicados internos.
    append(-Descarte1, -Resto, +Lista), <- Esto es posible, va a instanciar en Decarte1 y Resto las posibles particiones de Lista
    length(+Descarte1, -Descartar), <- Esto es posible, va a generar el largo de una de las particiones en Descartar
    append(+Res, _, +Resto), <- Esto tambien es valido
    length(+Res, +Tomar). <- Tambien valido, pido que el largo de Res se Tomar
*/