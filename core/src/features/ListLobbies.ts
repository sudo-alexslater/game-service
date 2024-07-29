import { IFeature } from "@alexslater-io/common";
import { LobbyService } from "../lib/services/LobbyService";
import { Lobby } from "../lib/types/Lobby";

export type ListLobbiesOptions = {};
export class ListLobbies
	implements IFeature<ListLobbiesOptions, Promise<Lobby[]>>
{
	constructor(private lobbyService = new LobbyService()) {}

	public async run(options: ListLobbiesOptions) {
		return this.lobbyService.list();
	}
}
