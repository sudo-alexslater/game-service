import { IFeature } from "@alexslater-io/common";
import { Lobby, LobbyService } from "@alexslater-io/gaming-service-common";

export type ListLobbiesOptions = {};
export class ListLobbies
	implements IFeature<ListLobbiesOptions, Promise<Lobby[]>>
{
	constructor(private lobbyService = new LobbyService()) {}

	public async run(options: ListLobbiesOptions) {
		return this.lobbyService.list();
	}
}
