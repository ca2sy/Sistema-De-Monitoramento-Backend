-- CreateTable
CREATE TABLE "Aquisicao" (
    "codigo" INTEGER NOT NULL,
    "tipoAquisicaoId" INTEGER NOT NULL,
    "metodoAquisicaoId" INTEGER NOT NULL,
    "EtapaAquisicaoId" INTEGER NOT NULL,
    "descricao" VARCHAR(800) NOT NULL,
    "valorEstimado" DECIMAL(65,30) NOT NULL,
    "responsavel" VARCHAR(200) NOT NULL,
    "dataLimite" TIMESTAMP(3) NOT NULL,
    "statusAquisicaoId" INTEGER NOT NULL,
    "secretariaId" INTEGER NOT NULL,

    CONSTRAINT "Aquisicao_pkey" PRIMARY KEY ("codigo")
);

-- CreateTable
CREATE TABLE "TipoAquisicao" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(255) NOT NULL,

    CONSTRAINT "TipoAquisicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MetodoAquisicao" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(80) NOT NULL,

    CONSTRAINT "MetodoAquisicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EtapaAquisicao" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,
    "concluida" BOOLEAN NOT NULL,

    CONSTRAINT "EtapaAquisicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StatusAquisicao" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,

    CONSTRAINT "StatusAquisicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Secretaria" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,

    CONSTRAINT "Secretaria_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Aquisicao" ADD CONSTRAINT "Aquisicao_tipoAquisicaoId_fkey" FOREIGN KEY ("tipoAquisicaoId") REFERENCES "TipoAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Aquisicao" ADD CONSTRAINT "Aquisicao_metodoAquisicaoId_fkey" FOREIGN KEY ("metodoAquisicaoId") REFERENCES "MetodoAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Aquisicao" ADD CONSTRAINT "Aquisicao_EtapaAquisicaoId_fkey" FOREIGN KEY ("EtapaAquisicaoId") REFERENCES "EtapaAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Aquisicao" ADD CONSTRAINT "Aquisicao_statusAquisicaoId_fkey" FOREIGN KEY ("statusAquisicaoId") REFERENCES "StatusAquisicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Aquisicao" ADD CONSTRAINT "Aquisicao_secretariaId_fkey" FOREIGN KEY ("secretariaId") REFERENCES "Secretaria"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
