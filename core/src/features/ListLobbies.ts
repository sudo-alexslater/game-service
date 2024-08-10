import { IFeature } from "@alexslater-io/common";
import { Lobby } from "@alexslater-io/matchmaking-api";
import { LobbyService } from "../lib/services/LobbyService";

export type ListLobbiesOptions = {};
export class ListLobbies
	implements IFeature<ListLobbiesOptions, Promise<Lobby[]>>
{
	constructor(private lobbyService = new LobbyService()) {}

	public async run(options: ListLobbiesOptions) {
		return this.lobbyService.list();
	}
}
