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
    D(L,j)
    WACM(j)
    CIS(j);

$Call gdxxrw I=C:\BankData1990.xls  Par=X Rng=A1:D323 Rdim=1 Cdim=1  Par=P Rng=F1:I323 Rdim=1 Cdim=1  Par=Y Rng=K1:P323 Rdim=1 Cdim=1
$Gdxin BankData1990.gdx
$Load X, P, Y
$Gdxin

Scalar
    BigM /1000000/
    solveStart /0/
    solve_wacm /0/
    solve_CIS  /0/;

Positive variables
    Lambda(j)
    v(i);

Free variable
    Theta;

Binary variable
    Delta(k);

****************************************************************
Equations
     Con_obj
       Con_COS_I
       Con_I
       Con_O
       Con_CIS_O
       Con_COS_M1
       Con_COS_M2
       Con_norm;

     Con_obj..         Theta =E= Sum(i, PP(i)*v(i));
       Con_COS_I(k,i)..             Delta(k) * X(k,i) =L= v(i);
       Con_I(i)..            Sum(j, Lambda(j)*X(j,i)) =L= v(i);
       Con_O(r)..            Sum(j, Lambda(j)*Y(j,r)) =g= YY(r);
       Con_CIS_O(k,r)..      Lambda(k)*(Y(k,r)-YY(r)) =G= 0;
       Con_COS_M1(k)..             Delta(k) =L= BigM*Lambda(k);
       Con_COS_M2(k)..       BigM*Lambda(k) =L= BigM*Delta(k);
       Con_norm..            Sum(j, Lambda(j)) =E= 1;

Model COSmodel  /Con_obj, Con_COS_I,  Con_O, Con_COS_M1, Con_COS_M2, Con_norm/
      ConvModel /Con_obj, Con_I, Con_O, Con_norm /
      CISmodel  /Con_obj, Con_I, Con_CIS_O, Con_norm /;
*****************************************************************
File code /mincost.txt/;
Put  code;

solveStart = TimeElapsed;
Loop(L,
       XX(i) = X(L,i);
       PP(i) = P(L,i);
       YY(r) = Y(L,r);
       D(L,j) = 1 $ (Sum(r, 1 $ (Y(j,r) < YY(r))) = 0);
       WACM(L) = Smin(j $(D(L,j)=1), Sum(i, PP(i)*X(j,i)) );
    );
solve_wacm = TimeElapsed - solveStart;

solveStart = TimeElapsed;
Loop(L,
       XX(i) = X(L,i);
       PP(i) = P(L,i);
       YY(r) = Y(L,r);

       Solve CISmodel using LP minimizing Theta;
       Option LP = CPLEX;
          CIS(L)=Theta.L;
    );
solve_CIS = TimeElapsed - solveStart;

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
         Option LP = CPLEX;
         Put Theta.L:15:3;

       Option optcr=0;
       Option optca=0;
       option reslim=100;
       option threads=10;
       Solve COSmodel using MIP minimizing Theta;
         Option MIP=OSICPLEX;
         Put Theta.L:15:3;

       Put WACM(L);
       Put Sum(i, PP(i)*XX(i)):15:3;
       Put/;
    );
Put'-----------------------------------------------------------------'/;

Display solve_wacm,solve_CIS;
