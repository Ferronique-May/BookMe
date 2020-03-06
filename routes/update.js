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
    res.sendFile(path.join(__dirname , '../Client/Update.html'));
});

router.post("/", async (req, res) => {
  let data = {};
  try {
    const requested = req.body;
    console.log(requested.AppointmentID)
      await InsertUpdateDeleteAppointment(
    requested.datetime,
    requested.Description,
    requested.AppointmentID
    )
    
    data.success = true;
  } catch (e) {
    data.success = false;
  } finally {
    res.setHeader("content-type", "application/json");
    res.redirect("/viewAppointment");
  }
});

function InsertUpdateDeleteAppointment(bookDate,description,appointmentID){
  const connection = new sql.ConnectionPool(dbConfig);
  const request = new sql.Request(connection);
  request.input('AppointmentID', sql.Int, appointmentID); 
  request.input('BookDate', sql.DateTime, bookDate);      
  request.input('Description', sql.VarChar,description);       
  connection.connect(function(err){

      if(err){
          console.log(err)
          return    
      }
      request.query("UPDATE Appointments SET AppointmentDateTime =@BookDate, AppointmentDescription = @Description WHERE AppointmentID = @AppointmentID",function(err,data){
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
