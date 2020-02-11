function [y, BH2] = certeza(x,R,BH)
beta = 0.2;  %parametros de control
epsilon = 0.5;
gamma = 0.85;
encontrado = 0;
incerteza = 0;
AUXvc = 0;
for i=1:length(BH) %verifico si lo que busco esta en la base de hechos
    if strcmp(x,BH(i).hecho)
        if abs(BH(i).vc)>=beta
            y = BH(i).vc;
            BH2 = BH;
            encontrado = 1;
            break;           
        else
            incerteza = 1;  %Si se encuentra, se guarda el valor que tiene para entregarlo más tarde
            AUXvc = BH(i).vc;
        end
    end
end
vconclu = 0;
j=1;
reglas(1) = 0;
auxcontador = 0; %contador para saber si ingreso por primer vez datos a la base de hechos o ya lo hize antes y debo actualizar
if encontrado == 0
    for i=1:11  %numero de reglas que entregan conclusiones intermedias
        for t=1:length(R(i).conclusion)
            if strcmp(R(i).conclusion(t),x) && abs(R(i).vc(t))>=epsilon
                reglas(j) = i; %Guardo la regla y la respectiva conclusion de la regla, que contiene a la que estoy buscando
                conclusion(j) = t;
                j=j+1;
            end
        end
    end
    if reglas(1) ~= 0
        for j=1:length(reglas)
                falla = 0;
                v=ones(1,length(R(reglas(j)).premisa)); 
                for l=1:length(R(reglas(j)).premisa)
                    [v(l),BH] = certeza(R(reglas(j)).premisa{l},R,BH);
                    if abs(v(l))<beta
                        falla = 1;
                        break;  %Si una de las clausulas falla, dejo de probar las demás
                    end
                end
                if falla ==0
                    minimo2 = conjuncion(v);
                    if abs(minimo2)>=(beta/abs(R(reglas(j)).vc(conclusion(j)))) && abs(R(reglas(j)).vc(conclusion(j)))>=epsilon && abs(minimo2*R(reglas(j)).vc(conclusion(j)))>abs(vconclu)
                        vconclu = minimo2*R(reglas(j)).vc(conclusion(j));
                        if (auxcontador == 0)  %Actualizo la base de hechos
                            for m=1:length(R(reglas(j)).conclusion)
                                BH(length(BH)+1).hecho = R(reglas(j)).conclusion{m};
                                BH(length(BH)).vc = R(reglas(j)).vc(m)*minimo2;
                            end
                            auxcontador = 1;  
                        else
                            for l=1:length(BH)
                                for n=1:length(R(reglas(j)).conclusion)
                                    if strcmp(R(reglas(j)).conclusion(n),BH(l).hecho)
                                        BH(l).vc = R(reglas(j)).vc(n)*minimo2;
                                    end
                                end
                            end
                        end
                    end
                    if abs(vconclu)>=gamma
                        y=vconclu;
                        BH2 = BH;
                        break;%quiebro el while teniendo un i<12, por lo que al final, antes de terminar el programa, no preguntará al usuario
                    elseif j==length(reglas) && abs(vconclu)<gamma %Si no hay mas reglas para mejorar
                        y=vconclu;
                        BH2 = BH;
                        break;
                    else
                        continue;
                    end                  
                else
                    if j==length(reglas)
                        if vconclu ==0
                            y = 0; %osea nada se activo, no podemos saber nada de esta conclusion
                            for m=1:length(R(reglas(j)).conclusion)
                                    BH(length(BH)+1).hecho = R(reglas(j)).conclusion{m};
                                    BH(length(BH)).vc = 0; %Guardo para saber que no pudo probar y no lo intente denuevo. Este valor nunca se usara porque es mayor a beta
                            end
                            BH2 = BH;
                        else
                            y = vconclu;
                            BH2 = BH;
                        end
                    end
                end
        end
    else
        if incerteza ~= 1
            entrada = input(strcat(x,' ? -1 completamente en desacuerdo, 0 ignorancia, 1 completamente de acuerdo ','  '));
            BH(length(BH)+1).hecho = x;
            BH(length(BH)).vc = entrada;
            y=entrada;
            BH2 = BH;
        else
            y = AUXvc;  %No se pregunta si ya se encontro de antes aunque se declare ignorancia. Se devuelve lo que se habia encontrado
            BH2 = BH;
        end
            
    end
end


            

    
