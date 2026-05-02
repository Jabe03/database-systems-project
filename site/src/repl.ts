export {};

import readline from "readline";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

const BASE_URL = "http://localhost:8080/";

function parseInput(input: string) {
  const firstSpace = input.indexOf(" ");
  if (firstSpace === -1) return { method: "GET", path: "", body: "" };

  const secondSpace = input.indexOf(" ", firstSpace + 1);

  const method = input.substring(0, firstSpace);

  if (secondSpace === -1) {
    const path = input.substring(firstSpace + 1);
    return { method, path, body: "" };
  }

  const path = input.substring(firstSpace + 1, secondSpace);
  const body = input.substring(secondSpace + 1);

  return { method, path, body };
}

async function makeRequest(input: string) {
  const { method, path, body } = parseInput(input);

  try {
    const url = BASE_URL + path;

    const options: any = {
      method: method.toUpperCase(),
      headers: {},
    };

    if (method.toUpperCase() === "POST" && body) {
      options.headers["Content-Type"] = "application/json";
      options.body = body;
    }

    const response = await fetch(url, options);

    const text = await response.text();
    console.log(`\n${method.toUpperCase()} ${url}`);
    console.log("Status:", response.status);
    console.log(text);
  } catch (err) {
    console.error("Request failed:", err);
  }
}

function prompt() {
  rl.question("\nEnter request (e.g. GET tutorCount): ", async (input: string) => {
    if (input === "exit") {
      rl.close();
      return;
    }

   

    await makeRequest(input);
    prompt();
  });
}

console.log("HTTP REPL: Type endpoints like 'helloWorld'");
prompt();