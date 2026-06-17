const express = require("express")
const router = express.Router()
const prisma = require("../prismaClient")

router.get("/tipos-aquisicao",   async (req, res) => { res.json(await prisma.tipoAquisicao.findMany()) })
router.get("/etapas-aquisicao", async (req, res) => {
  res.json(await prisma.etapaAquisicao.findMany({
    orderBy: { ordem: "asc" },
    include: { checklistItems: true }
  }))
})
router.get("/status-aquisicao",  async (req, res) => { res.json(await prisma.statusAquisicao.findMany()) })
router.get("/secretarias",       async (req, res) => { res.json(await prisma.secretaria.findMany()) })

module.exports = router