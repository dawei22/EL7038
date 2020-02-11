function y = precalificador(R,BH,i,beta)
aux = 1;
for l=1:length(BH)
    for m=1:length(R(i).premisa)
        if strcmp(R(i).premisa(m),BH(l).hecho)
            if BH(l).vc < beta 
                aux = 0;
                break;
            end
        end
    end
end
y = aux;