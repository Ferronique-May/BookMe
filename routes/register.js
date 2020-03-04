const sql = require("mssql/msnodesqlv8");
var router = require('express').Router();
const path = require('path');
const bodyParser = require('body-parser');

router.use(bodyParser.urlencoded({extended : true}));
router.use(bodyParser.json());

const dbConfig = {
  driver: 'msnodesqlv8',
  connectionString: 'Driver={SQL Server Native Client 11.0};Server={localhost\\SQLExpress};Database={test};Trusted_Connection={yes};'
  }

router.get('/', function(req, res) {
    res.sendFile(path.join(__dirname , '../Client/Register.html'));
    console.log(__dirname);
    console.log("Test get....")
});

console.log("hereeeee");
router.post('/' ,function(request, response){
    const FullName = request.body.FullName;
    const Password = request.body.Password;
    const Email = request.body.Email;
    const PhoneNumber = request.body.PhoneNumber;
    const IDNumber = request.body.IDNumber;
    const ConfirmPassword = request.body.ConfirmPassword;
   console.log("Testing......")
    if (Password && FullName && PhoneNumber && Email && IDNumber && ConfirmPassword){
        sql.connect(dbConfig, function(err){
        if(err){
            console.log("Error while connecting database :- " + err);
            response.send(err);
            sql.close();
        }
        else {  
            console.log("connected");                     
            const request = new sql.Request();   
            request.input('fullname', sql.VarChar, FullName);
            request.input('password', sql.VarChar, Password);       
            request.input('email', sql.VarChar, Email);       
            request.input('phonenumber', sql.VarChar, PhoneNumber);
            request.input('idnumber', sql.VarChar, IDNumber);    
            request.query("INSERT INTO Patients (PatientID, FullName, Email, PhoneNumber, PasswordHash) VALUES (@idnumber, @fullname, @email, @phonenumber, @password);",function(error, results){
                if(error){
                    console.log("not inserted into database");
                    console.log(request.body.FullName);
                    response.send("not added to database");
                }
                else{
                    console.log("inserted to database");
                    //response.send("successfully added to database");
                    response.redirect("/");
                }
                sql.close();    
            });            
         }
    });
    }
    else{
        response.send('Please enter Username and Password!');
		response.end();

    }
});


module.exports = router;