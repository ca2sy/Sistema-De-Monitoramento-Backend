const express = require("express")
const router = express.Router()
const prisma = require("../prismaClient")

router.get("/", async (req, res) => {
  try {
    const [
      aquisicoes,
      totalValor,
      porStatus,
      porTipo,
      porSecretaria,
      concluidas
    ] = await Promise.all([
      prisma.aquisicao.findMany({
        include: {
          statusAquisicao: true,
          tipoAquisicao: true,
          secretaria: true,
          etapaAquisicao: true,
        }
      }),
      prisma.aquisicao.aggregate({ _sum: { valorEstimado: true } }),
      prisma.aquisicao.groupBy({
        by: ["statusAquisicaoId"],
        _count: { _all: true },
        _sum: { valorEstimado: true }
      }),
      prisma.aquisicao.groupBy({
        by: ["tipoAquisicaoId"],
        _count: { _all: true },
        _sum: { valorEstimado: true }
      }),
      prisma.aquisicao.groupBy({
        by: ["secretariaId"],
        _count: { _all: true }
      }),
      prisma.aquisicao.findMany({
        where: {
          etapaAquisicao: { nome: { contains: "Concluído", mode: "insensitive" } }
        },
        include: { statusAquisicao: true }
      })
    ])


    const statusList = await prisma.statusAquisicao.findMany()
    const tiposList = await prisma.tipoAquisicao.findMany()
    const secretariasList = await prisma.secretaria.findMany()


    const porMes = aquisicoes.reduce((acc, a) => {
      const mes = new Date(a.criadoEm || a.dataLimite).toLocaleDateString("pt-BR", { month: "short", year: "2-digit" })
      acc[mes] = (acc[mes] || 0) + 1
      return acc
    }, {})

    
    const concluidasNoPrazo = concluidas.filter(a => a.statusAquisicao?.nome !== "Atrasado").length
    const concluidasAtrasadas = concluidas.filter(a => a.statusAquisicao?.nome === "Atrasado").length

    res.json({
      totais: {
        total: aquisicoes.length,
        canceladas: aquisicoes.filter(a => a.cancelado).length,
        concluidas: concluidas.length,
        valorTotal: totalValor._sum.valorEstimado || 0,
        concluidasNoPrazo,
        concluidasAtrasadas
      },
      porStatus: porStatus.map(s => ({
        nome: statusList.find(st => st.id === s.statusAquisicaoId)?.nome || "—",
        quantidade: s._count._all,
        valor: s._sum.valorEstimado || 0
      })),
      porTipo: porTipo.map(t => ({
        nome: tiposList.find(ti => ti.id === t.tipoAquisicaoId)?.nome || "—",
        quantidade: t._count._all,
        valor: t._sum.valorEstimado || 0
      })),
      porSecretaria: porSecretaria.map(s => ({
        nome: secretariasList.find(se => se.id === s.secretariaId)?.nome || "—",
        quantidade: s._count._all
      })),
      porMes: Object.entries(porMes).map(([mes, quantidade]) => ({ mes, quantidade }))
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
})

module.exports = router