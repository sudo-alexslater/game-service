import { APIGatewayEvent } from "aws-lambda";
import { ListLobbies } from "../features/ListLobbies";

export const handler = async (event: APIGatewayEvent) => {
	try {
		const fn = new ListLobbies();
		const lobbies = fn.run({});

		console.log("Lobbies returned: ", lobbies);

		return {
			statusCode: 200,
			body: JSON.stringify(lobbies),
		};
	} catch (error) {
		console.error("Error fetching lobbies: ", error);
		return {
			statusCode: 500,
			body: JSON.stringify({
				message: "Error fetching lobbies",
			}),
		};
	}
};
