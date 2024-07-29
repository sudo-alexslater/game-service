export interface IFeature<O, R> {
	run(options: O): R;
}
