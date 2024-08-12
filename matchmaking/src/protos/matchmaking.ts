import type * as grpc from '@grpc/grpc-js';
import type { MessageTypeDefinition } from '@grpc/proto-loader';

import type { LobbyClient as _matchmaking_LobbyClient, LobbyDefinition as _matchmaking_LobbyDefinition } from './matchmaking/Lobby';

type SubtypeConstructor<Constructor extends new (...args: any) => any, Subtype> = {
  new(...args: ConstructorParameters<Constructor>): Subtype;
};

export interface ProtoGrpcType {
  matchmaking: {
    DeregisterPlayerRequest: MessageTypeDefinition
    DeregisterPlayerResponse: MessageTypeDefinition
    Lobby: SubtypeConstructor<typeof grpc.Client, _matchmaking_LobbyClient> & { service: _matchmaking_LobbyDefinition }
    RegisterPlayerRequest: MessageTypeDefinition
    RegisterPlayerResponse: MessageTypeDefinition
  }
}

