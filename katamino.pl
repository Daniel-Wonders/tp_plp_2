:- use_module(piezas).
%sublista(+Descartar, +Tomar, +L, -R)
sublista(Descartar, Tomar, Lista, Res) :- 
    length(Descarte1, Descartar), 
    append(Descarte1, Resto, Lista), 
    length(Res, Tomar), 
    append(Res, Descarte2, Resto). %<------

% Completar ...
%luca(X) :-  jero(X).
%=======

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
          
%memberAux(+P, ?Pieza)
memberAux(P, Pieza) :- member(Pieza, P).

%estaOrdenado(?Lista, ?Res).
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

seccionTablero(Tablero, 0, Ancho, CoordenadaInicial, []). %Caso Base

seccionTablero(Tablero, Alto, Ancho, (I,J), [X|XS]) :- 
    nth1(I, Tablero, Fila), %Instancio Fila con una fila de Tablero, para calcular el ancho de la matriz.
    length(Fila, Anchotablero), Descartar is Anchotablero - Ancho, %Instaciamos lo que vamos a descartar en la fila
    sublista(Descartar, Ancho, Fila, X), %Instanciamos X como la seccion de la matriz que queremos buscar
    I2 is I+1, %Avanzamos a la siguiente fila
    Alto2 is Alto-1, %Resto al alto para hacer recursion
    seccionTablero(Tablero, Alto2, Ancho, (I2,J), XS). %Recursion

    tablero(3, T), pieza(e, E), tama~no(E, F, C), seccionTablero(T, F, C, (1,1), E), mostrar(T).

