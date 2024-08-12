// Original file: src/protos/matchmaking.proto

import type * as grpc from '@grpc/grpc-js'
import type { MethodDefinition } from '@grpc/proto-loader'
import type { DeregisterPlayerRequest as _matchmaking_DeregisterPlayerRequest, DeregisterPlayerRequest__Output as _matchmaking_DeregisterPlayerRequest__Output } from '../matchmaking/DeregisterPlayerRequest';
import type { DeregisterPlayerResponse as _matchmaking_DeregisterPlayerResponse, DeregisterPlayerResponse__Output as _matchmaking_DeregisterPlayerResponse__Output } from '../matchmaking/DeregisterPlayerResponse';
import type { RegisterPlayerRequest as _matchmaking_RegisterPlayerRequest, RegisterPlayerRequest__Output as _matchmaking_RegisterPlayerRequest__Output } from '../matchmaking/RegisterPlayerRequest';
import type { RegisterPlayerResponse as _matchmaking_RegisterPlayerResponse, RegisterPlayerResponse__Output as _matchmaking_RegisterPlayerResponse__Output } from '../matchmaking/RegisterPlayerResponse';

export interface LobbyClient extends grpc.Client {
  DeregisterPlayer(argument: _matchmaking_DeregisterPlayerRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_matchmaking_DeregisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  DeregisterPlayer(argument: _matchmaking_DeregisterPlayerRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_matchmaking_DeregisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  DeregisterPlayer(argument: _matchmaking_DeregisterPlayerRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_matchmaking_DeregisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  DeregisterPlayer(argument: _matchmaking_DeregisterPlayerRequest, callback: grpc.requestCallback<_matchmaking_DeregisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  deregisterPlayer(argument: _matchmaking_DeregisterPlayerRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_matchmaking_DeregisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  deregisterPlayer(argument: _matchmaking_DeregisterPlayerRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_matchmaking_DeregisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  deregisterPlayer(argument: _matchmaking_DeregisterPlayerRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_matchmaking_DeregisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  deregisterPlayer(argument: _matchmaking_DeregisterPlayerRequest, callback: grpc.requestCallback<_matchmaking_DeregisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  
  RegisterPlayer(argument: _matchmaking_RegisterPlayerRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_matchmaking_RegisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  RegisterPlayer(argument: _matchmaking_RegisterPlayerRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_matchmaking_RegisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  RegisterPlayer(argument: _matchmaking_RegisterPlayerRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_matchmaking_RegisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  RegisterPlayer(argument: _matchmaking_RegisterPlayerRequest, callback: grpc.requestCallback<_matchmaking_RegisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  registerPlayer(argument: _matchmaking_RegisterPlayerRequest, metadata: grpc.Metadata, options: grpc.CallOptions, callback: grpc.requestCallback<_matchmaking_RegisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  registerPlayer(argument: _matchmaking_RegisterPlayerRequest, metadata: grpc.Metadata, callback: grpc.requestCallback<_matchmaking_RegisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  registerPlayer(argument: _matchmaking_RegisterPlayerRequest, options: grpc.CallOptions, callback: grpc.requestCallback<_matchmaking_RegisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  registerPlayer(argument: _matchmaking_RegisterPlayerRequest, callback: grpc.requestCallback<_matchmaking_RegisterPlayerResponse__Output>): grpc.ClientUnaryCall;
  
}

export interface LobbyHandlers extends grpc.UntypedServiceImplementation {
  DeregisterPlayer: grpc.handleUnaryCall<_matchmaking_DeregisterPlayerRequest__Output, _matchmaking_DeregisterPlayerResponse>;
  
  RegisterPlayer: grpc.handleUnaryCall<_matchmaking_RegisterPlayerRequest__Output, _matchmaking_RegisterPlayerResponse>;
  
}

export interface LobbyDefinition extends grpc.ServiceDefinition {
  DeregisterPlayer: MethodDefinition<_matchmaking_DeregisterPlayerRequest, _matchmaking_DeregisterPlayerResponse, _matchmaking_DeregisterPlayerRequest__Output, _matchmaking_DeregisterPlayerResponse__Output>
  RegisterPlayer: MethodDefinition<_matchmaking_RegisterPlayerRequest, _matchmaking_RegisterPlayerResponse, _matchmaking_RegisterPlayerRequest__Output, _matchmaking_RegisterPlayerResponse__Output>
}
