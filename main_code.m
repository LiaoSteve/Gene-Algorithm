%%
%Binary code GA 
clear,clc;
reproduction=2; %1:r.w.select.  2: t.select
crossover=2;%1:one-point 2: two-point
q=3;
X=zeros(1,q);
Y=zeros(1,q);
for e=1:q %執行次數
k=0; %世代
r = randi([0 2^10-1],10,1);
b = de2bi(r,10, 'left-msb');
G_temp=[ r b];
while 1
     x(1)=0;
     for i=1:10
        f_fit(i)=round(f(y(G_temp(i,1)))^4);
        G(k+1,i)= y(G_temp(i,1));%x
        G(k+1,i+10)=f(y(G_temp(i,1)));%f(x)
        G(k+1,i+20)=f_fit(i);
        x(i+1)=x(i)+f_fit(i);
     end        
     G(k+1,31)=max(G(k+1,21:30));%f_fit max
     G(k+1,32)=x(11)/10;%f_fit average      
     if k>50
         if G(k+1,31)==G(k,31) && G(k,31)==G(k-1,31) && G(k-1,31)==G(k-2,31)%      
             figure,
             Y(e)=max(G(k+1,11:20));  
             o=find(G(k+1,11:20)==max(G(k+1,11:20)));
             X(e)=G(k+1,o(1));
             plot(0:k,G(1:k+1,31));             
             hold on;
             plot(0:k,G(1:k+1,32),'--');             
             title(['(' num2str(X(e)) ' , ' num2str(Y(e)) ')']);               
             break;
         end
     end
    if reproduction==1
        %roulette wheel selection         
        for i=1:10
            r=rand;
            if r>=x(1)/x(11) && r<=x(2)/x(11)
                rw=G_temp(1,1);
            elseif r>x(2)/x(11) && r<=x(3)/x(11)
                rw=G_temp(2,1);
            elseif r>x(3)/x(11) && r<=x(4)/x(11)
                rw=G_temp(3,1);  
            elseif r>x(4)/x(11) && r<=x(5)/x(11)
                rw=G_temp(4,1);   
            elseif r>x(5)/x(11) && r<=x(6)/x(11)
                rw=G_temp(5,1); 
           elseif r>x(6)/x(11) && r<=x(7)/x(11)
                rw=G_temp(6,1); 
           elseif r>x(7)/x(11) && r<=x(8)/x(11)
                rw=G_temp(7,1);    
           elseif r>x(8)/x(11) && r<=x(9)/x(11)
                rw=G_temp(8,1);      
           elseif r>x(9)/x(11) && r<=x(10)/x(11)
                rw=G_temp(9,1); 
           elseif r>x(10)/x(11) && r<=x(11)/x(11)
                rw=G_temp(10,1);      
            end
        G_temp(i,:)=[ rw de2bi(rw,10, 'left-msb')];
        end         
    else
        %tournament  selection    抓2    
        temp=zeros(10,11);
        for i=1:10
            r=randperm(10,2);
            t=[f_fit(r(1)),f_fit(r(2))] ;
            T=find(t==max(t));
            temp(i,:)=[ G_temp(r(T(1)),1) de2bi(G_temp(r(T(1)),1),10, 'left-msb')];
        end                  
        G_temp=temp;
    end    
    %crossover(rate=0.8)    
    G_cr=G_temp;
    if crossover==1 %one-point
        for i=1:2:7
            j = randperm(10,1);                           
            G_cr(i,j+1)=G_temp(i+1,j+1);    
            G_cr(i+1,j+1)=G_temp(i,j+1);                
        end
    else%two-point
        for i=1:2:7
            r = randperm(10,2);%不重複之1~10值2個
            if r(1)>r(2)
                temp=r(1);
                r(1)=r(2);
                r(2)=temp;
            end      
            for j=r(1):r(2)                
                G_cr(i,j+1)=G_temp(i+1,j+1);    
                G_cr(i+1,j+1)=G_temp(i,j+1);;
            end    
        end
    end    
    for i=1:10
        G_cr(i,1)=bin2dec(strcat(int2str(G_cr(i,2:11))));
        %G_cr(i,2:11)=de2bi(G_cr(i,1), 10,'left-msb');
    end
    %mutation  (rate=0.01)
    if k~=0 && mod(k,1)==0        
     r = randperm(10,2);%產生不重複1~10之值2個
     if G_cr(r(1),r(2)+1)==1
         G_cr(r(1),r(2)+1)=0;
     else
         G_cr(r(1),r(2)+1)=1;
     end
     G_cr(r(1),1)=bin2dec(strcat(int2str(G_cr(r(1),2:11))));
     %G_cr(r(1),2:11)=de2bi(G_cr(r(1),1), 10,'left-msb');       
     G_temp=G_cr;    
    end
     k=k+1;    
