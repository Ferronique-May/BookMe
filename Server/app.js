var express = require('express');
var app = express();

app.use('/', require('../routes/login'));
app.use('/register', require('../routes/register'))

app.listen('3000');