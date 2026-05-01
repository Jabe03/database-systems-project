export {};

import readline from "readline";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

const BASE_URL = "http://localhost:8080/";

async function makeRequest(method: string, path: string, body?: string) {
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

    const parts = input.split(" ");

    const method = parts[0] || "GET";
    const path = parts[1] || "";
    const body = parts.slice(2).join(" ");

    await makeRequest(method, path, body);
    prompt();
  });
}

console.log("HTTP REPL: Type endpoints like 'helloWorld'");
prompt();