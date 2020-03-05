const sql = require("mssql/msnodesqlv8");
var router = require('express').Router();
const path = require('path');
const bodyParser = require('body-parser');

router.use(bodyParser.urlencoded({extended : true}));
router.use(bodyParser.json());

const dbConfig = {
  driver: 'msnodesqlv8',
  connectionString: 'Driver={SQL Server Native Client 11.0};Server={localhost\\SQLExpress};Database={BookMeDB};Trusted_Connection={yes};'
  }

router.get('/', function(req, res) {
    res.sendFile(path.join(__dirname , '../Client/Register.html'));
});

router.post('/' ,function(request, response){
    const FullName = request.body.FullName;
    const Password = request.body.Password;
    const Email = request.body.Email;
    const PhoneNumber = request.body.PhoneNumber;
    const IDNumber = request.body.IDNumber;
    const ConfirmPassword = request.body.ConfirmPassword;
    const Role = request.body.optradio;
    // response.send(request.body.optradio);
    // response.send(request.body.optradio);
   
    if (Password && FullName && PhoneNumber && Email && IDNumber && ConfirmPassword && Role){
        sql.connect(dbConfig, function(err){
        if(err){
            console.log("Error while connecting database :- " + err);
            response.send(err);
            sql.close();
        }
        else {                   
            const request = new sql.Request();   
            request.input('FullName', sql.VarChar, FullName);
            request.input('Password', sql.VarChar, Password);       
            request.input('Email', sql.VarChar, Email);       
            request.input('PhoneNumber', sql.VarChar, PhoneNumber);
            request.input('IDNumber', sql.VarChar, IDNumber); 
            if(Role == 0){ 
                request.query("INSERT INTO Patients (PatientID, FullName, Email, PhoneNumber, PasswordHash) VALUES (@IDNumber, @FullName, @Email, @PhoneNumber, @Password);",function(error, results){
                    if(error){
                        console.log("not inserted into database");
                        response.send("not added to database");
                    }
                    else{
                        console.log("inserted patient to database");
                        response.redirect("/");
                    }
                    sql.close();    
                });            
         }
        else if(Role == 1){
            request.query("INSERT INTO Doctors (DoctorID, FullName, Email, PhoneNumber, PasswordHash) VALUES (@IDNumber, @FullName, @Email, @PhoneNumber, @Password);",function(error, results){
                if(error){
                    console.log("not inserted into database");
                    response.send("not added to database");
                }
                else{
                    console.log("inserted doctor to database");
                    response.redirect("/");
                }
                sql.close();    
            });

        }}
         
    });
    }
    else{
        response.send('Please enter Username and Password!');
		response.end();

    }
});


module.exports = router;