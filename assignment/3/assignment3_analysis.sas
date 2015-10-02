libname four11 '/scs/wtm926/' access=readonly;

Data eda;
  set four11.wine;

proc contents data=eda;

proc univariate data=eda normal;
    var target;
    histogram;

proc means data=eda n nmiss mean var;
    var acidindex alcohol chlorides citricacid density fixedacidity freesulfurdioxide labelappeal residualsugar stars sulphates totalsulfurdioxide volatileacidity ph;

proc means data=eda n nmiss mean var;
    var acidindex alcohol chlorides citricacid density fixedacidity freesulfurdioxide labelappeal residualsugar stars sulphates totalsulfurdioxide volatileacidity ph;
    class target;

proc means data=eda n nmiss mean var;
    var acidindex alcohol chlorides citricacid density fixedacidity freesulfurdioxide residualsugar sulphates totalsulfurdioxide volatileacidity ph;

proc univariate data=eda normal;
    var acidindex alcohol chlorides citricacid density fixedacidity freesulfurdioxide labelappeal residualsugar stars sulphates totalsulfurdioxide volatileacidity ph;
    histogram;

data imp_eda;
    set eda;

    imp_alcohol = alcohol;
    i_imp_alcohol = 0;
    if missing(imp_alcohol) then do;
        imp_alcohol = 10.4892363;
        i_imp_alcohol = 1;
    end;

    imp_chlorides = chlorides;
    i_imp_chlorides = 0;
    if missing(imp_chlorides) then do;
        imp_chlorides = 0.0548225;
        i_imp_chlorides = 1;
    end;

    imp_freesulfurdioxide = freesulfurdioxide;
    i_imp_freesulfurdioxide = 0;
    if missing(imp_freesulfurdioxide) then do;
        imp_freesulfurdioxide = 30.8455713;
        i_imp_freesulfurdioxide = 1;
    end;

    imp_residualsugar = residualsugar;
    i_imp_residualsugar = 0;
    if missing(imp_residualsugar) then do;
        imp_residualsugar = 5.4187331;
        i_imp_residualsugar = 1;
    end;

    imp_stars = stars;
    i_imp_stars = 0;
    if missing(imp_stars) then do;
        imp_stars = 2.0;
        i_imp_stars = 1;
    end;

    imp_sulphates = sulphates;
    i_imp_sulphates = 0;
    if missing(imp_sulphates) then do;
        imp_sulphates = 0.5271118;
        i_imp_sulphates = 1;
    end;

    imp_totalsulfurdioxide = totalsulfurdioxide;
    i_imp_totalsulfurdioxide = 0;
    if missing(imp_totalsulfurdioxide) then do;
        imp_totalsulfurdioxide = 120.7142326;
        i_imp_totalsulfurdioxide = 1;
    end;

    imp_ph = ph;
    i_imp_ph = 0;
    if missing(imp_ph) then do;
        imp_ph = 3.2076282;
        i_imp_ph = 1;
    end;

proc means data=imp_eda n nmiss mean var;
    var acidindex imp_alcohol imp_chlorides citricacid density fixedacidity imp_freesulfurdioxide labelappeal imp_residualsugar imp_stars imp_sulphates imp_totalsulfurdioxide volatileacidity imp_ph;

proc freq data=eda;
    tables target*labelappeal;
proc freq data=eda;
    tables target*stars;

proc univariate data=eda normal;
    var acidindex imp_alcohol imp_chlorides citricacid density fixedacidity imp_freesulfurdioxide labelappeal imp_residualsugar imp_stars imp_sulphates imp_totalsulfurdioxide volatileacidity imp_ph;
    histogram;


proc corr data=imp_eda rank plots=all;
    var acidindex imp_alcohol imp_chlorides citricacid density fixedacidity imp_freesulfurdioxide labelappeal imp_residualsugar imp_stars i_imp_stars imp_sulphates imp_totalsulfurdioxide volatileacidity imp_ph;
    with target;

proc freq data=imp_eda;
    tables target*i_imp_stars;
proc freq data=imp_eda;
    tables target*imp_stars;
proc freq data=imp_eda;
    tables target*labelappeal;

proc sort data=imp_eda out=zero_check;
    by acidindex;

proc freq data=zero_check;
    table target / plots(only)=freqplot(scale=percent);
    by acidindex;

proc genmod data=imp_eda;
    class labelappeal imp_stars i_imp_stars;
    model target = acidindex labelappeal imp_stars i_imp_stars / link=log dist=poi;
    output out=imp_eda p=pr1;

proc genmod data=imp_eda;
    class labelappeal imp_stars i_imp_stars;
    model target = acidindex labelappeal imp_stars i_imp_stars / link=log dist=nb;
    output out=imp_eda p=nbr1;

proc genmod data=imp_eda;
    class labelappeal imp_stars i_imp_stars;
    model target = acidindex labelappeal imp_stars i_imp_stars / link=log dist=ZIP;
    zeromodel acidindex i_imp_stars / link=logit;
    output out=imp_eda p=zip1;

proc genmod data=imp_eda;
    class labelappeal imp_stars i_imp_stars;
    model target = acidindex labelappeal imp_stars i_imp_stars / link=log dist=ZIP;
    zeromodel acidindex i_imp_stars / link=logit;
    output out=imp_eda p=zip1 pzero=zzip1;

proc genmod data=imp_eda;
    class labelappeal imp_stars i_imp_stars;
    model target = acidindex labelappeal imp_stars i_imp_stars / link=log dist=ZINB;
    zeromodel acidindex i_imp_stars / link=logit;
    output out=imp_eda p=zinb1 pzero=zzinb1;

proc reg data=imp_eda;
    model target = acidindex labelappeal imp_stars i_imp_stars;
    output out=imp_eda p=yhat;

proc genmod data=imp_eda;
    class labelappeal imp_stars i_imp_stars;
    model target = acidindex labelappeal imp_stars i_imp_stars / link=identity dist=normal;
    output out=imp_eda p=ols1;

proc print data=imp_eda (obs=20);
    var target pr1 nbr1 zip1 zinb1 yhat ols1;


run;