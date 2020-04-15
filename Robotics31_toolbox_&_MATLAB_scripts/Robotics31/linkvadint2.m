function [Wc, dWc, ddWc] = linkvadint2(Wd,tu,T,ksi)

[m, n] = size(Wd);
td = Wd(m,:);
Wc(m,:) = [td(1) - tu(1): T : td(n) + tu(n)];
dWc(m,:) = Wc(m,:);
ddWc(m,:) = Wc(m,:);

[m, kf] = size(Wc);

for i = 1:m-1
    k = 1;
    
    Wc(i,k)=Wd(i,1);
    dWc(i,k)=0.0;
    ddWc(i,k)=0.0;
    
    j = 0;
    dw = 0;
    
    for k = 2:kf;
        t = Wc(m,k);
        
        if(j == n)
            tint = td(n) + tu(n) + T;
        else
            tint = td(j+1) - tu(j+1);
        end
        
        if t >= tint
            j = j + 1;            
            dwp = dw;            
            if j == n
                dw = 0;                
            else
                dw = (Wd(i,j+1) - Wd(i,j));
                if ksi(i) == 1
                    if dw > pi
                        dw = dw - 2 * pi;                        
                    else
                        if dw <= -pi
                            dw = dw + 2 * pi;
                        end
                    end                    
                end                
                dw = dw /(td(j+1) - td(j));
            end
            
            ddw = (dw-dwp)/(2*tu(j));
            a2 = ddw / 2;
            a1 = ddw * tu(j) + dwp;
            a0 = ddw * tu(j)^2 / 2 + Wd(i,j);
            b1 = dw;
            b0 = Wd(i,j);
        end
       
        if t <= td(j) + tu(j)
            Wc(i,k) = a2 * (t - td(j))^2 + a1 * (t - td(j)) + a0;
            dWc(i,k) = 2 * a2 * (t - td(j)) + a1;
            ddWc(i,k) = 2 * a2;
        else
            Wc(i,k) = b1 * (t - td(j)) + b0;
            dWc(i,k) = b1;
            ddWc(i,k) = 0.0;
        end       
        
        if ksi(i) == 1
            if Wc(i,k) > pi
                Wc(i,k) = Wc(i,k) - 2 * pi;
            else
                if Wc(i,k) <= -pi
                    Wc(i,k) = Wc(i,k) + 2 * pi;
                end
            end
        end        
    end        
end    

t0 = [0:T:td(1)-tu(1)-T];

nt0 = length(t0);

Wc = [[Wd(1:m-1,1)*ones(1,nt0); t0] Wc];
dWc = [[zeros(m-1,nt0); t0] dWc];
ddWc = [[zeros(m-1,nt0); t0] ddWc];
