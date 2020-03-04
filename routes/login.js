var router = require('express').Router();
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
    console.log(__dirname);
});

router.post('/' ,function(request, response){
    const Email = request.body.Email;
    const Password = request.body.Password;
   
    if (Email && Password){
        sql.connect(dbConfig, function(err){
        if(err){
            console.log("Error while connecting database :- " + err);
            response.send(err);
            sql.close();
        }
        else {  
            console.log("connected");                     
            const request = new sql.Request();   
            request.input('email', sql.VarChar, Email);
            request.input('password', sql.VarChar, Password);       
            request.query("SELECT * FROM Patients WHERE Email = @email AND PasswordHash = @password",function(error, results){
                if(results.recordsets < 1){
                    console.log("failed");
                    response.send("Wrong username or password");
                }
                else{
                    console.log("found");
                    response.send("successfuly logged in");
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