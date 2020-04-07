const express = require('express');
const db = require('./database/db');
const equipment = require('./models/equipment');
const team = require('./models/team')
const bodyParser = require('body-parser');
const storageTypes = require('./constants')

const PORT = '5000';

const app = express();

app.use(bodyParser.urlencoded({ extended: false }));

app.use(bodyParser.json());

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", `http://localhost:3000`);
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

db.authenticate()
  .then(() => {
    console.log('Connection has been established!')
  })
  .catch((err) => {
    console.log('Unable to establish connection, error: ', err)
  })

app.get('/load_data', async (req, res) => {
  const { storageType } = req.query;
  let result;

  switch (storageType) {
    case storageTypes.STORAGE_TYPE_TEAM:
      result = await team.findAll().then(res => res)
      break;
    case storageTypes.STORAGE_TYPE_EQUIPMENT:
      result = await equipment.findAll().then(res => res)
      break;

    default:
      result = []
  }

  res.json(result)
});

app.listen(PORT, console.log(`app listening on port ${PORT}`));