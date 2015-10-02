libname four11 '/scs/wtm926/' access=readonly;

Data eda;
  set four11.logit_insurance;

proc contents data=eda;

/* Continous */

proc means data=eda n nmiss mean std range P5 P95;
    var AGE BLUEBOOK CAR_AGE CLM_FREQ HOMEKIDS HOME_VAL INCOME MVR_PTS OLDCLAIM TIF TRAVTIME YOJ;
    class TARGET_FLAG;

proc means data=eda n nmiss mean std range P5 P95;
    var AGE BLUEBOOK CAR_AGE CLM_FREQ HOMEKIDS HOME_VAL INCOME MVR_PTS OLDCLAIM TIF TRAVTIME YOJ;

data imp_eda;
    set eda;

    IMP_AGE = AGE;
    I_IMP_AGE = 0;
    if missing(IMP_AGE) then do;
        IMP_AGE = 44.7903127;
        I_IMP_AGE = 1;
    end;

    IMP_CAR_AGE = CAR_AGE;
    I_IMP_CAR_AGE = 0;
    if missing(IMP_CAR_AGE) then do;
        IMP_CAR_AGE = 8.3283231;
        I_IMP_CAR_AGE = 1;
    end;

    IMP_HOME_VAL = HOME_VAL;
    I_IMP_HOME_VAL = 0;
    if missing(IMP_HOME_VAL) then do;
        IMP_HOME_VAL = 154867.29;
        I_IMP_HOME_VAL = 1;
    end;

    IMP_INCOME = INCOME;
    I_IMP_INCOME = 0;
    if missing(IMP_INCOME) then do;
        IMP_INCOME = 61898.10;
        I_IMP_INCOME = 1;
    end;
    log_IMP_INCOME = log(IMP_INCOME);
    t_IMP_INCOME = IMP_INCOME / 10000;

    IMP_YOJ = YOJ;
    I_IMP_YOJ = 0;
    if missing(IMP_YOJ) then do;
        IMP_YOJ = 10.4992864;
        I_IMP_YOJ = 1;
    end;

    if IMP_HOME_VAL = 0 then I_HOMEOWN = 0;
        else I_HOMEOWN = 1;

proc freq data=imp_eda;
    table I_HOMEOWN;

proc corr data=imp_eda;
    var TARGET_FLAG IMP_AGE BLUEBOOK IMP_CAR_AGE CLM_FREQ HOMEKIDS IMP_HOME_VAL IMP_INCOME MVR_PTS OLDCLAIM TIF TRAVTIME IMP_YOJ;

proc univariate data=imp_eda normal;
    var IMP_AGE BLUEBOOK IMP_CAR_AGE CLM_FREQ HOMEKIDS IMP_HOME_VAL IMP_INCOME MVR_PTS OLDCLAIM TRAVTIME;
    histogram;

data cut_imp_eda;
    set imp_eda;

    if IMP_AGE < 39 then IMP_AGE_DISCRETE = 1; *25th;
        else if IMP_AGE < 45 then IMP_AGE_DISCRETE = 2; *50th;
        else if IMP_AGE < 51 then IMP_AGE_DISCRETE = 3; *75th;
        else IMP_AGE_DISCRETE = 4;

    if BLUEBOOK < 9280 then BLUEBOOK_DISCRETE = 1; *25th;
        else if BLUEBOOK < 14440 then BLUEBOOK_DISCRETE = 2; *50th;
        else if BLUEBOOK < 20850 then BLUEBOOK_DISCRETE = 3; *75th;
        else BLUEBOOK_DISCRETE = 4;

    if IMP_CAR_AGE < 4.00000 then IMP_CAR_AGE_DISCRETE = 1; *25th;
        else if IMP_CAR_AGE < 8.32832 then IMP_CAR_AGE_DISCRETE = 2; *50th;
        else if IMP_CAR_AGE < 12.00000 then IMP_CAR_AGE_DISCRETE = 3; *75th;
        else IMP_CAR_AGE_DISCRETE = 4;

    if IMP_HOME_VAL < 154867 then IMP_HOME_VAL_DISCRETE = 1; *50th;
        else if IMP_HOME_VAL < 233352 then IMP_HOME_VAL_DISCRETE = 2; *75th;
        else if IMP_HOME_VAL < 311195 then IMP_HOME_VAL_DISCRETE = 3; *90th;
        else IMP_HOME_VAL_DISCRETE = 4;

    if IMP_INCOME < 29706.76 then IMP_INCOME_DISCRETE = 1; *25th;
        else if IMP_INCOME < 57386.58 then IMP_INCOME_DISCRETE = 2; *50th;
        else if IMP_INCOME < 83303.72 then IMP_INCOME_DISCRETE = 3; *75th;
        else IMP_INCOME_DISCRETE = 4;

    if OLDCLAIM < 4636 then OLDCLAIM_DISCRETE = 1; *75th;
        else if OLDCLAIM < 9583 then OLDCLAIM_DISCRETE = 2; *90th;
        else if OLDCLAIM < 27090 then OLDCLAIM_DISCRETE = 3; *95th;
        else OLDCLAIM_DISCRETE = 4;

    if TRAVTIME < 22.45170 then TRAVTIME_DISCRETE = 1; *25th;
        else if TRAVTIME < 32.87097 then TRAVTIME_DISCRETE = 2; *50th;
        else if TRAVTIME < 43.80707 then TRAVTIME_DISCRETE = 3; *75th;
        else TRAVTIME_DISCRETE = 4;

