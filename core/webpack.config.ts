import path from "path";
import { getEntryPoints } from "./scripts/getEntryPoints";

const dist = path.resolve(__dirname, "dist");
const entryPoints = getEntryPoints();

module.exports = {
	entry: entryPoints.reduce((acc, entryPoint) => {
		const fileName = path.basename(entryPoint, ".ts");
		acc[fileName] = entryPoint;
		return acc;
	}, {} as Record<string, string>),
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
		path: dist,
		filename: "[name].js",
		libraryTarget: "commonjs",
		compareBeforeEmit: true,
		sourceMapFilename: "[file].map",
	},
	target: "node",
	optimization: { minimize: false },
};
