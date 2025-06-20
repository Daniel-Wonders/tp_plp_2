:- use_module(piezas).
%!sublista(+Descartar, +Tomar, +L, -R)
%Es reversible
sublista(Descartar, Tomar, Lista, Res) :- 
    append(Descarte1, Resto, Lista),
    length(Descarte1, Descartar), 
    append(Res, Descarte2, Resto),
    length(Res, Tomar).

%!length_aux(?K,?L).
    length_aux(K,L) :- length(L,K).

%!tablero(+K,-T)
    tablero(K,T) :- length(T,5), maplist(length_aux(K),T).

%!tamanio(+M,-F,-C)
tamanio(Matriz, CantFilas, CantColumnas) :- 
    last(Matriz, UltimaFila),           % Instanciamos una fila de la matriz
    length(Matriz, CantFilas),          % Sacamos la longitud de la matriz (Cant Filas)
    length(UltimaFila, CantColumnas).   % Sacamos la longitud de la fila (Cant Columnas)

%!coordenadas(+T,-IJ)
coordenadas(Matriz, (Fil,Col)) :- 
    tamanio(Matriz,CantFila,CantCol), 
    between(1, CantFila, Fil), 
    between(1, CantCol, Col).
          
%!memberAux(+P, ?Pieza)
memberAux(P, Pieza) :- member(Pieza, P).

%!estaOrdenado(?Lista, ?Res).
estaOrdenado(_,[]).
estaOrdenado([X|PS],[X|XS]) :- estaOrdenado(PS,XS).
estaOrdenado([_|PS],XS) :- estaOrdenado(PS,XS).

%k-piezas-para-consultar(+K, -PS)
%k-piezas-para-consultar(K, PS) :- 
    %nombrePiezas(P), 
    %length(PS,K), 
    %estaOrdenado(P,PS).

k-piezas(K, Res) :- 
    nombrePiezas(Piezas),
     setof(SolucionFiltrada, (estaOrdenado(Piezas, SolucionFiltrada), length(SolucionFiltrada, K)), ListaFiltrada), 
     member(Res, ListaFiltrada).

%!seccionTablero(+T,+ALTO, +ANCHO, +IJ, ?ST)
seccionTablero(_, 0, _, _, []). %Caso Base

%seccionTablero(Tablero, Alto, Ancho, (I,J), [X|XS]) :- 
%    nth1(I, Tablero, Fila), %Instancio Fila con una fila de Tablero, para calcular el ancho de la matriz.
%    length(Fila, Anchotablero), Descartar is Anchotablero - Ancho, %Instaciamos lo que vamos a descartar en la fila
%    sublista(Descartar, Ancho, Fila, X), %Instanciamos X como la seccion de la matriz que queremos buscar
%    I2 is I+1, %Avanzamos a la siguiente fila
%    Alto2 is Alto-1, %Resto al alto para hacer recursion
%    seccionTablero(Tablero, Alto2, Ancho, (I2,J), XS). %Recursion

seccionTablero(Tablero, Alto, Ancho, (I,J), XS) :-
    tablero(Ancho, XS2),
    tamanio(Tablero, AltoTotal, AnchoTotal),
    DescarteAncho is AnchoTotal - Ancho,
    maplist(sublista(DescarteAncho, Ancho), Tablero, XS2),
    DescarteAlto is AltoTotal - Alto,
    sublista(DescarteAlto,Alto,XS2,XS).
    
%No llegamos con el tiempo, porque pensamos que se entregaba el viernes 20/06 a las 3:59. 


%!ubicarPieza(+Tablero, +Identificador).
ubicarPieza(Tablero, Identificador) :- pieza(Identificador, ID), tamanio(ID, Fila, Colum), seccionTablero(Tablero, Fila, Colum, IJ, ID).

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
    k-piezas(Columnas, IDList), 
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

