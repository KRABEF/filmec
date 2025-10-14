const express =  require('express');
const app = express();
const PORT = 3000;

app.use(express.json());
app.get('/', (req, res) => {
    res.json({login:"Ivan", eamil:'hih@gmail.com', password:'2332', registr:'2025-10-10'})
})

app.listen(PORT, () => {
     console.log(`Server is running on port: ${PORT}`);
})
app.get('/films', (req, res) => {
    res.send('films')
})