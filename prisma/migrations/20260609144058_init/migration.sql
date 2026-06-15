/*
  Warnings:

  - You are about to drop the `Secretaria` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `StatusAquisicao` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "aquisicao" DROP CONSTRAINT "aquisicao_secretariaId_fkey";

-- DropForeignKey
ALTER TABLE "aquisicao" DROP CONSTRAINT "aquisicao_statusAquisicaoId_fkey";

-- DropTable
DROP TABLE "Secretaria";

-- DropTable
DROP TABLE "StatusAquisicao";

-- CreateTable
CREATE TABLE "statusAquisicao" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,

    CONSTRAINT "statusAquisicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "secretaria" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,

    CONSTRAINT "secretaria_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "aquisicao" ADD CONSTRAINT "aquisicao_statusAquisicaoId_fkey" FOREIGN KEY ("statusAquisicaoId") REFERENCES "statusAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aquisicao" ADD CONSTRAINT "aquisicao_secretariaId_fkey" FOREIGN KEY ("secretariaId") REFERENCES "secretaria"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
