import { PropsOf } from "../types/PropsOf";

export type MockOf<T> = PropsOf<T> & {
	reset(): void;
	mock: T;
};
