import { generateResourceId, MockOf } from "@alexslater-io/common";
import { LobbyService } from "../../src/lib/services/LobbyService";
import { Lobby } from '../../src/lib/types/Lobby';
\export class MockLobbyService implements MockOf<LobbyService> {
	public reset(): void {
		console.log("Resetting Mock Lobby Service");
		this.mockedCreateResult = {
			id: generateResourceId("gaming", "lobby"),
		};
		this.mockedListResult = [];
		this.numOfCreateCalls = 0;
	}
	public get mock() {
		return this as unknown as LobbyService;
	}

	public mockedCreateResult: Lobby = {
		id: generateResourceId("gaming", "lobby"),
	};
	public numOfCreateCalls: number = 0;
	public create(): Lobby {
		this.numOfCreateCalls++;
		return this.mockedCreateResult;
	}
	public async store(lobby: Lobby) {
		console.log("Storing lobby: ", lobby);
		return;
	}

	public mockedListResult: Lobby[] = [];
	public async list(): Promise<Lobby[]> {
		console.log("Listing lobbies");
		return this.mockedListResult;
	}
}
