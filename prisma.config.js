require("dotenv").config();

const { defineConfig } = require("prisma/config");
const { PrismaPg } = require("@prisma/adapter-pg");

module.exports = defineConfig({
  schema: "prisma/schema.prisma",
  migrations: {
    path: "prisma/migrations",
  },
  datasource: {
    url: process.env.DIRECT_URL,
    adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL }),
  },
});