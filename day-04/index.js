const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')

const app = express()
app.use(cors())

let db = []

app.get('/', (req, res) => res.json(db))
// app.get('/', (req, res) => res.sendStatus(500))
app.post('/', bodyParser.json(), (req, res) => {
  db = req.body
  res.json(db)
})

module.exports = app.listen(3000, () => {
  console.log('Listening on 3000')
})
