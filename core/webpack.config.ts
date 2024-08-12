import { readdirSync } from "fs";
import path from "path";

const outDir = path.resolve(__dirname, "dist");
const inDir = path.resolve(__dirname, "src/lambdas");
const entryPoints = readdirSync(inDir).map((file) => path.resolve(inDir, file));

module.exports = {
	entry: entryPoints.reduce(
		(acc, entryPoint) => {
			const fileName = path.basename(entryPoint, ".ts");
			acc[fileName] = entryPoint;
			return acc;
		},
		{} as Record<string, string>,
	),
	mode: "production",
	module: {
		rules: [
			{
				test: /\.tsx?$/,
				use: "ts-loader",
				exclude: /node_modules/,
			},
		],
		parser: {
			javascript: {
				dynamicImportMode: "eager",
			},
		},
	},
	resolve: {
		extensions: [".tsx", ".ts", ".js"],
	},
	output: {
		path: outDir,
		filename: "[name].js",
		libraryTarget: "commonjs",
		compareBeforeEmit: true,
		sourceMapFilename: "[file].map",
	},
	target: "node",
	optimization: { minimize: false },
};
