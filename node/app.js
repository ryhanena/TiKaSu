
// node.js example for Tietokantojen suunnittelu
//
// Install required packages (see package.json) by running: npm install
//
// Edit connectionString in util.js with your postgresql information: 
// var connectionString = "postgres://user:pass@localhost:port/dbname";
//
// Start node server: node app.js
// Quick test in linux-desktop.cc.tut.fi on command line by typing: curl tkannatX.cs.tut.fi:8888
//
// Note! 
// - To execute any changes on the source code, you must restart the node server. 
// - Pug files can be modified without restart.
// - Any unhandled error will crash the server.
/* TODO (käyttötapaukset 1.5-1.7)
* Laskutus
** Lisääminen, muokkaaminen, lähettäminen, poistaminen, karhulaskun lisääminen
* Kuukausiraportin lähettäminen
* Mainosesitysraportin lähettäminen

* Kirjautuminen, ei toimi vielä, syy UNKNOWN 
*/

//Mainoskampanjat
const defaultQuery = "SELECT kampanjaid, vat_tunnus, kampanjanimi, tila FROM Mainoskampanja";
const dropDownQuery = "SELECT kampanjaid, vat_tunnus, kampanjanimi, tila from Mainoskampanja";

//Perus raportti
const defaultQueryKR = "SELECT DISTINCT mainostajan_nimi,esityspaiva, kokonaishinta FROM kuukausiraportti ORDER BY esityspaiva DESC";
const dropDownQueryKR = "SELECT DISTINCT mainostajan_nimi,esityspaiva, kokonaishinta FROM kuukausiraportti ORDER BY esityspaiva DESC";

const defaultQueryMER = "SELECT DISTINCT mnimi, mainostajanimi, kampanjanimi, paikkakunta, genrennimi, sposti FROM mainosesitysraportti";
const dropDownQueryMER = "SELECT DISTINCT mnimi, mainostajanimi, kampanjanimi, paikkakunta, genrennimi, sposti FROM mainosesitysraportti";

//maksamattomat laskut
const defaultQueryLN = "SELECT * FROM Lasku WHERE maksettu = FALSE ORDER BY erapvm ASC";
const dropDownQueryLN = "SELECT * FROM Lasku WHERE maksettu = FALSE ORDER BY erapvm ASC";                        


var util = require('./util');
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false }));



app.set('views', './views');
app.set('view engine', 'pug');


//käyttäjän kirjautumiseen
const basicAuth = require('express-basic-auth');
app.use(basicAuth({
    users: {admin: '123'},
    challenge: true
}))

const session = require('express-session');
app.use(session({
    secret: 'secretestKeyest',
    resave: true,
    saveUninitialized: true
}))

var passport = require('passport');
app.use(passport.initialize());
app.use(passport.session());
const LocalStrategy = require('passport-local').Strategy;
const bcrypt = require('bcrypt');

// route - HTTP GET to http://tkannatX.cs.tut.fi:8888/    
app.get('/', function (req, res) {
    
    var resultCollector = {};
    util.runDbQuery("", buildDropdown, res, resultCollector, "") 
    /*if (req.isAuthenticated()){
        util.runDbQuery("", buildDropdown, res, resultCollector, "")    
    }
    else {
        res.render('/kirjautuminen', {title: "Kirjaudu", userData: req.user});
    }*/
});

app.get('/kuukausiraportti', function(req,res){
    var resultCollector = {};
    util.runDbQuery(dropDownQueryKR, buildDropdownKR, res, resultCollector, defaultQueryKR);
})

app.get('/mainosesitysraportti', function(req,res) {
    var resultCollector = {};
    util.runDbQuery(dropDownQueryMER, buildDropdownMER, res, resultCollector, defaultQueryMER);
})

app.get('/laskutusnakyma', function(req,res){
    var resultCollector = {};
    
    util.runDbQuery(dropDownQueryLN, buildDropdownLN, res, resultCollector, defaultQueryLN);
})

