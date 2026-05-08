const express = require("express");
const cors = require("cors");
const path = require("path");
const db = require("./models");
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

db.sequelize.sync().then(() => {
    app.listen(PORT, () => {
        console.log(`Server nyala di http://localhost:${PORT}`);
    });
}).catch(err => {
    console.log("Gagal konek DB:", err);
});