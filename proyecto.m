%Hipotesis
clear
clc
H = struct('hipotesis',{'animal es perro','animal es murcielago','animal es tigre','animal es elefante','animal es cebra','animal es jirafa','animal es tortuga','animal es cheetah','animal es gaviota','animal es avestruz','animal es loro'},'vc',{0,0,0,0,0,0,0,0,0,0,0});

%Reglas

R= struct('premisa',{},'conclusion',{},'vc',{});

R(1).premisa = {'animal tiene pelo'};
R(1).conclusion = {'animal es mamifero' 'animal es ave' 'animal es reptil'};
R(1).vc = [0.8,-1,-1];

R(2).premisa = {'animal da leche'};
R(2).conclusion = {'animal es mamifero' 'animal es ave' 'animal es reptil'};
R(2).vc = [1,-1,-1];


R(3).premisa = {'animal pone huevos' 'animal tiene piel dura'};
R(3).conclusion = {'animal es mamifero' 'animal es ave' 'animal es reptil'};
R(3).vc = [-1,-1,1];

R(4).premisa = {'animal pone huevos' 'animal puede volar'};
R(4).conclusion = {'animal es ave' 'animal es reptil'};
R(4).vc = [1,-1];

R(5).premisa = {'animal tiene plumas'};
R(5).conclusion = {'animal es mamifero' 'animal es ave' 'animal es reptil'};
R(5).vc = [-1,1,-1];

R(6).premisa = {'animal come carne'};
R(6).conclusion= {'animal es carnivoro'};
R(6).vc = [1];

R(7).premisa = {'animal tiene garras'};
R(7).conclusion = {'animal es carnivoro'};
R(7).vc = [0.8];

R(8).premisa = {'animal es mamifero' 'animal tiene pezuñas'};
R(8).conclusion = {'animal es ungulado'};
R(8).vc = [1];

R(9).premisa = {'animal es mamifero' 'animal es rumiante'};
R(9).conclusion = {'animal es ungulado'};
R(9).vc = [0.75];

R(10).premisa = {'animal vive con personas'};
R(10).conclusion = {'animal es domestico'};
R(10).vc = [0.9];

R(11).premisa = {'animal vive en zoologico'};
R(11).conclusion = {'animal es domestico'};
R(11).vc = [-0.8];

R(12).premisa = {'animal es mamifero' 'animal es carnivoro' 'animal tiene manchas oscuras'};
R(12).conclusion = {'animal es cheetah'};
R(12).vc = [0.9];

R(13).premisa = {'animal es mamifero' 'animal es carnivoro' 'animal tiene rayas negras'};
R(13).conclusion = {'animal es tigre'};
R(13).vc = [0.85];

R(14).premisa = {'animal es mamifero' 'animal es carnivoro' 'animal es domestico'};
R(14).conclusion = {'animal es perro'};
R(14).vc = [0.9];

R(15).premisa = {'animal es reptil' 'animal es domestico'};
R(15).conclusion = {'animal es tortuga'};
R(15).vc = [0.7];

R(16).premisa = {'animal es mamifero' 'animal es ungulado' 'animal tiene cuello largo'};
R(16).conclusion = {'animal es jirafa'};
R(16).vc = [1];

R(17).premisa = {'animal es mamifero' 'animal es ungulado' 'animal tiene rayas negras'};
R(17).conclusion = {'animal es cebra'};
R(17).vc = [0.95];

R(18).premisa = {'animal es mamifero' 'animal puede volar' 'animal es feo'};
R(18).conclusion = {'animal es murcielago'};
R(18).vc = [0.9];

R(19).premisa = {'animal es ave' 'animal vuela bien'};
R(19).conclusion = {'animal es gaviota'};
R(19).vc = [0.9];

R(20).premisa = {'animal es ave' 'animal corre rapido'};
R(20).conclusion = {'animal es avestruz'};
R(20).vc = [1];

R(21).premisa = {'animal es ave' 'animal es parlanchin'};
R(21).conclusion = {'animal es loro'};
R(21).vc = [0.95];

R(22).premisa = {'animal es mamifero' 'animal es grande' 'animal es ungulado' 'animal tiene trompa'};
R(22).conclusion = {'animal es elefante'};
R(22).vc = [0.9];

%Parametros de control
alfa = 0.7;
beta = 0.2;
gamma = 0.85;
epsilon = 0.5;

    %Base de hechos

    BH = struct('hecho',{},'vc',{});
    listo = 0;
    i=1;
    falla = 0;
    while i<=length(H)
        aux = 0;
        hip = H(i).hipotesis;       
        for b=12:22 %busco regla asociada a hipotesis
            if strcmp(hip,R(b).conclusion) == 1
                j = b;
            end
        end
        V = ones(1,length(R(j).premisa));
        pre = precalificador(R,BH,j,beta);
        if pre==1                   
            for k=1:length(R(j).premisa)
                [V(k),BH] = certeza(R(j).premisa{k},R,BH);
                if abs(V(k))<beta 
                    aux = 1;
                    break;
                elseif V(k)<-gamma  %Si se detecta una premisa como falsa con alta certeza, entonces no se puede concluir algo 
                    break;
                end
            end
            if aux == 0 
                minimo = conjuncion(V);
                if abs(minimo)>=(beta/abs(R(j).vc)) && abs(R(j).vc)>=epsilon
                    vhipotesis = R(j).vc * minimo;
                    if vhipotesis>alfa
                        disp([R(j).conclusion{1},' con certeza ',num2str(vhipotesis),' porque:']);
                        for h=1:length(R(j).premisa)
                            disp([R(j).premisa{h},' con certeza ',num2str(V(h))]);
                        end
                        listo = 1;
                        break;
                    end
                end
            end
        end
        i=i+1;
    end
    if listo == 1   
    else
        disp('No se ha podido demostrar ninguna hipotesis');
    end


    % Para probar sin el precalificador, comentar líneas 120, 121, 127, 128, 145     

                
                
        
        

    




