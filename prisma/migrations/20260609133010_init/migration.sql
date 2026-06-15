/*
  Warnings:

  - The primary key for the `Aquisicao` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `concluida` on the `EtapaAquisicao` table. All the data in the column will be lost.
  - Added the required column `ordem` to the `EtapaAquisicao` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Aquisicao" DROP CONSTRAINT "Aquisicao_pkey",
ALTER COLUMN "codigo" SET DATA TYPE VARCHAR(80),
ADD CONSTRAINT "Aquisicao_pkey" PRIMARY KEY ("codigo");

-- AlterTable
ALTER TABLE "EtapaAquisicao" DROP COLUMN "concluida",
ADD COLUMN     "ordem" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "ChecklistItem" (
    "id" SERIAL NOT NULL,
    "descricao" VARCHAR(300) NOT NULL,
    "etapaAquisicaoId" INTEGER NOT NULL,

    CONSTRAINT "ChecklistItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AquisicaoChecklist" (
    "id" SERIAL NOT NULL,
    "aquisicaoCodigo" TEXT NOT NULL,
    "checklistItemId" INTEGER NOT NULL,
    "concluido" BOOLEAN NOT NULL DEFAULT false,
    "concluidoEm" TIMESTAMP(3),

    CONSTRAINT "AquisicaoChecklist_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "AquisicaoChecklist_aquisicaoCodigo_checklistItemId_key" ON "AquisicaoChecklist"("aquisicaoCodigo", "checklistItemId");

-- AddForeignKey
ALTER TABLE "ChecklistItem" ADD CONSTRAINT "ChecklistItem_etapaAquisicaoId_fkey" FOREIGN KEY ("etapaAquisicaoId") REFERENCES "EtapaAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AquisicaoChecklist" ADD CONSTRAINT "AquisicaoChecklist_aquisicaoCodigo_fkey" FOREIGN KEY ("aquisicaoCodigo") REFERENCES "Aquisicao"("codigo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AquisicaoChecklist" ADD CONSTRAINT "AquisicaoChecklist_checklistItemId_fkey" FOREIGN KEY ("checklistItemId") REFERENCES "ChecklistItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
