import { describe, expect, test } from "@jest/globals";
import { beforeEach } from "node:test";
import { CreateQuote } from "../../src/features/CreateQuote";
import { MockQuoteService } from "../mocks/MockQuoteService";
const sum = (num1: number, num2: number) => num1 + num2;

describe("Create Quote", () => {
	const quoteService = new MockQuoteService();
	beforeEach(() => {
		quoteService.reset();
	});
	test("should trigger create quote", async () => {
		const sut = new CreateQuote(quoteService.mock);
		const result = await sut.run({});
		expect(result).toBeDefined();
		expect(quoteService.numOfCreateCalls).toBe(1);
	});
});
