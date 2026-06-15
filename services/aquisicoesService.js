const prisma = require("../prismaClient");

const listarAquisicoes = async (req, res) => {
  try {
    const { busca, secretariaId, statusId, dataLimite, tipoId } = req.query

    const aquisicoes = await prisma.aquisicao.findMany({
      where: {
        ...(secretariaId && { secretariaId: parseInt(secretariaId) }),
        ...(statusId     && { statusAquisicaoId: parseInt(statusId) }),
        ...(dataLimite   && { dataLimite: { lte: new Date(dataLimite) } }),
        ...(tipoId       && { tipoAquisicaoId: parseInt(tipoId) }),
        ...(busca && {
          OR: [
            { codigo:              { contains: busca, mode: "insensitive" } },
            { responsavel:         { contains: busca, mode: "insensitive" } },
            { descricaoObjetoNome: { contains: busca, mode: "insensitive" } },
          ]
        }),
      },
      include: {
        tipoAquisicao: true,
        metodoAquisicao: true,
        etapaAquisicao: true,
        statusAquisicao: true,
        secretaria: true,
        aquisicaoChecklists: {
          include: { checklistItem: { include: { etapaAquisicao: true } } }
        }
      }
    })
    const aquisicoesCom = await Promise.all(aquisicoes.map(async (a) => {
      if (a.cancelado) return a

      const hoje = new Date()
      const limite = new Date(a.dataLimite)
      const diffDias = Math.ceil((limite - hoje) / (1000 * 60 * 60 * 24))

      if (diffDias < 0 && a.statusAquisicao?.nome !== "Atrasado") {
        const novoStatus = await prisma.statusAquisicao.findFirst({ where: { nome: "Atrasado" } })
        if (novoStatus) {
          await prisma.aquisicao.update({ where: { codigo: a.codigo }, data: { statusAquisicaoId: novoStatus.id } })
          return { ...a, statusAquisicaoId: novoStatus.id, statusAquisicao: novoStatus }
        }
      }

      return a
    }))

    res.json(aquisicoesCom)
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
}

const cadastrarAquisicao = async (req, res) => {
  try {
    const camposObrigatorios = [
      'codigo', 'tipoAquisicaoId', 'metodoAquisicaoId', 'etapaAquisicaoId',
      'descricaoObjetoNome', 'valorEstimado', 'responsavel', 'dataLimite',
      'statusAquisicaoId', 'secretariaId'
    ]
    const camposFaltando = camposObrigatorios.filter(campo => !req.body[campo])
    if (camposFaltando.length > 0) {
      return res.status(400).json({ error: `Campos obrigatórios faltando: ${camposFaltando.join(', ')}` })
    }

    const {
      codigo, tipoAquisicaoId, metodoAquisicaoId, etapaAquisicaoId,
      descricaoObjetoNome, valorEstimado, responsavel, dataLimite,
      statusAquisicaoId, secretariaId
    } = req.body

    const novaAquisicao = await prisma.aquisicao.create({
      data: {
        codigo,
        tipoAquisicaoId,
        metodoAquisicaoId,
        etapaAquisicaoId,
        descricaoObjetoNome,
        valorEstimado,
        responsavel,
        dataLimite: new Date(dataLimite),
        statusAquisicaoId,
        secretariaId
      }
    })

    const etapaAtual = await prisma.etapaAquisicao.findUnique({ where: { id: etapaAquisicaoId } })
    const todosItens = await prisma.checklistItem.findMany({ include: { etapaAquisicao: true } })

    await prisma.aquisicaoChecklist.createMany({
      data: todosItens.map(item => ({
        aquisicaoCodigo: novaAquisicao.codigo,
        checklistItemId: item.id,
        concluido: item.etapaAquisicao.ordem < etapaAtual.ordem
      }))
    })

    const aquisicaoCompleta = await prisma.aquisicao.findUnique({
      where: { codigo: novaAquisicao.codigo },
      include: {
        tipoAquisicao: true,
        metodoAquisicao: true,
        etapaAquisicao: true,
        statusAquisicao: true,
        secretaria: true,
        aquisicaoChecklists: {
          include: { checklistItem: { include: { etapaAquisicao: true } } }
        }
      }
    })

    res.status(201).json(aquisicaoCompleta)
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
}

const excluirAquisicao = async (req, res) => {
  try {
    const { codigo } = req.params
    await prisma.aquisicaoChecklist.deleteMany({ where: { aquisicaoCodigo: codigo } })
    await prisma.aquisicao.delete({ where: { codigo } })
    res.json({ message: "Aquisição excluída com sucesso" })
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
}

const cancelarAquisicao = async (req, res) => {
  try {
    const { codigo } = req.params
    const { justificativa } = req.body
    if (!justificativa?.trim()) {
      return res.status(400).json({ error: "Justificativa é obrigatória para cancelar" })
    }
    const aquisicao = await prisma.aquisicao.update({
      where: { codigo },
      data: { cancelado: true, justificativaCancelamento: justificativa },
      include: {
        tipoAquisicao: true,
        metodoAquisicao: true,
        etapaAquisicao: true,
        statusAquisicao: true,
        secretaria: true
      }
    })
    res.json(aquisicao)
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
}

const marcarChecklist = async (req, res) => {
  try {
    const { codigo, itemId } = req.params
    const { concluido } = req.body

    await prisma.aquisicaoChecklist.upsert({
      where: { aquisicaoCodigo_checklistItemId: { aquisicaoCodigo: codigo, checklistItemId: parseInt(itemId) } },
      update: { concluido, concluidoEm: concluido ? new Date() : null },
      create: { aquisicaoCodigo: codigo, checklistItemId: parseInt(itemId), concluido, concluidoEm: concluido ? new Date() : null }
    })

    const aquisicao = await prisma.aquisicao.findUnique({
      where: { codigo },
      include: { etapaAquisicao: true }
    })

    const todosItensEtapa = await prisma.checklistItem.findMany({
      where: { etapaAquisicaoId: aquisicao.etapaAquisicaoId }
    })

    const itensConcluidos = await prisma.aquisicaoChecklist.count({
      where: {
        aquisicaoCodigo: codigo,
        checklistItemId: { in: todosItensEtapa.map(i => i.id) },
        concluido: true
      }
    })

    let etapaAtual = aquisicao.etapaAquisicao

    if (concluido && itensConcluidos === todosItensEtapa.length) {
      const proximaEtapa = await prisma.etapaAquisicao.findFirst({
        where: { ordem: { gt: aquisicao.etapaAquisicao.ordem } },
        orderBy: { ordem: "asc" }
      })
      if (proximaEtapa) {
        await prisma.aquisicao.update({ where: { codigo }, data: { etapaAquisicaoId: proximaEtapa.id } })
        etapaAtual = proximaEtapa
      }
    } else if (!concluido) {
      const itemDesmarcado = await prisma.checklistItem.findUnique({
        where: { id: parseInt(itemId) },
        include: { etapaAquisicao: true }
      })

      if (itemDesmarcado.etapaAquisicao.ordem < aquisicao.etapaAquisicao.ordem) {
        const etapasPosteriores = await prisma.etapaAquisicao.findMany({
          where: { ordem: { gt: itemDesmarcado.etapaAquisicao.ordem } }
        })

        const itensPosteriores = await prisma.checklistItem.findMany({
          where: { etapaAquisicaoId: { in: etapasPosteriores.map(e => e.id) } }
        })

        await prisma.aquisicaoChecklist.updateMany({
          where: {
            aquisicaoCodigo: codigo,
            checklistItemId: { in: itensPosteriores.map(i => i.id) }
          },
          data: { concluido: false, concluidoEm: null }
        })

        await prisma.aquisicao.update({
          where: { codigo },
          data: { etapaAquisicaoId: itemDesmarcado.etapaAquisicaoId }
        })
        etapaAtual = itemDesmarcado.etapaAquisicao
      }
    }

    const aquisicaoAtualizada = await prisma.aquisicao.findUnique({
      where: { codigo },
      include: {
        etapaAquisicao: true,
        aquisicaoChecklists: {
          include: { checklistItem: { include: { etapaAquisicao: true } } }
        }
      }
    })

    res.json(aquisicaoAtualizada)
  } catch (error) {
    console.error(error)
    res.status(500).json({ error: error.message })
  }
}

module.exports = { listarAquisicoes, cadastrarAquisicao, excluirAquisicao, cancelarAquisicao, marcarChecklist }