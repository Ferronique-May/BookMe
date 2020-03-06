var express = require('express');
var app = express();
app.use('/', require('../routes/index'));
app.use('/login', require('../routes/login'));
app.use('/register', require('../routes/register'))
app.use('/registerDoctor', require('../routes/doctorRegister'))
app.use('/viewDoctors', require('../routes/views'))
app.use('/doctors', require('../routes/viewAllDoctors'))
app.use('/viewAllPatients', require('../routes/viewAllPatients'))
app.use('/appointment', require('../routes/appointment'))
app.use('/update', require('../routes/update'))
app.use('/cancel', require('../routes/cancel'))
app.use('/thankyou', require('../routes/thankyou'))
app.use('/viewAppointment', require('../routes/viewAppointment'))

app.listen('3000');