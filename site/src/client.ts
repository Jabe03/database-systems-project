export {};

import readline from "readline";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

const BASE_URL = "http://localhost:8080/";

async function makeRequest(path: string) {
  try {
    const url = BASE_URL + path;
    const response = await fetch(url);

    const text = await response.text();
    console.log(`\nResponse from ${url}:`);
    console.log(text);
  } catch (err) {
    console.error("Request failed:", err);
  }
}

function prompt() {
  rl.question("\nEnter endpoint (or 'exit'): ", async (input: string) => {
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