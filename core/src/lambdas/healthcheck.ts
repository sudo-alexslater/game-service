import { APIGatewayEvent } from "aws-lambda";

export const handler = async (event: APIGatewayEvent) => {
	console.log("Sending pong in response to healthcheck");
	return {
		statusCode: 200,
		body: JSON.stringify({
			message: "Gaming Service Healthy",
		}),
	};
};
