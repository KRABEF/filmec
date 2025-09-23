require('dotenv').config();

const express = require('express');

const app = express();
const PORT = process.env.DB_PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
	res.json({ name: 'Keril' });
});

app.listen(PORT, () => {
	console.log(`Server is running on port ${PORT}`);
});
