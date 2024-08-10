import { DynamoProvider, generateResourceId } from "@alexslater-io/common";
import { Lobby } from "@alexslater-io/matchmaking-api";
import { PutCommand, QueryCommand } from "@aws-sdk/lib-dynamodb";

export class LobbyService {
	private readonly lobbyTableName = process.env.LOBBY_TABLE_NAME;

	constructor(private dbClient = DynamoProvider.instance) {}

	public create(): Lobby {
		return {
			id: generateResourceId("gaming", "lobby"),
		};
	}

	public async store(lobby: Lobby) {
		const request = new PutCommand({
			TableName: this.lobbyTableName,
			Item: lobby,
		});
		await this.dbClient.send(request);
	}

	public async list(): Promise<Lobby[]> {
		const request = new QueryCommand({
			TableName: this.lobbyTableName,
		});
		const result = await this.dbClient.send(request);
		if (!result.Items) {
			return [];
		}
		return result.Items as unknown as Promise<Lobby[]>;
	}
}
