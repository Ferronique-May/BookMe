var express = require('express');
var app = express();

app.use('/', require('../routes/login'));
app.use('/register', require('../routes/register'))
app.use('/doctor', require('../routes/doctorAppointment'))

app.listen('3000');