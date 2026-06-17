const express = require("express")
const router = express.Router()
const prisma = require("../prismaClient")

router.get("/tipos-aquisicao", async (req, res) => {
  try {
    const tipos = await prisma.tipoAquisicao.findMany()
    res.json(tipos)
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
})

router.get("/etapas-aquisicao", async (req, res) => {
  try {
    const { tipoId } = req.query
    
    const whereClause = {}
    if (tipoId) {
      whereClause.tipoAquisicaoId = parseInt(tipoId)
    }
    
    const etapas = await prisma.etapaAquisicao.findMany({
      where: whereClause,
      orderBy: { ordem: "asc" },
      include: { 
        subEtapas: {
          orderBy: { ordem: "asc" }
        } 
      }
    })
    
    res.json(etapas)
  } catch (error) {
    console.error("Erro ao carregar etapas:", error)
    res.status(500).json({ error: error.message })
  }
})

router.get("/status-aquisicao", async (req, res) => {
  try {
    const status = await prisma.statusAquisicao.findMany()
    res.json(status)
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
})

router.get("/secretarias", async (req, res) => {
  try {
    const secretarias = await prisma.secretaria.findMany()
    res.json(secretarias)
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
})

module.exports = router