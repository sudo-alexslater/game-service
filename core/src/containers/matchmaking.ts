import express from "express";

const app = express();
const PORT = process.env.PORT;

app.get("/", (req, res) => {
	res.send(JSON.stringify({ message: "Hello World" }));
});
app.get("/health", (req, res) => {
	res.send(JSON.stringify({ message: "HEALTHY" }));
});
app.listen(PORT, () => {
	console.log(`Server is running on port ${PORT}!`);
});
