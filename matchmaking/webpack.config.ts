import path from "path";

const outDir = path.resolve(__dirname, "dist");

module.exports = {
	entry: {
		index: "./src/index.ts",
	},
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
