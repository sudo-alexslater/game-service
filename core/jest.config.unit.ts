/**
 * For a detailed explanation regarding each configuration property, visit:
 * https://jestjs.io/docs/configuration
 */

import type { Config } from "jest";

const config: Config = {
	testEnvironment: "node",
	transform: {
		"^.+.tsx?$": ["ts-jest", {}],
	},
	// Stop running tests after `n` failures
	bail: 1,

	// Automatically clear mock calls, instances, contexts and results before every test
	clearMocks: true,
	collectCoverage: true,

	// An array of glob patterns indicating a set of files for which coverage information should be collected
	// collectCoverageFrom: undefined,
	coverageDirectory: "coverage",
	coverageProvider: "v8",

	testMatch: ["**/*.unit.test.ts"],
};

export default config;
