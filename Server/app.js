var express = require('express');
var app = express();

app.use('/', require('../routes/login'));
app.use('/register', require('../routes/register'))
app.use('/registerDoctor', require('../routes/doctorRegister'))
app.use('/viewDoctors', require('../routes/viewAllDoctors'))
app.use('/appointment', require('../routes/appointment'))

app.listen('3000');