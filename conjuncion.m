function y = conjuncion(V)
minimo = min(abs(V));
aux = find(V==-minimo,1);
if aux ~=0
    y = V(aux);
else
    y = minimo;
end