app.get('/laskutusnakyma/lisays', function(req,res){
    var resultCollector = {};
    //näkymä
    var query = "SELECT kampanjaid, kampanjanimi FROM mainoskampanja"+
        " WHERE 'mainoskampanja.tila' = 'TRUE'"+
        "AND NOT EXISTS (SELECT * FROM lasku "+
        "WHERE 'lasku.mainoskampanjaID' = 'mainoskampanja.kampanjaid')";

    util.runDbQuery(query, buildLahettamattomat, res, resultCollector, query);

    function buildLahettamattomat(turha, dbResult, res, turha, resultCollector) {
        resultCollector.uusilaskuresult = dbResult;
        resultCollector.title = 'Laskutus';
        resultCollector.message = 'Laskutusviesti';
    
        laskutusResult = dbResult;
    
        res.render('laskutusnakyma', resultCollector);
      }
})





// buildDropdown - add some dropdown menu items and continue with a query written on the textfield.
// Parameters:
// query: the query to continue with
// dbResult: results of database query, these are added to dropdown menu
// res: HTTP response
// err: database error message 
// resultCollector: collecting content to be rendered
function buildDropdown(query, dbResult, res, err, resultCollector, postQuery) {

    if(dbResult && 'rows' in dbResult) {
        resultCollector.dropdown = dbResult.rows;
    }
    // continue with a query written on the textfield.
    util.runDbQuery(postQuery, buildHtml, res, resultCollector);
}

function buildDropdownKR(query, dbResult, res, err, resultCollector,postQuery) {
    if(dbResult && 'rows' in dbResult) {
        resultCollector.dropdown = dbResult.rows;
    }

    util.runDbQuery(postQuery, buildHtmlKR, res, resultCollector);
}

function buildDropdownLN(query, dbResult, res, err, resultCollector, postQuery) {

    if(dbResult && 'rows' in dbResult) {
        resultCollector.dropdown = dbResult.rows;
    }
    // continue with a query written on the textfield.
    util.runDbQuery(postQuery, buildHtmlLN, res, resultCollector);
}

function buildDropdownMER(query, dbResult, res, err, resultCollector,postQuery) {
    if(dbResult && 'rows' in dbResult) {
        resultCollector.dropdown = dbResult.rows;
    }

    util.runDbQuery(postQuery, buildHtmlMER, res, resultCollector);
}

// buildHtml - create HTML form and show SQL query results in HTML table.
// Parameters:
// query: text query to the form from HTTP POST
// dbResult: result of database query
// res: HTTP response
// err: database error message
// resultCollector: collecting content to be rendered 
function buildHtml(query, dbResult, res, err, resultCollector) {
    resultCollector.result = dbResult;
    resultCollector.title = 'iFlac';
    resultCollector.query = query;
    resultCollector.error = err;

    //send the content to a view named 'frontpage' 
    res.render('frontpage', resultCollector);
}

function buildHtmlLN(query, dbResult, res, err, resultCollector) {
    resultCollector.resultLaskut = dbResult;
    resultCollector.title = 'Laskutusnäkymä';
    resultCollector.query = query;
    resultCollector.error = err;

    //send the content to a view named 'laskutusnakyma' 
    res.render('laskutusnakyma', resultCollector);
}

function buildHtmlKR(query, dbResult, res, err, resultCollector) {
    resultCollector.result = dbResult;
    resultCollector.title = 'Kuukausiraportti';
    resultCollector.query = query;
    resultCollector.error = err;

    //send the content to a view named 'kuukausiraportti'
    res.render('kuukausiraportti', resultCollector);
}

function buildHtmlMER(query, dbResult, res, err, resultCollector) {
    resultCollector.result = dbResult;
    resultCollector.title = 'Mainosesitysraportti';
    resultCollector.query = query;
    resultCollector.error = err;

    //send the content to a view named 'mainosesitysraportti'
    res.render('mainosesitysraportti', resultCollector);
}

app.post('/kuukausiraportti', function(req, res) {
    var resultCollector = {};
    var kk = req.body.kk;
    var vuosi = req.body.vuosi;
    var nimi = req.body.nimi;
    var alaraja = vuosi+"-"+kk+"-01";
    var ylaraja = vuosi+"-"+kk+"-31";
    if (kk == 2){
        ylaraja = vuosi+"-"+kk+"-28"; //helmikuu
    }
    if (kk==4||kk==6||kk==9||kk==11){
        ylaraja = vuosi+"-"+kk+"-30"; //30pv kuussa
    }
    var query = "SELECT DISTINCT mainostajan_nimi, esityspaiva, mainoksen_pituus,"+
    " kokonaishinta, toistokerrat "+
    "FROM kuukausiraportti WHERE mainostajan_nimi = '"+nimi+"' "+
    "AND esityspaiva >= '"+alaraja+"' AND esityspaiva <= '"+ylaraja+"'"
    "ORDER BY esityspaiva DESC";
    // esitysaika, pituus, toistomäärä, hinta
    util.runDbQuery(query, buildHtmlKR, res, resultCollector, query);
})


