const express = require("express");
const cors = require("cors");
const db = require("./models");
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const authRoutes = require("./routes/auth");

app.use("/api/auth", authRoutes);

app.get("/", (req, res) => {
  res.send("SERVER AKTIF");
});

db.sequelize.sync().then(() => {
  app.listen(PORT, () => {
    console.log(`Server nyala di http://localhost:${PORT}`);
  });
}).catch(err => {
  console.log("Gagal konek DB:", err);
});