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
    res.sendFile(path.join(__dirname , '../Client/AppointmentDate.html'));
});

router.post("/", async (req, res) => {
  let data = {};
  try {
    const requested = req.body;
    console.log(requested.datetime)
      await InsertUpdateDeleteAppointment('INSERT',
    requested.datetime,
    requested.Description,
    requested.PatientID,
    requested.DoctorID
  
    )
    
    data.success = true;
  } catch (e) {
    data.success = false;
  } finally {
    res.setHeader("content-type", "application/json");
    res.redirect("/viewAppointment");
  }
});

function InsertUpdateDeleteAppointment(statementType,bookDate,description,patientID,doctorID){
  const connection = new sql.ConnectionPool(dbConfig);
  const request = new sql.Request(connection);
  request.input('StatemetTypes', sql.VarChar, statementType);
  request.input('DoctorID', sql.VarChar, doctorID);
  request.input('PatientID', sql.VarChar, patientID); 
  request.input('BookDate', sql.DateTime, bookDate);      
  request.input('Description', sql.VarChar,description);       
  connection.connect(function(err){

      if(err){
          console.log(err)
          return    
      }
      request.query("EXEC SP_InsertUpdateDeleteAppointment @StatementType=@StatemetTypes,@appointmentDateTime=@BookDate,@appointmentDescription=@Description,@PatientIDforPatientAppointments=@PatientID,@DoctorIDforPatientAppointments=@DoctorID",function(err,data){
          if(err){
              console.log('FAIL......')
          }else{
              console.log("Successful")
          } 
          connection.close();
      })
 })
}

module.exports = router;
