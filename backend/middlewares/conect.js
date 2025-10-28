const {Pool} = require("pg");
const pool = new Pool({connectionString:`postgresql://postgres:postgres@localhost:5432/filmec1`});
// const pool = new Pool({
//     host: "localhost",
//     username: "postgres",
//     database: "filmec1",
//     password: "postgres"
// });

module.exports = pool;


