import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";
import { APIGatewayEvent } from "aws-lambda";

export const handler = async (event: APIGatewayEvent) => {
	try {
		const requestedQuoteId = event.pathParameters?.quoteId;
		console.log(`Requested quote ID: ${requestedQuoteId}`);
		if (!requestedQuoteId) {
			return {
				statusCode: 400,
				body: JSON.stringify({
					message: "Missing quote ID in request",
				}),
			};
		}

		const quoteTableName = process.env.QUOTE_TABLE_NAME;
		const dynamoDbClient = new DynamoDBClient({
			region: "eu-west-1",
			apiVersion: "2012-08-10",
		});
		const ddbDocClient = DynamoDBDocumentClient.from(dynamoDbClient);
		const request = new GetCommand({
			TableName: quoteTableName,
			Key: { quoteId: requestedQuoteId },
		});
		const response = await ddbDocClient.send(request);
		const quote = response.Item;

		console.log("Quote:", quote);
		if (!quote) {
			return {
				statusCode: 404,
				body: JSON.stringify({
					message: "Quote not found",
				}),
			};
		}

		return {
			statusCode: 200,
			body: JSON.stringify(quote),
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
