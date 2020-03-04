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
    res.sendFile(path.join(__dirname , '../public/register.html'));
    console.log(__dirname);
    console.log("Test get....")
});

console.log("hereeeee");
router.post('/' ,function(request, response){
    const fullname = request.body.fullname;
    const password = request.body.password;
    const email = request.body.email;
    const phonenumber = request.body.phonenumber;
   console.log("Testing......")
    if (password && fullname && phonenumber && email){
        sql.connect(dbConfig, function(err){
        if(err){
            console.log("Error while connecting database :- " + err);
            response.send(err);
            sql.close();
        }
        else {  
            console.log("connected");                     
            const request = new sql.Request();   
            request.input('fullname', sql.VarChar, fullname);
            request.input('password', sql.VarChar, password);       
            request.input('email', sql.VarChar, email);       
            request.input('phonenumber', sql.VarChar, phonenumber);       
            request.query("INSERT INTO Users (UserName, UserPassword) VALUES (@fullname, @password);",function(error, results){
                if(error){
                    console.log("not inserted into database");
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