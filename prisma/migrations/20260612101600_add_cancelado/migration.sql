-- AlterTable
ALTER TABLE "aquisicao" ADD COLUMN     "cancelado" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "justificativaCancelamento" VARCHAR(500);
