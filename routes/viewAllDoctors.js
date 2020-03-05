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
  //////////////////////////////////////////////////////////////////////////////////
    const userEmail = req.session.Email;
    if (userEmail){
      console.log("logged in " + userEmail);
      res.sendFile(path.join(__dirname , '../Client/ViewAllDoctors.html'));
    }
    else{
      console.log("not logged in");
      res.redirect("/");
    }
    ///////////////////////////////////////////////////////////////////////////////
});

router.get("/", async (req, res) => {
    try {
        const connection = new sql.ConnectionPool(dbConfig);
        const request = new sql.Request(connection);
        connection.connect(function(err){
    
            if(err){
                console.log(err)
                return    
            }
            request.query("SELECT * FROM VIEW_AllDoctorsSpecialization",function(err,data){
                if(err){
                    console.log('FAIL......')
                }
                console.log(data)
                res.send(data.recordset)
                connection.close();
            })
       })
    } catch (e) {
      res.send(e);
    }
  });

module.exports = router;