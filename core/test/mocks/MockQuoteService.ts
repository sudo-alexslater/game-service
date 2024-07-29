import { generateResourceId, MockOf } from "@alexslaterio/common";
import { QuoteService } from "../../src/lib/services/QuoteService";
import { Quote } from "../../src/lib/types/Quote";
export class MockQuoteService implements MockOf<QuoteService> {
	public reset(): void {
		console.log("Resetting Mock Quote Service");
		this.mockedCreateResult = {
			id: generateResourceId("quote"),
		};
		this.numOfCreateCalls = 0;
	}
	public get mock() {
		return this as unknown as QuoteService;
	}

	public mockedCreateResult: Quote = {
		id: generateResourceId("quote"),
	};
	public numOfCreateCalls: number = 0;
	public create(): Quote {
		this.numOfCreateCalls++;
		return this.mockedCreateResult;
	}
	public store(quote: Quote): void {}
}