app.post('/mainosesitysraportti', function(req,res) {
    var resultCollector = {};

    var mainoksennimi = req.body.mainoksennimi;
    var esityspaiva = "";
    var sukupuoli = "";
    var ika = "";
    var maa = "";
    var paikkakunta = "";
    var genre = "";
    var esittaja = "";
    var kappale = "";
    var lause = "";

    if (req.body.esityspaiva == "on"){esityspaiva = "esityspaiva,"};
    if (req.body.sukupuoli == "on"){sukupuoli = "spuoli,"};
    if (req.body.ika == "on"){ika = "ika,"};
    if (req.body.maa == "on"){maa = "maa,"};
    if (req.body.paikkakunta == "on"){paikkakunta = "paikkakunta,"};
    if (req.body.genre == "on"){genre = "genrennimi,"};
    if (req.body.esittaja == "on"){esittaja = "nimi,"};
    if (req.body.kappale == "on"){kappale = "knimi,"};

    lause = esityspaiva+sukupuoli+ika+maa+paikkakunta+genre+esittaja+kappale;
    // Delete last ',' from select sentence 'lause'
    lause = lause.slice(0, -1);

    var query = "SELECT DISTINCT "+lause+
    " FROM mainosesitysraportti WHERE mnimi = '"+mainoksennimi+"'";
    console.log(query);
    util.runDbQuery(query, buildHtmlMER, res, resultCollector, query);
})
app.get('/kirjautuminen', function(req,res,next) {
    if (req.isAuthenticated()) {
        res.redirect('/');
    }
    else{
        console.log('Ei onnistunut');
        res.render('/kirjautuminen', {title: "Kirjaudu", userData: req.user});
    }
})

app.post('/kirjautuminen', passport.authenticate('local', {
    
    successRedirect: '/',
    failureRedirect: '/kirjautuminen'
    
}), function(req,res){
    if (req.body.remember) {
        req.session.cookie.maxAge = 30* 24 * 60 * 60 * 1000;
    } else {
        req.session.cookie.expires = false;
    }
    res.redirect('/');
})
// Ei pääse tänne asti jostain syystä...
passport.use('local', new LocalStrategy({passReqToCallback : true}, (req, username, password, done)=>{
    loginAttempt();
    console.log('testitesti');
    async function loginAttempt(){
        const client = await pool.connect()
        try{
            await client.query('BEGIN')
            var currentAccountsData = await JSON.stringify(client.query("SELECT knimi, salasana"+
            "FROM 'kayttaja' WHERE 'knimi'=$1", [username], function(err, result){
                console.log(currentAccountsData);
                if(err){
                    return done(err)
                }
                if (result.rows[0] == null){
                    console.log('Vihkoon meni', "Rikki on");
                    return done(null, false);
                }
                else{
                    bcrypt.compare(password, result.rows[0].password, function(err, check){
                        if (err){
                            console.log('Vaara salasana, pilalla');
                            return done;
                        }
                        else if (check){
                            return done(null, [{knimi: result.rows[0].knimi}]);
                        }
                        else{
                            console.log('vihkoon meni taas', "noniin");
                            return done(null,false);
                        }
                    })
                }
            }));
        }
        catch(e){throw(e);}
    }
}))

passport.serializeUser(function(user, done) {
    done(null, user);
})
passport.deserializeUser(function(user, done) {
    done(null, user);
})


// route - HTTP POST to http://tkannatX.cs.tut.fi:8888/    
app.post('/', function (req, res) {

    var resultCollector = {};

    // Use builDropdown function as a callback function
    // because it needs to be executed after the db query.   
    util.runDbQuery(dropDownQuery, buildDropdown, res, resultCollector, req.body.query);    
});


// Binds and listens for connections on the specified port.
app.listen(8888, function () {
    console.log('App listening on port 8888');
});