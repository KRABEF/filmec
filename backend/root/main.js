const express =  require('express');
const app = express();
const usersRouter = require('../route/users');

app.use(express.json());
app.use('/api/users',usersRouter);

app.listen(3000, () =>  console.log(`Server is running on port: 3000`));
