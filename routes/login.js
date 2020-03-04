var router = require('express').Router();
var crypto = require('crypto');
const sql = require("mssql/msnodesqlv8");
const path = require('path');
const bodyParser = require('body-parser');

router.use(bodyParser.urlencoded({extended : true}));
router.use(bodyParser.json());

const dbConfig = {
  driver: 'msnodesqlv8',
  connectionString: 'Driver={SQL Server Native Client 11.0};Server={localhost\\SQLExpress};Database={BookMeDB};Trusted_Connection={yes};'
  }

router.get('/', function(req, res) {
    res.sendFile(path.join(__dirname , '../Client/Login.html'));
});

router.post('/' ,function(request, response){
    // var Password = req.body.Password;
    const Email = request.body.Email;
    const Password = request.body.Password;
    var hash = crypto.createHash('md5').update(Password).digest('hex');
    const Role = request.body.optradio;
   
    if (Email && Password && Role){
        sql.connect(dbConfig, function(err){
        if(err){
            console.log("Error while connecting database :- " + err);
            response.send(err);
            sql.close();
        }
        else {                       
            const request = new sql.Request();   
            request.input('email', sql.VarChar, Email);
            request.input('password', sql.VarChar, hash);       

            if (Role == 0){       
            request.query("SELECT * FROM Patients WHERE Email = @email AND PasswordHash = @password",function(error, results){
                if(results.recordsets < 1){
                    console.log("failed");
                    response.send("Wrong username or password");
                }
                else{
                    console.log("found patient");
                    response.send("successfuly logged patient in");
                }
                sql.close();    
            });
        }else if(Role == 1){
            request.query("SELECT * FROM Doctors WHERE Email = @email AND PasswordHash = @password",function(error, results){
                if(results.recordsets < 1){
                    console.log("failed");
                    response.send("Wrong username or password");
                }
                else{
                    console.log("found doctor");
                    response.send("successfuly logged doctor in");
                }
                sql.close();    
            });
        }            
         }
    });
    }
    else{
        response.send('Please enter Username and Password!');
		response.end();

    }
});

module.exports = router;