end
end
figure,subplot(211),
stem(X(:),Y(:),'filled');
axis([-10 10 0 165]);
grid on
h=find(Y==max(Y))
title(['(' num2str(X(h(1))) ' , ' num2str(max(Y(:))) ')']);  
uu=1;
for u=-10:0.1:10
    U(uu)=f(u);
    uu=uu+1
end
subplot(212),stem(-10:0.1:10,U);
hold on,grid on
stem(X(h(1)),max(Y(:)),'filled','r');



%%
%Real valued GA 
clear,clc;
reproduction=1; %1:r.w.select.  2: t.select
s=5;%mutation factor
q=3;
X=zeros(1,q);
Y=zeros(1,q);
for e=1:q %執行次數
k=0;%世代
r = rand(10,1)*20-10;% -10~10
G_temp=[ r ];
while 1
     x(1)=0;
     for i=1:10
        f_fit(i)= f(G_temp(i,1))^4;
        G(k+1,i)= (G_temp(i,1));%x
        G(k+1,i+10)=f(G_temp(i,1));%f(x)
        G(k+1,i+20)=f_fit(i);
        x(i+1)=x(i)+f_fit(i);
     end             
     G(k+1,31)=max(G(k+1,21:30));%f_fit max
     G(k+1,32)=x(11)/10;%f_fit average     
     if k>50
             if G(k+1,31)==G(k,31) && G(k,31)==G(k-1,31) && G(k-1,31)==G(k-2,31)                  
                 figure,
                 Y(e)=max(G(k+1,11:20));  
                 o=find(G(k+1,11:20)==max(G(k+1,11:20)));
                 X(e)=G(k+1,o(1));
                 plot(0:k,G(1:k+1,31));             
                 hold on;
                 plot(0:k,G(1:k+1,32),'--');             
                 title(['(' num2str(X(e)) ' , ' num2str(Y(e)) ')']);               
                 break;
             end
     end
    if reproduction==1
        %roulette wheel selection        
        for i=1:10
                r=rand;
                if r>=x(1)/x(11) && r<=x(2)/x(11)
                    rw=G_temp(1,1);
                elseif r>x(2)/x(11) && r<=x(3)/x(11)
                    rw=G_temp(2,1);
                elseif r>x(3)/x(11) && r<=x(4)/x(11)
                    rw=G_temp(3,1);  
                elseif r>x(4)/x(11) && r<=x(5)/x(11)
                    rw=G_temp(4,1);   
                elseif r>x(5)/x(11) && r<=x(6)/x(11)
                    rw=G_temp(5,1); 
               elseif r>x(6)/x(11) && r<=x(7)/x(11)
                    rw=G_temp(6,1); 
               elseif r>x(7)/x(11) && r<=x(8)/x(11)
                    rw=G_temp(7,1);    
               elseif r>x(8)/x(11) && r<=x(9)/x(11)
                    rw=G_temp(8,1);      
               elseif r>x(9)/x(11) && r<=x(10)/x(11)
                    rw=G_temp(9,1); 
               elseif r>x(10)/x(11) && r<=x(11)/x(11)
                    rw=G_temp(10,1);      
               end
            G_temp(i,:)=[rw];
        end  
    else    %tournament  selection    抓2                  
        for i=1:10
            r=randperm(10,2);
            t=[f_fit(r(1)),f_fit(r(2))] ;
            T=find(t==max(t));
            temp(i)=[ G_temp(r(T(1)),1) ];
        end                  
        G_temp=temp';
    end        
    %crossover(rate=0.8)    
    G_cr=zeros(8,1);
    for i=1:2:7                    
        while 1
            sigma=rand*2-1; %-1~1        
            p1=G_temp(i)+sigma*(G_temp(i)+G_temp(i+1));    
            p2=G_temp(i+1)-sigma*(G_temp(i)-G_temp(i+1));  
            if p1<=10 && p1>=-10   &&  p2<=10 && p2>=-10
               G_cr(i)=p1;
                G_cr(i+1)=p2;
                break;
            end            
        end
    end
     G_temp(1:8)=G_cr(1:8);
    %mutation (rate=0.01)
    if k~=0 && mod(k,10)==0        
                while 1
                    r=randperm(10,1)
                    noise= rand*2-1;%-1~1    
                    p=G_temp(r)+s*noise;
                    if p<=10 && p>=-10
                        G_temp(r)=p;
                        break
                    end
                end
    end           
    k=k+1;
end
end
figure,subplot(211),
stem(X(:),Y(:),'filled');
axis([-10 10 0 165]);
grid on
title(['(' num2str(X(find(Y==max(Y)))) ' , ' num2str(max(Y(:))) ')']);   
uu=1;
for u=-10:0.1:10
    U(uu)=f(u);
    uu=uu+1;
