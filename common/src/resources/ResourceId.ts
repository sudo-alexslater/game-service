import { randomBytes } from "crypto";
import { ResourceType } from "./ResourceType";

export type ResourceId = `${ResourceType}-${string}`;
export function generateResourceId(type: ResourceType): ResourceId {
	const guid = randomBytes(16).toString("hex");
	return `${type}-${guid}`;
}
