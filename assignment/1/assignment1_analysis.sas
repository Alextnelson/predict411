libname four11 '/scs/wtm926/' access=readonly;

data training;
    set four11.moneyball;

data testing;
    set four11.moneyball_test;

proc contents data=training;
proc contents data=testing;

proc means data=training n nmiss mean std range P5 P95;
    var TARGET_WINS TEAM_BATTING_H TEAM_BATTING_2B TEAM_BATTING_3B TEAM_BATTING_HR TEAM_BATTING_BB TEAM_BATTING_HBP TEAM_BATTING_SO TEAM_BASERUN_SB TEAM_BASERUN_CS TEAM_FIELDING_E TEAM_FIELDING_DP TEAM_PITCHING_BB TEAM_PITCHING_H TEAM_PITCHING_HR TEAM_PITCHING_SO;

proc corr data=training rank plots=all;
    var TEAM_BATTING_H TEAM_BATTING_2B TEAM_BATTING_3B TEAM_BATTING_HR TEAM_BATTING_BB TEAM_BATTING_HBP TEAM_BATTING_SO TEAM_BASERUN_SB TEAM_BASERUN_CS TEAM_FIELDING_E TEAM_FIELDING_DP TEAM_PITCHING_BB TEAM_PITCHING_H TEAM_PITCHING_HR TEAM_PITCHING_SO;
    with TARGET_WINS;

proc means data=training n nmiss mean std range P5 P95;
    var TARGET_WINS TEAM_BATTING_H TEAM_BATTING_2B TEAM_BATTING_3B TEAM_BATTING_HR TEAM_BATTING_BB TEAM_BASERUN_SB TEAM_FIELDING_E TEAM_PITCHING_BB TEAM_PITCHING_H TEAM_PITCHING_HR;

data training_imp;
    set training;
    IMP_TEAM_BASERUN_SB =  TEAM_BASERUN_SB;
    I_IMP_TEAM_BASERUN_SB = 0;
    label IMP_TEAM_BASERUN_SB = 'impute TEAM_BASERUN_SB with mean';
    label I_IMP_TEAM_BASERUN_SB = 'indicator of imputation for IMP_TEAM_BASERUN_SB';
    if missing(IMP_TEAM_BASERUN_SB) then do;
        IMP_TEAM_BASERUN_SB = 124.761772;
        I_IMP_TEAM_BASERUN_SB = 1;
    end;

data training_imp_r;
    set training_imp;
    R_TEAM_BATTING_H = TEAM_BATTING_H / 162;
    label R_TEAM_BATTING_H = 'Base Hits by batters per game';
    R_TEAM_BATTING_2B = TEAM_BATTING_2B / 162;
    label R_TEAM_BATTING_2B = 'Doubles by batters per game';
    R_TEAM_BATTING_3B = TEAM_BATTING_3B / 162;
    label R_TEAM_BATTING_3B = 'Triples by batters per game';
    R_TEAM_BATTING_HR = TEAM_BATTING_HR / 162;
    label R_TEAM_BATTING_HR = 'Homeruns by batters per game';
    R_TEAM_BATTING_BB = TEAM_BATTING_BB / 162;
    label R_TEAM_BATTING_BB = 'Walks by batters per game';
    R_TEAM_BASERUN_SB = TEAM_BASERUN_SB / 162;
    label R_TEAM_BASERUN_SB = 'Stolen bases per game';
    R_TEAM_FIELDING_E = TEAM_FIELDING_E / 162;
    label R_TEAM_FIELDING_E = 'Errors per game';
    R_TEAM_PITCHING_BB = TEAM_PITCHING_BB / 162;
    label R_TEAM_PITCHING_BB = 'Walks allowed per game';
    R_TEAM_PITCHING_H = TEAM_PITCHING_H / 162;
    label R_TEAM_PITCHING_H = 'Hits allowed per game';
    R_TEAM_PITCHING_HR = TEAM_PITCHING_HR / 162;
    label R_TEAM_PITCHING_HR = 'Homeruns allowed per game';
    R_IMP_TEAM_BASERUN_SB = IMP_TEAM_BASERUN_SB / 162;
    label R_IMP_TEAM_BASERUN_SB = 'impute TEAM_BASERUN_SB with mean per game';

proc means data=training_imp_r n nmiss mean std range P5 P95;
    var TARGET_WINS TEAM_BATTING_H TEAM_BATTING_2B TEAM_BATTING_3B TEAM_BATTING_HR TEAM_BATTING_BB TEAM_BASERUN_SB TEAM_FIELDING_E TEAM_PITCHING_BB TEAM_PITCHING_H TEAM_PITCHING_HR IMP_TEAM_BASERUN_SB R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_3B R_TEAM_BATTING_HR R_TEAM_BATTING_BB R_TEAM_BASERUN_SB R_TEAM_FIELDING_E R_TEAM_PITCHING_BB R_TEAM_PITCHING_H R_TEAM_PITCHING_HR R_IMP_TEAM_BASERUN_SB;

