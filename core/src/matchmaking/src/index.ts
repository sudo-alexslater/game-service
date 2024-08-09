import express from "express";

const app = express();
const PORT = process.env.PORT;

app.get("/", (req, res) => {
	console.log("responding, Hello World");
	res.send(JSON.stringify({ message: "Hello World" }));
});
app.get("/health", (req, res) => {
	console.log('responding, "OK"');
	res.status(200).send("OK");
});
app.listen(PORT, () => {
	console.log(`Server is running on port ${PORT}!`);
});
