import { IFeature } from "@alexslaterio/common";
import { QuoteService } from "../lib/services/QuoteService";
import { Quote } from "../lib/types/Quote";

export type CreateQuoteOptions = {};
export class CreateQuote implements IFeature<CreateQuoteOptions, Quote> {
	constructor(private quoteService = new QuoteService()) {}

	public async run(options: CreateQuoteOptions) {
		return this.quoteService.create();
	}
}
