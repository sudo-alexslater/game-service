import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";

export class DynamoProvider {
	private static _instance: DynamoDBDocumentClient;
	public static get instance() {
		if (!this._instance) {
			this._instance = DynamoDBDocumentClient.from(
				new DynamoDBClient({ region: "eu-west-1" })
			);
		}
		return this._instance;
	}
}
