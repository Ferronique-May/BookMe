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
router.post("/", async (req, res) => {
    let data = {};
    try {
      const requested = req.body;
      await InsertUpdateDeletePatient('INSERT',
      requested.IDNumber,
      requested.FullName,
      requested.Email,
      requested.PhoneNumber,
      requested.Password
      )
      data.success = true;
    } catch (e) {
      data.success = false;
    } finally {
      res.setHeader("content-type", "application/json");
      res.redirect("/");
    }
  });


function InsertUpdateDeletePatient(statementType,PatientID,fullname,email,phonenumber,password){
    const connection = new sql.ConnectionPool(dbConfig);
    const request = new sql.Request(connection);
    request.input('StatemetType', sql.VarChar, statementType);
    request.input('PatientID', sql.VarChar, PatientID);
    request.input('Fullname', sql.VarChar, fullname);       
    request.input('Email', sql.VarChar, email);       
    request.input('Phonenumber', sql.VarChar, phonenumber);
    request.input('Password', sql.VarChar, password); 
    connection.connect(function(err){

        if(err){
            console.log(err)
            return    
        }

        request.query("EXEC SP_InsertUpdateDeletePatient @StatemetType,@PatientID,@Fullname,@Email,@PhoneNumber,@Password",function(err,data){
            if(err){
                console.log('FAIL......')
            }else{
                console.log(data.recordset)
            } 
            connection.close();
        })
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


    })
}

module.exports = router;