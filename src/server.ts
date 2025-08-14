import { server } from "./app.ts"
// import { dotenv } from "dotenv"

server.listen({ port: 3333 }).then(() => {
  console.log('HTTP server running!')
})