import { IFeature } from "@alexslater-io/common";
import { Lobby, LobbyService } from "@alexslater-io/gaming-service-common";

export type CreateLobbyOptions = {
	minPlayers: number;
	maxPlayers: number;
};
export class CreateLobby
	implements IFeature<CreateLobbyOptions, Promise<Lobby | undefined>>
{
	constructor(private lobbyService = new LobbyService()) {}

	public async run({ minPlayers, maxPlayers }: CreateLobbyOptions) {
		const lobby = this.lobbyService.create({ minPlayers, maxPlayers });
		try {
			await this.lobbyService.store(lobby);
		} catch (error) {
			console.error("Error storing lobby", error);
			return;
		}
		return lobby;
	}
}