proc univariate data=training_imp_r normal;
    var TARGET_WINS TEAM_BATTING_H TEAM_BATTING_2B TEAM_BATTING_3B TEAM_BATTING_HR TEAM_BATTING_BB TEAM_BASERUN_SB TEAM_FIELDING_E TEAM_PITCHING_BB TEAM_PITCHING_H TEAM_PITCHING_HR IMP_TEAM_BASERUN_SB R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_3B R_TEAM_BATTING_HR R_TEAM_BATTING_BB R_TEAM_BASERUN_SB R_TEAM_FIELDING_E R_TEAM_PITCHING_BB R_TEAM_PITCHING_H R_TEAM_PITCHING_HR R_IMP_TEAM_BASERUN_SB;
    histogram;

proc univariate data=training_imp_r normal;
    var R_IMP_TEAM_BASERUN_SB R_TEAM_BATTING_2B R_TEAM_BATTING_3B R_TEAM_BATTING_BB R_TEAM_BATTING_H R_TEAM_BATTING_HR R_TEAM_PITCHING_HR;
    histogram;

data training_imp_r_o;
    set training_imp_r;
    if R_TEAM_FIELDING_E < 3.0 then I_R_TEAM_FIELDING_E = 0.0;
    else I_R_TEAM_FIELDING_E = 1;
    label I_R_TEAM_FIELDING_E = 'Outlier Indicator for Errors per game';

    if R_TEAM_PITCHING_BB < 5.4 then I_R_TEAM_PITCHING_BB = 0.0;
    else I_R_TEAM_PITCHING_BB = 1.0;
    label I_R_TEAM_PITCHING_BB = 'Outlier Indicator for Walks allowed per game';

    if R_TEAM_PITCHING_H < 12.6 then I_R_TEAM_PITCHING_H = 0.0;
    else I_R_TEAM_PITCHING_H = 1.0;
    label I_R_TEAM_PITCHING_H = 'Outlier Indicator for Hits allowed per game';

    sqrt_R_IMP_TEAM_BASERUN_SB = sqrt(R_IMP_TEAM_BASERUN_SB);
    log_R_IMP_TEAM_BASERUN_SB = log(R_IMP_TEAM_BASERUN_SB);

    sqrt_R_TEAM_BATTING_3B = sqrt(R_TEAM_BATTING_3B);
    log_R_TEAM_BATTING_3B = log(R_TEAM_BATTING_3B);

    sqrt_R_TEAM_BATTING_BB = sqrt(R_TEAM_BATTING_BB);
    log_R_TEAM_BATTING_BB = log(R_TEAM_BATTING_BB);

    sqrt_R_TEAM_BATTING_H = sqrt(R_TEAM_BATTING_H);
    log_R_TEAM_BATTING_H = log(R_TEAM_BATTING_H);

    sqrt_R_TEAM_BATTING_HR = sqrt(R_TEAM_BATTING_HR);
    log_R_TEAM_BATTING_HR = log(R_TEAM_BATTING_HR);

    sqrt_R_TEAM_PITCHING_HR = sqrt(R_TEAM_PITCHING_HR);
    log_R_TEAM_PITCHING_HR = log(R_TEAM_PITCHING_HR);

    log_TARGET_WINS = log(TARGET_WINS);

data training_imp_r_o_c;
    set training_imp_r_o;
    if I_R_TEAM_FIELDING_E = 1 or I_R_TEAM_PITCHING_BB = 1 or I_R_TEAM_PITCHING_H = 1 then I_UNKNOWN = 1;
    else I_UNKNOWN = 0;

proc freq data=training_imp_r_o_c;
    tables I_R_TEAM_FIELDING_E I_R_TEAM_PITCHING_BB I_R_TEAM_PITCHING_H I_UNKNOWN;

proc univariate data=training_imp_r_o;
    var R_IMP_TEAM_BASERUN_SB sqrt_R_IMP_TEAM_BASERUN_SB log_R_IMP_TEAM_BASERUN_SB R_TEAM_BATTING_2B R_TEAM_BATTING_3B sqrt_R_TEAM_BATTING_3B log_R_TEAM_BATTING_3B R_TEAM_BATTING_BB sqrt_R_TEAM_BATTING_BB log_R_TEAM_BATTING_BB R_TEAM_BATTING_H sqrt_R_TEAM_BATTING_H log_R_TEAM_BATTING_H R_TEAM_BATTING_HR sqrt_R_TEAM_BATTING_HR log_R_TEAM_BATTING_HR R_TEAM_PITCHING_HR sqrt_R_TEAM_PITCHING_HR log_R_TEAM_PITCHING_HR;
    histogram;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_FIELDING_E;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_FIELDING_E I_R_TEAM_FIELDING_E;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_PITCHING_BB;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_PITCHING_BB I_R_TEAM_PITCHING_BB;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_PITCHING_H;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_PITCHING_H I_R_TEAM_PITCHING_H;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_IMP_TEAM_BASERUN_SB;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_IMP_TEAM_BASERUN_SB;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_BATTING_2B;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_BATTING_3B;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_3B;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_BATTING_BB;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_BATTING_H;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_H;

