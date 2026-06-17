/*
  Warnings:

  - You are about to drop the column `checklistItemId` on the `aquisicaoChecklist` table. All the data in the column will be lost.
  - You are about to drop the `checklistItem` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[aquisicaoCodigo,subEtapaId]` on the table `aquisicaoChecklist` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `projetoId` to the `aquisicao` table without a default value. This is not possible if the table is not empty.
  - Added the required column `subEtapaId` to the `aquisicaoChecklist` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tipoAquisicaoId` to the `etapaAquisicao` table without a default value. This is not possible if the table is not empty.
  - Added the required column `projetoId` to the `tipoAquisicao` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "aquisicaoChecklist" DROP CONSTRAINT "aquisicaoChecklist_checklistItemId_fkey";

-- DropForeignKey
ALTER TABLE "checklistItem" DROP CONSTRAINT "checklistItem_etapaAquisicaoId_fkey";

-- DropIndex
DROP INDEX "aquisicaoChecklist_aquisicaoCodigo_checklistItemId_key";

-- AlterTable
ALTER TABLE "aquisicao" ADD COLUMN     "projetoId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "aquisicaoChecklist" DROP COLUMN "checklistItemId",
ADD COLUMN     "subEtapaId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "etapaAquisicao" ADD COLUMN     "tipoAquisicaoId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "tipoAquisicao" ADD COLUMN     "projetoId" INTEGER NOT NULL;

-- DropTable
DROP TABLE "checklistItem";

-- CreateTable
CREATE TABLE "projeto" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(200) NOT NULL,
    "descricao" VARCHAR(500),
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "projeto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subEtapa" (
    "id" SERIAL NOT NULL,
    "descricao" VARCHAR(300) NOT NULL,
    "ordem" INTEGER NOT NULL DEFAULT 0,
    "etapaAquisicaoId" INTEGER NOT NULL,

    CONSTRAINT "subEtapa_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "aquisicaoChecklist_aquisicaoCodigo_subEtapaId_key" ON "aquisicaoChecklist"("aquisicaoCodigo", "subEtapaId");

-- AddForeignKey
ALTER TABLE "tipoAquisicao" ADD CONSTRAINT "tipoAquisicao_projetoId_fkey" FOREIGN KEY ("projetoId") REFERENCES "projeto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "etapaAquisicao" ADD CONSTRAINT "etapaAquisicao_tipoAquisicaoId_fkey" FOREIGN KEY ("tipoAquisicaoId") REFERENCES "tipoAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subEtapa" ADD CONSTRAINT "subEtapa_etapaAquisicaoId_fkey" FOREIGN KEY ("etapaAquisicaoId") REFERENCES "etapaAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aquisicao" ADD CONSTRAINT "aquisicao_projetoId_fkey" FOREIGN KEY ("projetoId") REFERENCES "projeto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aquisicaoChecklist" ADD CONSTRAINT "aquisicaoChecklist_subEtapaId_fkey" FOREIGN KEY ("subEtapaId") REFERENCES "subEtapa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
