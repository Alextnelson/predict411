libname four11 '/scs/wtm926/' access=readonly;

Data testing;
  set four11.wine_test;

data testing_fixed;
    set testing;

    imp_stars = stars;
    i_imp_stars = 0;
    if missing(imp_stars) then do;
        imp_stars = 2.0;
        i_imp_stars = 1;
    end;

data testing_score;
    set testing_fixed;

    TEMP = -3.3657
    + AcidIndex * 0.4637
    + (i_imp_stars in (0)) * -3.4689;

    P_SCORE_ZERO = exp(TEMP) / (1 + exp(TEMP));

    temp = 1.8705
    + AcidIndex * -0.0214
    + (LabelAppeal in (-2)) * -0.9704
    + (LabelAppeal in (-1)) * -0.6029
    + (LabelAppeal in (0)) * -0.3409
    + (LabelAppeal in (1)) * -0.1574
    + (imp_stars in (1)) * -0.4068
    + (imp_stars in (2)) * -0.1999
    + (imp_stars in (3)) * -0.1046
    + (i_imp_stars in (0)) * 0.1854;

    P_SCORE_ZIP_ALL = exp(TEMP);

    P_TARGET = P_SCORE_ZIP_ALL * (1 - P_SCORE_ZERO);
    P_TARGET_ROUND = round(P_TARGET,1);

    keep index P_TARGET P_TARGET_ROUND;


proc export data=testing_score
    outfile='/sscc/home/a/agd808/sasuser.v94/411/3/out.csv'
    dbms=csv
    replace;