proc reg data=training_imp_r_o;
    model log_TARGET_WINS = R_TEAM_BATTING_H;

proc reg data=training_imp_r_o;
    model log_TARGET_WINS = log_R_TEAM_BATTING_H;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_BATTING_HR;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_HR;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_PITCHING_HR;

proc reg data=training_imp_r_o;
    model TARGET_WINS = sqrt_R_TEAM_PITCHING_HR;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_BB log_R_TEAM_PITCHING_HR R_TEAM_BATTING_HR;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_BB sqrt_R_TEAM_PITCHING_HR R_TEAM_BATTING_HR;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_BB R_TEAM_BATTING_HR;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_BB R_TEAM_BATTING_HR R_TEAM_FIELDING_E I_R_TEAM_FIELDING_E R_TEAM_PITCHING_BB I_R_TEAM_PITCHING_BB;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_BB R_TEAM_FIELDING_E I_R_TEAM_FIELDING_E R_TEAM_PITCHING_BB I_R_TEAM_PITCHING_BB;


proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_FIELDING_E I_R_TEAM_FIELDING_E R_TEAM_PITCHING_BB I_R_TEAM_PITCHING_BB
    / tol vif collin;


proc reg data=training_imp_r_o_c;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_BB R_TEAM_BATTING_HR R_TEAM_FIELDING_E R_TEAM_PITCHING_BB I_UNKNOWN;

proc reg data=training_imp_r_o_c;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_HR R_TEAM_FIELDING_E R_TEAM_PITCHING_BB I_UNKNOWN;

proc reg data=training_imp_r_o_c;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_FIELDING_E R_TEAM_PITCHING_BB I_UNKNOWN;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_TEAM_BATTING_H R_TEAM_BATTING_2B R_TEAM_BATTING_BB R_TEAM_BATTING_HR R_TEAM_FIELDING_E I_R_TEAM_FIELDING_E R_TEAM_PITCHING_BB I_R_TEAM_PITCHING_BB R_TEAM_PITCHING_H I_R_TEAM_PITCHING_H /
    selection=adjrsq aic bic cp best=5;

proc reg data=training_imp_r_o;
 model TARGET_WINS = R_TEAM_FIELDING_E I_R_TEAM_FIELDING_E R_TEAM_PITCHING_BB I_R_TEAM_PITCHING_BB R_TEAM_PITCHING_H I_R_TEAM_PITCHING_H;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_IMP_TEAM_BASERUN_SB R_TEAM_BATTING_2B R_TEAM_BATTING_3B R_TEAM_BATTING_BB R_TEAM_BATTING_H R_TEAM_BATTING_HR R_TEAM_PITCHING_HR /
    selection=adjrsq aic bic cp best=5;

proc reg data=training_imp_r_o;
    model TARGET_WINS = log_R_IMP_TEAM_BASERUN_SB R_TEAM_BATTING_2B log_R_TEAM_BATTING_3B R_TEAM_BATTING_BB log_R_TEAM_BATTING_H R_TEAM_BATTING_HR sqrt_R_TEAM_PITCHING_HR /
    selection=adjrsq aic bic cp best=5;

proc reg data=training_imp_r_o;
    model TARGET_WINS = R_TEAM_FIELDING_E I_R_TEAM_FIELDING_E R_TEAM_PITCHING_BB I_R_TEAM_PITCHING_BB R_TEAM_PITCHING_H I_R_TEAM_PITCHING_H R_IMP_TEAM_BASERUN_SB R_TEAM_BATTING_2B R_TEAM_BATTING_3B R_TEAM_BATTING_BB R_TEAM_BATTING_H R_TEAM_BATTING_HR R_TEAM_PITCHING_HR;

proc sgscatter data=training_imp_r_o;
    plot (TARGET_WINS)*(R_IMP_TEAM_BASERUN_SB R_TEAM_BATTING_2B R_TEAM_BATTING_3B R_TEAM_BATTING_BB);
proc sgscatter data=training_imp_r_o;
    plot (TARGET_WINS)*(R_TEAM_BATTING_H R_TEAM_BATTING_HR R_TEAM_PITCHING_HR);

run;