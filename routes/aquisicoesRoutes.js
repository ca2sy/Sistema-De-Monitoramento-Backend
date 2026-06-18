const express = require("express");
const router = express.Router();
const service = require("../services/aquisicoesService")

router.get("/", service.listarAquisicoes);
router.post("/", service.cadastrarAquisicao);
router.delete("/:codigo", service.excluirAquisicao)
router.patch("/:codigo/checklist/:subEtapaId", service.marcarChecklist)
router.patch("/:codigo/cancelar", service.cancelarAquisicao)

module.exports = router;