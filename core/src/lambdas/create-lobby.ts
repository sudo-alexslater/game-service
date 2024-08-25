import { CreateLobbyRequest } from "@alexslater-io/gaming-service-api";
import { APIGatewayEvent } from "aws-lambda";
import { CreateLobby } from "../features/CreateLobby";

export const handler = (event: APIGatewayEvent) => {
	const body = JSON.parse(event.body || "{}") as CreateLobbyRequest;
	const fn = new CreateLobby();
	if (!body.minPlayers || !body.maxPlayers) {
		return {
			statusCode: 400,
			body: JSON.stringify({
				message: "Missing required parameters",
			}),
		};
	}
	fn.run({ minPlayers: body.minPlayers, maxPlayers: body.maxPlayers });
	return {
		statusCode: 200,
		body: JSON.stringify({
			message: "create-lobby",
		}),
	};
};
