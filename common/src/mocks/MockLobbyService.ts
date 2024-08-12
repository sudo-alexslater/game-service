import { generateResourceId, MockOf } from "@alexslater-io/common";
import { LobbyService } from "../services/LobbyService";
import { Lobby } from "../types/Lobby";

export class MockLobbyService implements MockOf<LobbyService> {
	constructor() {
		this.reset();
	}

	public get mock() {
		return this as unknown as LobbyService;
	}

	public mockedCreateResult: Lobby;
	public numOfCreateCalls: number;
	public mockedListResult: Lobby[];
	public reset(): void {
		console.log("Resetting Mock Lobby Service");
		this.mockedCreateResult = {
			id: generateResourceId("gaming", "lobby"),
			minPlayers: 0,
			maxPlayers: 5,
		};
		this.mockedListResult = [];
		this.numOfCreateCalls = 0;
	}

	public create(): Lobby {
		this.numOfCreateCalls++;
		return this.mockedCreateResult;
	}
	public async store(lobby: Lobby) {
		console.log("Storing lobby: ", lobby);
		return;
	}
	public async list(): Promise<Lobby[]> {
		console.log("Listing lobbies");
		return this.mockedListResult;
	}
}
