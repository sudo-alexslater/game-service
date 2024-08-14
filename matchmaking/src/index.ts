import { loadPackageDefinition, Server } from "@grpc/grpc-js";
import { loadSync } from "@grpc/proto-loader";
import express from "express";
import { ProtoGrpcType } from "./protos/matchmaking";
import { LobbyHandlers } from "./protos/matchmaking/Lobby";

const PORT = process.env.PORT;
const GAME_SERVER_PORT = 8082;

const players: any[] = [];
const lobbyHandlers: LobbyHandlers = {
	DeregisterPlayer: (server, send) => {
		console.log("Deregistering player: ", server);
		const index = players.indexOf(server);
		if (index > -1) {
			players.splice(index, 1);
		}
		send(null, { success: true });
	},
	RegisterPlayer: (server, send) => {
		console.log("Registering player: ", server);
		players.push(server);
		send(null, { success: true });
	},
};

const packageDefinition = loadSync("./proto/matchmaking.proto");
const proto = loadPackageDefinition(
	packageDefinition
) as unknown as ProtoGrpcType;
const server = new Server();
server.addService(proto.matchmaking.Lobby.service, lobbyHandlers);

const app = express();
app.get("/", (req, res) => {
	console.log("responding, Hello World");
	res.send(JSON.stringify({ message: "Hello World" }));
});
app.get("/health", (req, res) => {
	console.log('responding, "OK"');
	res.status(200).send("OK");
});
app.listen(PORT, () => {
	console.log(`Server is running on port ${PORT}!`);
});
