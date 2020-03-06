const sql = require("mssql/msnodesqlv8");
var router = require('express').Router();
const path = require('path');
const bodyParser = require('body-parser');

router.use(bodyParser.urlencoded({extended : false}));
router.use(bodyParser.json());

router.get('/', function(req, res) {
    res.sendFile(path.join(__dirname , '../Client/Thankyou.html'));
});
module.exports = router;