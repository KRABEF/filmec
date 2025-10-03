require('dotenv').config();

const express = require('express');
const requestLogger = require('../middlewares/requestLogger.js');

const app = express();
const PORT = process.env.BACK_PORT || 3000;

app.use(express.json());
app.use(requestLogger);

app.get('/', (req, res) => {
  res.json({ name: 'Яч', age: 99 });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
