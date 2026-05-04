** Author: Mahmood Mehdiloo
** m.mehdiloozad@gmail.com

Sets
      j   DMUs Numbers.    /j1*j322/
      i   Input Numbers.   /i1*i3/
      r   Output Numbers.  /r1*r5/;

Alias(j,l);
Alias(j,k);

Parameters
        X(j,i)
        Y(j,r)
        P(j,i)
        XX(i)
        YY(r)
        PP(i)
        BigM;

$Call gdxxrw I=C:\BankData1990.xls  Par=X Rng=A1:D323 Rdim=1 Cdim=1  Par=P Rng=F1:I323 Rdim=1 Cdim=1  Par=Y Rng=K1:P323 Rdim=1 Cdim=1
$Gdxin BankData1990.gdx
$Load X, P, Y
$Gdxin

BigM=1000000;

Positive variables
    Lambda(j)
    v(i);

Free variable
    Theta;

Binary variable
    Delta(k);

****************************************************************
Equations
     Con_obj_COS
       Con_COS_I
       Con_COS_O
       Con_COS_3
       Con_COS_4
       Con_COS_5
       Con_Conv_I;

     Con_obj_COS..     Theta =E= Sum(i, PP(i)*v(i));
       Con_COS_I(k,i)..             delta(k) * X(k,i) =L= v(i);
       Con_COS_O(r)..        Sum(j, lambda(j)*Y(j,r)) =g= YY(r);
       Con_COS_3(k)..              Delta(k) =L= BigM*Lambda(k);
       Con_COS_4(k)..        BigM*Lambda(k) =L= BigM*Delta(k);
       Con_COS_5..           Sum(j, Lambda(j)) =E= 1;
       Con_Conv_I(i)..       Sum(j, lambda(j)*X(j,i)) =L= v(i);

Model COSmodel  /Con_obj_COS, Con_COS_I,  Con_COS_O, Con_COS_3, Con_COS_4, Con_COS_5/
      ConvModel /Con_obj_COS, Con_Conv_I, Con_COS_O, Con_COS_5 /;
*****************************************************************

File code /mincost.txt/;
Put  code;

Parameter
    D(L,j)
    b(j,r);

Loop(L,
       YY(r) = Y(L,r);
       Loop(j,
              b(j,r)=0;
              b(j,r) $ (Y(j,r)<YY(r)) = 1;
              D(L,j) $ (Sum(r, b(j,r))=0) = 1;
              D(L,j) $ (Sum(r, b(j,r))>0) = 0;
            );
     );

Put /'Minimum & Actial costs of Hospitals in the COS and C technologies';
Put / /;
Put'DMU            C            COS         NC=CIS=WACM     Actual Cost      '/;
Put'-----------------------------------------------------------------'/;

Loop(L,
       Put L.TL:4:0;
       XX(i) = X(L,i);
       PP(i) = P(L,i);
       YY(r) = Y(L,r);

       Solve ConvModel using LP minimizing Theta;
         Put Theta.L:15:3;

       Option optcr=0;
       Option optca=0;
       option reslim=100;
       option threads=0;
       Solve COSmodel using MIP minimizing Theta;
         Option MIP=OSICPLEX;
         Put Theta.L:15:3;

       Put Smin(j $(D(L,j)=1), Sum(i, PP(i)*X(j,i)) ):15:3;
       Put Sum(i, PP(i)*XX(i)):15:3;
       Put/;
    );
Put'-----------------------------------------------------------------'/;





