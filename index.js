require("dotenv").config();
const express = require("express");
const cors = require('cors');
const app = express();


const port = process.env.PORT || 3001;

app.use(express.json());


app.use(cors({
    origin: process.env.NODE_ENV === 'production' 
        ? 'https://seu-frontend.vercel.app'  
        : 'http://localhost:3000'
}));

app.use("/aquisicoes", require("./routes/aquisicoesRoutes"));
app.use("/", require("./routes/tabelasApoioRoutes"));
app.use("/dashboard", require("./routes/dashboardRoutes"))

app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);    
});