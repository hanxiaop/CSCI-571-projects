

const express = require('express');
const path = require('path');
const app = express();

const apiRequest = require('./server/routes/apiRequest');





app.use(express.static(path.join(__dirname, 'dist/hw8hwork')));
app.use('/apiRequest', apiRequest);



app.get('*', (req, res)=>{
  res.sendFile(path.join(__dirname, 'dist/hw8hwork/index.html'))

});



const port = process.env.PORT || 8081;
app.listen(port, (req, res)=>{

  console.log(`Running on por ${port}`);
});

module.exports = app;