proc freq data=cut_imp_eda;
    table TARGET_FLAG*IMP_AGE_DISCRETE;
proc freq data=cut_imp_eda;
    table TARGET_FLAG*BLUEBOOK_DISCRETE;
proc freq data=cut_imp_eda;
    table TARGET_FLAG*IMP_CAR_AGE_DISCRETE;
proc freq data=cut_imp_eda;
    table TARGET_FLAG*IMP_HOME_VAL_DISCRETE;
proc freq data=cut_imp_eda;
    table TARGET_FLAG*IMP_INCOME_DISCRETE;
proc freq data=cut_imp_eda;
    table TARGET_FLAG*OLDCLAIM_DISCRETE;
proc freq data=cut_imp_eda;
    table TARGET_FLAG*TRAVTIME_DISCRETE;

/* Categorical */

proc freq data=imp_eda;
    tables CAR_TYPE CAR_USE EDUCATION JOB KIDSDRIV MSTATUS PARENT1 RED_CAR REVOKED SEX URBANICITY;

proc freq data=imp_eda;
    table TARGET_FLAG*CAR_TYPE;
proc freq data=imp_eda;
    table TARGET_FLAG*CAR_USE;
proc freq data=imp_eda;
    table TARGET_FLAG*CLM_FREQ;
proc freq data=imp_eda;
    table TARGET_FLAG*EDUCATION;
proc freq data=imp_eda;
    table TARGET_FLAG*HOMEKIDS;
proc freq data=imp_eda;
    table TARGET_FLAG*JOB;
proc freq data=imp_eda;
    table TARGET_FLAG*KIDSDRIV;
proc freq data=imp_eda;
    table TARGET_FLAG*MSTATUS;
proc freq data=imp_eda;
    table TARGET_FLAG*MVR_PTS;
proc freq data=imp_eda;
    table TARGET_FLAG*PARENT1;
proc freq data=imp_eda;
    table TARGET_FLAG*RED_CAR;
proc freq data=imp_eda;
    table TARGET_FLAG*REVOKED;
proc freq data=imp_eda;
    table TARGET_FLAG*SEX;
proc freq data=imp_eda;
    table TARGET_FLAG*URBANICITY;

