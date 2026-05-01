const BASE_URL = "http://localhost:8080/";

const fetchButton = document.getElementById("fetchButton") as HTMLButtonElement;
const endpointInput = document.getElementById("endpointInput") as HTMLInputElement;
const resultDisplay = document.getElementById("result") as HTMLPreElement;

async function makeRequest(path: string) {
    try {
        const url = BASE_URL + path;
        resultDisplay.textContent = "Loading...";


        const response = await fetch(url);

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const data = await response.json();
        
        resultDisplay.textContent = JSON.stringify(data, null, 2);

    } catch (err: unknown) {
        if (err instanceof Error) {
            resultDisplay.textContent = "Request failed: " + err.message;
        } else {
            resultDisplay.textContent = "An unknown error occurred.";
        }
        console.error("Fetch error:", err);
    }
}

fetchButton.addEventListener("click", () => {
    const endpoint = endpointInput.value.trim();
    if (endpoint) {
        makeRequest(endpoint);
    } else {
        resultDisplay.textContent = "Please enter an endpoint.";
    }
});

endpointInput.addEventListener("keypress", (event) => {
    if (event.key === "Enter") {
        fetchButton.click();
    }
});