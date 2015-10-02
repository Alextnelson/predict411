libname four11 '/scs/wtm926/' access=readonly;

data testing;
    set four11.moneyball_test;

data testing_fixed;
    set testing;
    R_TEAM_BATTING_H = TEAM_BATTING_H / 162;
    label R_TEAM_BATTING_H = 'Base Hits by batters per game';
    R_TEAM_BATTING_2B = TEAM_BATTING_2B / 162;
    label R_TEAM_BATTING_2B = 'Doubles by batters per game';
    R_TEAM_FIELDING_E = TEAM_FIELDING_E / 162;
    label R_TEAM_FIELDING_E = 'Errors per game';
    R_TEAM_PITCHING_BB = TEAM_PITCHING_BB / 162;
    label R_TEAM_PITCHING_BB = 'Walks allowed per game';
    R_TEAM_BATTING_BB = TEAM_BATTING_BB / 162;
    label R_TEAM_BATTING_BB = 'Walks by batters per game';
    R_TEAM_BATTING_HR = TEAM_BATTING_HR / 162;
    label R_TEAM_BATTING_HR = 'Homeruns by batters per game';

    if R_TEAM_FIELDING_E < 3.0 then I_R_TEAM_FIELDING_E = 0.0;
    else I_R_TEAM_FIELDING_E = 1;
    label I_R_TEAM_FIELDING_E = 'Outlier Indicator for Errors per game';

    if R_TEAM_PITCHING_BB < 5.4 then I_R_TEAM_PITCHING_BB = 0.0;
    else I_R_TEAM_PITCHING_BB = 1.0;
    label I_R_TEAM_PITCHING_BB = 'Outlier Indicator for Walks allowed per game';

    log_R_TEAM_BATTING_H = log(R_TEAM_BATTING_H);

data testing_score;
    set testing_fixed;
    y_hat = -93.82574 + 73.62327 * log_R_TEAM_BATTING_H - 3.08370 * R_TEAM_BATTING_2B + 4.67320 * R_TEAM_BATTING_BB + 3.21896 * R_TEAM_BATTING_HR;
    y_hat1 = -107.05903 + 91.54902 * log_R_TEAM_BATTING_H - 7.48343 * R_TEAM_BATTING_2B - 6.40908 * R_TEAM_FIELDING_E + 14.83384 * I_R_TEAM_FIELDING_E + 1.66236 * R_TEAM_PITCHING_BB - 7.00469 * I_R_TEAM_PITCHING_BB;
    keep index y_hat y_hat1;

proc print data=testing_score;

proc export data=testing_score
    outfile='/sscc/home/a/agd808/sasuser.v94/411/1/out.csv'
    dbms=csv
    replace;

run;