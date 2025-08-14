import { drizzle } from 'drizzle-orm/node-postgres'

export const db = drizzle(process.env.DATABASE_URL, {
  logger: process.env.NODE_ENV === 'development',
})