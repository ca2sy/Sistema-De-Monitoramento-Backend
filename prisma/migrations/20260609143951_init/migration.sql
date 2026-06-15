/*
  Warnings:

  - You are about to drop the `Aquisicao` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `AquisicaoChecklist` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ChecklistItem` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `EtapaAquisicao` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `MetodoAquisicao` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `TipoAquisicao` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Aquisicao" DROP CONSTRAINT "Aquisicao_EtapaAquisicaoId_fkey";

-- DropForeignKey
ALTER TABLE "Aquisicao" DROP CONSTRAINT "Aquisicao_metodoAquisicaoId_fkey";

-- DropForeignKey
ALTER TABLE "Aquisicao" DROP CONSTRAINT "Aquisicao_secretariaId_fkey";

-- DropForeignKey
ALTER TABLE "Aquisicao" DROP CONSTRAINT "Aquisicao_statusAquisicaoId_fkey";

-- DropForeignKey
ALTER TABLE "Aquisicao" DROP CONSTRAINT "Aquisicao_tipoAquisicaoId_fkey";

-- DropForeignKey
ALTER TABLE "AquisicaoChecklist" DROP CONSTRAINT "AquisicaoChecklist_aquisicaoCodigo_fkey";

-- DropForeignKey
ALTER TABLE "AquisicaoChecklist" DROP CONSTRAINT "AquisicaoChecklist_checklistItemId_fkey";

-- DropForeignKey
ALTER TABLE "ChecklistItem" DROP CONSTRAINT "ChecklistItem_etapaAquisicaoId_fkey";

-- DropTable
DROP TABLE "Aquisicao";

-- DropTable
DROP TABLE "AquisicaoChecklist";

-- DropTable
DROP TABLE "ChecklistItem";

-- DropTable
DROP TABLE "EtapaAquisicao";

-- DropTable
DROP TABLE "MetodoAquisicao";

-- DropTable
DROP TABLE "TipoAquisicao";

-- CreateTable
CREATE TABLE "aquisicao" (
    "codigo" VARCHAR(80) NOT NULL,
    "tipoAquisicaoId" INTEGER NOT NULL,
    "metodoAquisicaoId" INTEGER NOT NULL,
    "etapaAquisicaoId" INTEGER NOT NULL,
    "descricaoObjetoNome" VARCHAR(100) NOT NULL,
    "valorEstimado" DECIMAL(65,30) NOT NULL,
    "responsavel" VARCHAR(200) NOT NULL,
    "dataLimite" TIMESTAMP(3) NOT NULL,
    "statusAquisicaoId" INTEGER NOT NULL,
    "secretariaId" INTEGER NOT NULL,

    CONSTRAINT "aquisicao_pkey" PRIMARY KEY ("codigo")
);

-- CreateTable
CREATE TABLE "tipoAquisicao" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(255) NOT NULL,

    CONSTRAINT "tipoAquisicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "metodoAquisicao" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(80) NOT NULL,

    CONSTRAINT "metodoAquisicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "etapaAquisicao" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,
    "ordem" INTEGER NOT NULL,

    CONSTRAINT "etapaAquisicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "checklistItem" (
    "id" SERIAL NOT NULL,
    "descricao" VARCHAR(300) NOT NULL,
    "etapaAquisicaoId" INTEGER NOT NULL,

    CONSTRAINT "checklistItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "aquisicaoChecklist" (
    "id" SERIAL NOT NULL,
    "aquisicaoCodigo" TEXT NOT NULL,
    "checklistItemId" INTEGER NOT NULL,
    "concluido" BOOLEAN NOT NULL DEFAULT false,
    "concluidoEm" TIMESTAMP(3),

    CONSTRAINT "aquisicaoChecklist_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "aquisicaoChecklist_aquisicaoCodigo_checklistItemId_key" ON "aquisicaoChecklist"("aquisicaoCodigo", "checklistItemId");

-- AddForeignKey
ALTER TABLE "aquisicao" ADD CONSTRAINT "aquisicao_tipoAquisicaoId_fkey" FOREIGN KEY ("tipoAquisicaoId") REFERENCES "tipoAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aquisicao" ADD CONSTRAINT "aquisicao_metodoAquisicaoId_fkey" FOREIGN KEY ("metodoAquisicaoId") REFERENCES "metodoAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aquisicao" ADD CONSTRAINT "aquisicao_etapaAquisicaoId_fkey" FOREIGN KEY ("etapaAquisicaoId") REFERENCES "etapaAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aquisicao" ADD CONSTRAINT "aquisicao_statusAquisicaoId_fkey" FOREIGN KEY ("statusAquisicaoId") REFERENCES "StatusAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aquisicao" ADD CONSTRAINT "aquisicao_secretariaId_fkey" FOREIGN KEY ("secretariaId") REFERENCES "Secretaria"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "checklistItem" ADD CONSTRAINT "checklistItem_etapaAquisicaoId_fkey" FOREIGN KEY ("etapaAquisicaoId") REFERENCES "etapaAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aquisicaoChecklist" ADD CONSTRAINT "aquisicaoChecklist_aquisicaoCodigo_fkey" FOREIGN KEY ("aquisicaoCodigo") REFERENCES "aquisicao"("codigo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aquisicaoChecklist" ADD CONSTRAINT "aquisicaoChecklist_checklistItemId_fkey" FOREIGN KEY ("checklistItemId") REFERENCES "checklistItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