end
subplot(212),stem(-10:0.1:10,U);
hold on,grid on
stem(X(find(Y==max(Y))),max(Y(:)),'filled','r');



%%
%EA
clear,clc;
reproduction=2; %1:r.w.select.  2: t.select
q=3;
X=zeros(1,q);
Y=zeros(1,q);
for e=1:q %執行次數
k=0;%世代
r = rand(10,1)*20-10;% -10~10
G_temp=[ r ];
while 1
     x(1)=0;
     for i=1:10      
        f_fit(i)=f(G_temp(i,1))^4;     
        G(k+1,i)= (G_temp(i,1));%x
        G(k+1,i+10)=f(G_temp(i,1));%f(x)
        G(k+1,i+20)=f_fit(i);
        x(i+1)=x(i)+f_fit(i);
     end             
     G(k+1,31)=max(G(k+1,21:30));%f_fit max
     G(k+1,32)=x(11)/10;%f_fit average     
     if k>100
             if G(k+1,31)==G(k,31) && G(k,31)==G(k-1,31) && G(k-1,31)==G(k-2,31) 
                        figure,
                        Y(e)=max(G(k+1,11:20));  
                        o=find(G(k+1,11:20)==max(G(k+1,11:20)));
                        X(e)=G(k+1,o(1));
                        plot(0:k,G(1:k+1,31));             
                        hold on;
                         plot(0:k,G(1:k+1,32),'--');             
                        title(['(' num2str(X(e)) ' , ' num2str(Y(e)) ')']);     
                 break;
             end
     end
    if reproduction==1
        %roulette wheel selection        
        for i=1:10
                r=rand;
                if r>=x(1)/x(11) && r<=x(2)/x(11)
                    rw=G_temp(1,1);
                elseif r>x(2)/x(11) && r<=x(3)/x(11)
                    rw=G_temp(2,1);
                elseif r>x(3)/x(11) && r<=x(4)/x(11)
                    rw=G_temp(3,1);  
                elseif r>x(4)/x(11) && r<=x(5)/x(11)
                    rw=G_temp(4,1);   
                elseif r>x(5)/x(11) && r<=x(6)/x(11)
                    rw=G_temp(5,1); 
               elseif r>x(6)/x(11) && r<=x(7)/x(11)
                    rw=G_temp(6,1); 
               elseif r>x(7)/x(11) && r<=x(8)/x(11)
                    rw=G_temp(7,1);    
               elseif r>x(8)/x(11) && r<=x(9)/x(11)
                    rw=G_temp(8,1);      
               elseif r>x(9)/x(11) && r<=x(10)/x(11)
                    rw=G_temp(9,1); 
               elseif r>x(10)/x(11) && r<=x(11)/x(11)
                    rw=G_temp(10,1);      
               end
            G_temp(i,:)=[rw];
        end  
    else    %tournament  selection    抓2                  
        for i=1:10
            r=randperm(10,2);
            t=[f_fit(r(1)),f_fit(r(2))] ;
            T=find(t==max(t));
            temp(i)=[ G_temp(r(T(1)),1) ];
        end                  
        G_temp=temp';
    end        
    %crossover(rate=0.8)    
    G_cr=zeros(8,1);   
    for i=1:2:7                    
        while 1
            r=rand(1,2); %0~1        
            p1=G_temp(i)*r(1)+G_temp(i+1)*(1-r(1));
            p2= G_temp(i)*r(2)+G_temp(i+1)*(1-r(2)); 
            if p1<=10 && p1>=-10   &&  p2<=10 && p2>=-10
                G_cr(i)=p1;
                G_cr(i+1)=p2;
                break;
            end            
        end
    end
    G_temp(1:8)=G_cr(1:8);
    %mutation (rate=0.01)
    if k~=0 && mod(k,10)==0        
                while 1                    
                   n=randperm(10,1);
                   d=randperm(20,1)*2-20;                  
                   r=rand;                   
                    p=G_temp(n)+r*d;
                    if p<=10  &&  p>=-10
                        G_temp(n)=p;
                        break
                    end
                end
    end           
    G_temp(:,1)
    k=k+1;
end
end
figure,subplot(211)
stem(X(:),Y(:),'filled');
axis([-10 10 0 165]);
grid on
title(['(' num2str(X(find(Y==max(Y)))) ' , ' num2str(max(Y(:))) ')']);  
uu=1;
for u=-10:0.1:10
    U(uu)=f(u);
    uu=uu+1;
end
subplot(212)
stem(-10:0.1:10,U);
hold on,grid on
stem(X(find(Y==max(Y))),max(Y(:)),'filled','r');