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
seccionTablero(_, 0, _, _, []).
seccionTablero(Tablero, Alto, Ancho, (I,J), [X|XS]) :- 
    length(Tablero, Altotablero),
    nth1(I, Tablero, Fila),
    length(Fila, Anchotablero),
    
    LimiteLateral is Anchotablero - Ancho, 
    LimiteVertical is Altotablero - Alto + 1, 

    between(0,LimiteLateral,J),
    between(0,LimiteVertical,I),

    sublista(J, Ancho, Fila, X), 
    I2 is I+1, 
    Alto2 is Alto-1,
    seccionTablero(Tablero, Alto2, Ancho, (I2,J), XS).




%ubicarPieza(+Tablero, +Identificador).
ubicarPieza(Tablero, Identificador) :- pieza(Identificador, ID), tamanio(ID, Fila, Colum), seccionTablero(Tablero, Fila, Colum, IJ, ID).

%poda(+Poda, +Tablero)
poda(sinPoda, _). 


%ubicarPiezas(+Tablero, +Poda, +Identificadores)
ubicarPiezas(_, _, []). 
ubicarPiezas(Tablero, Poda, Identificadores) :- 
    maplist(ubicarPieza(Tablero), Identificadores), 
    poda(Poda, Tablero).

%llenarTablero(+Poda, +Columnas,-Tablero)
llenarTablero(Poda, Columnas, Tablero) :- 
    tablero(Columnas, Tablero), 
    k-piezas(Columnas, IDList), 
    ubicarPiezas(Tablero, Poda, IDList).