data imp_d_eda;
    set imp_eda;

    * Variable of reference: Panel Truck;
    if CAR_TYPE in ('Minivan' 'Panel Truck' 'Pickup' 'Sports Car' 'Van' 'z_SUV') then do;
        TYPE_MINI = (CAR_TYPE eq 'Minivan');
        TYPE_PICK = (CAR_TYPE eq 'Pickup');
        TYPE_SPOR = (CAR_TYPE eq 'Sports Car');
        TYPE_VAN = (CAR_TYPE eq 'Van');
        TYPE_SUV = (CAR_TYPE eq 'z_SUV');
    end;

    * Variable of reference: Commercial;
    if CAR_USE in ('Commercial' 'Private') then do;
        USE_P = (car_use eq 'Private');
    end;

    * Variable of reference: PhD;
    if EDUCATION in ('<High School' 'Bachelors' 'Masters' 'PhD' 'z_High School') then do;
        EDU_HS = (EDUCATION eq '<High School');
        EDU_BA = (EDUCATION eq 'Bachelors');
        EDU_MA = (EDUCATION eq 'Masters');
        EDU_ZHS = (EDUCATION eq 'z_High School');
    end;

    * Variable of reference: Doctor;
    if JOB in ('Clerical' 'Home Maker' 'Lawyer' 'Manager' 'Professional' 'Student' 'z_Blue Collar') then do;
        JOB_C = (JOB eq 'Clerical');
        JOB_HM = (JOB eq 'Home Maker');
        JOB_L = (JOB eq 'Lawyer');
        JOB_M = (JOB eq 'Manager');
        JOB_P = (JOB eq 'Professional');
        JOB_S = (JOB eq 'Student');
        JOB_BC = (JOB eq 'z_Blue Collar');
    end;

    if MSTATUS in ('Yes' 'z_No') then do;
        MARRIED_Y = (MSTATUS eq 'Yes');
    end;

    if PARENT1 in ('No' 'Yes') then do;
        PARTENT_S = (PARENT1 eq 'YES');
    end;

    if RED_CAR in ('no' 'yes') then do;
        RED_C = (RED_CAR eq 'yes');
    end;

    if REVOKED in ('No' 'Yes') then do;
        REV_L = (REVOKED eq 'Yes');
    end;

    * Variable of reference: Male;
    if SEX in ('M' 'z_F') then do;
        SEX_F = (SEX eq 'z_F');
    end;

/* Modeling TARGET_FLAG */

proc logistic data=imp_d_eda descending plots(only)=roc(id=prob);
    model TARGET_FLAG = IMP_AGE BLUEBOOK IMP_CAR_AGE CLM_FREQ HOMEKIDS IMP_INCOME MVR_PTS OLDCLAIM TRAVTIME
                        I_HOMEOWN
                        TYPE_MINI TYPE_PICK TYPE_SPOR TYPE_VAN TYPE_SUV USE_P EDU_HS EDU_BA EDU_MA EDU_ZHS
                        JOB_C JOB_HM JOB_L JOB_M JOB_P JOB_S JOB_BC MARRIED_Y PARTENT_S RED_C REV_L SEX_F /
                        selection=score outroc=roc_model rsq lackfit;
    output out=model_data pred=yhat_model;



proc logistic data=imp_d_eda DESCENDING PLOTS=EFFECT PLOTS=ROC;
    model TARGET_FLAG = IMP_INCOME MVR_PTS USE_P REV_L / rsq lackfit;
    output out=model_4_data pred=model_4_yhat;

proc logistic data=imp_d_eda DESCENDING PLOTS=EFFECT PLOTS=ROC;
    model TARGET_FLAG = CLM_FREQ IMP_INCOME MVR_PTS USE_P REV_L / rsq lackfit;
    output out=model_5_data pred=model_5_yhat;


proc logistic data=imp_d_eda DESCENDING PLOTS=EFFECT PLOTS=ROC;
    model TARGET_FLAG = CLM_FREQ IMP_INCOME MVR_PTS USE_P MARRIED_Y REV_L / rsq lackfit;
    output out=model_6_data pred=model_6_yhat;

proc logistic data=imp_d_eda DESCENDING PLOTS=EFFECT PLOTS=ROC;
    model TARGET_FLAG = CLM_FREQ IMP_INCOME I_IMP_INCOME MVR_PTS USE_P MARRIED_Y REV_L / rsq lackfit;
    output out=model_6_data pred=model_6_yhat;



/* Modeling TARGET_AMT */


proc reg data=imp_d_eda;
    model TARGET_AMT = IMP_AGE BLUEBOOK IMP_CAR_AGE CLM_FREQ HOMEKIDS IMP_INCOME MVR_PTS OLDCLAIM TRAVTIME I_HOMEOWN TYPE_MINI TYPE_PICK TYPE_SPOR TYPE_VAN TYPE_SUV USE_P EDU_HS EDU_BA EDU_MA EDU_ZHS JOB_C JOB_HM JOB_L JOB_M JOB_P JOB_S JOB_BC MARRIED_Y PARTENT_S RED_C REV_L SEX_F /
    selection=adjrsq aic bic cp best=5;

proc reg data=imp_d_eda;
    model TARGET_AMT = HOMEKIDS IMP_CAR_AGE CLM_FREQ;

run;