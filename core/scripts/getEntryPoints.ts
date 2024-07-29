import { readdirSync } from "fs";
import path from "path";

const lambdaHandlersPath = path.resolve(__dirname, "../src/handlers");
export function getEntryPoints() {
	const lambdaHandlers = readdirSync(lambdaHandlersPath);
	return lambdaHandlers.map((fileName) => `${lambdaHandlersPath}/${fileName}`);
}
