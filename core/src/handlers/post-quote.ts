import { APIGatewayEvent } from "aws-lambda";
import { CreateQuote } from "../features/CreateQuote";

export const handler = async (event: APIGatewayEvent) => {
	try {
		const body = JSON.parse(event.body || "{}");
		if (!body.amount) {
			return {
				statusCode: 400,
				body: JSON.stringify({
					message: "Missing amount in request",
				}),
			};
		}

		const fn = new CreateQuote();
		const newQuote = fn.run({});

		console.log("Quote created and stored: ", newQuote);

		return {
			statusCode: 200,
			body: JSON.stringify(newQuote),
		};
	} catch (error) {
		console.error("Error fetching quote", error);
		return {
			statusCode: 500,
			body: JSON.stringify({
				message: "Error fetching quote",
			}),
		};
	}
};
