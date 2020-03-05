var express = require('express');
var app = express();
const bodyParser = require('body-parser');
var session = require('express-session');

app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());
////////////////////////////////////////////////////////
app.use(session({
    secret:'youtube_video',
    resave: false,
    saveUninitialized: false,
    cookie: {
        maxAge: 60 * 1000 * 30
    }
}));
//////////////////////////////////////////////////////
app.use('/', require('../routes/login'));
app.use('/register', require('../routes/register'))
app.use('/registerDoctor', require('../routes/doctorRegister'))
app.use('/viewDoctors', require('../routes/viewAllDoctors'))
app.use('/appointment', require('../routes/appointment'))

app.listen('3000');