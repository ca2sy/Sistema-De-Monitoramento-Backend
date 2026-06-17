const express = require("express")
const router = express.Router()
const prisma = require("../prismaClient")

router.get("/", async (req, res) => {
  try {
    const projetos = await prisma.projeto.findMany({
      orderBy: { nome: "asc" }
    })
    res.json(projetos)
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
})

module.exports = router