libname four11 '/scs/wtm926/' access=readonly;

data testing;
    set four11.logit_insurance_test;

data testing_fixed;
    set testing;

    IMP_CAR_AGE = CAR_AGE;
    I_IMP_CAR_AGE = 0;
    if missing(IMP_CAR_AGE) then do;
        IMP_CAR_AGE = 8.3283231;
        I_IMP_CAR_AGE = 1;
    end;

    IMP_INCOME = INCOME;
    I_IMP_INCOME = 0;
    if missing(IMP_INCOME) then do;
        IMP_INCOME = 61898.10;
        I_IMP_INCOME = 1;
    end;

    if CAR_USE in ('Commercial' 'Private') then do;
        USE_P = (car_use eq 'Private');
    end;
    if MSTATUS in ('Yes' 'z_No') then do;
        MARRIED_Y = (MSTATUS eq 'Yes');
    end;
    if REVOKED in ('No' 'Yes') then do;
        REV_L = (REVOKED eq 'Yes');
    end;



data testing_score;
    set testing_fixed;

    wat = 0.2631 * CLM_FREQ - 0.00000856 * IMP_INCOME + 0.1449 * MVR_PTS - 0.6733 * USE_P - 0.5995 * MARRIED_Y + 0.8764 * REV_L - 0.4333;
/*  pi = exp(wat) / (1+exp(wat)); */
/*  P_TARGET_FLAG = (pi gt 0.50); */
    P_TARGET_FLAG = exp(wat) / (1+exp(wat));
    P_TARGET_AMT = 1324.64489 + 216.66500 * HOMEKIDS - 41.75664 * IMP_CAR_AGE + 464.81029 * CLM_FREQ;
    keep index P_TARGET_FLAG P_TARGET_AMT;

proc print data=testing_score;

proc export data=testing_score
    outfile='/sscc/home/a/agd808/sasuser.v94/411/2/out.csv'
    dbms=csv
    replace;

run;