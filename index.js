require("dotenv").config();
const express = require("express");
const cors = require('cors');
const app = express();


const port = process.env.PORT || 3001;

app.use(express.json());


const allowedOrigins = [
  'http://localhost:3000',
  'https://sistema-de-monitoramento-front-end-ochre.vercel.app',
  'https://sistema-de-monitoramento-front-end.vercel.app'
]

app.use(cors({
  origin: function(origin, callback) {
    if (!origin || allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true)
    } else {
      callback(new Error('Not allowed by CORS'))
    }
  }
}))

app.use("/aquisicoes", require("./routes/aquisicoesRoutes"));
app.use("/", require("./routes/tabelasApoioRoutes"));
app.use("/dashboard", require("./routes/dashboardRoutes"))

app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);    
});