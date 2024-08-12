import { ResourceId } from "@alexslater-io/common";

export type Lobby = {
	id: ResourceId;
	minPlayers: number;
	maxPlayers: number;
};
