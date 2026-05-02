const BASE_URL = "http://localhost:8080/";
function parseInput(input) {
    const firstSpace = input.indexOf(" ");
    if (firstSpace === -1) {
        return { method: "GET", path: "", body: "" };
    }
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
export async function makeRequest(input) {
    const { method, path, body } = parseInput(input);
    const options = {
        method: method.toUpperCase(),
        headers: {},
    };
    if ((method.toUpperCase() === "POST" || method.toUpperCase() === "PUT") && body) {
        options.headers = {
            "Content-Type": "application/json",
        };
        options.body = body;
    }
    const response = await fetch(BASE_URL + path, options);
    const text = await response.text();
    const resultDisplay = document.getElementById("result");
    if (resultDisplay) {
        resultDisplay.textContent =
            method.toUpperCase() + " " + BASE_URL + path +
                "\nStatus: " + response.status +
                "\n\n" + text;
    }
    if (!response.ok) {
        throw new Error(text);
    }
    try {
        return JSON.parse(text);
    }
    catch {
        return text;
    }
}
export function renderTable(data, config) {
    const container = document.getElementById(config.containerId);
    if (!(container instanceof HTMLElement)) {
        throw new Error("Could not find table container: " + config.containerId);
    }
    container.innerHTML = "";
    const columns = data.columns;
    const rows = data.rows;
    const table = document.createElement("table");
    table.border = "1";
    const headerRow = document.createElement("tr");
    for (const col of columns) {
        const th = document.createElement("th");
        th.textContent = col;
        headerRow.appendChild(th);
    }
    const actionsHeader = document.createElement("th");
    actionsHeader.textContent = "Actions";
    headerRow.appendChild(actionsHeader);
    table.appendChild(headerRow);
    for (const row of rows) {
        const tr = document.createElement("tr");
        for (const value of row) {
            const td = document.createElement("td");
            td.textContent = value === null || value === undefined ? "" : String(value);
            tr.appendChild(td);
        }
        const pkIndex = columns.indexOf(config.primaryKey);
        if (pkIndex === -1) {
            throw new Error("Primary key not found in columns: " + config.primaryKey);
        }
        const pkValue = row[pkIndex];
        const actions = document.createElement("td");
        const editButton = document.createElement("button");
        editButton.textContent = "Edit";
        editButton.onclick = () => config.onEdit(pkValue, columns, row);
        const deleteButton = document.createElement("button");
        deleteButton.textContent = "Delete";
        deleteButton.onclick = () => config.onDelete(pkValue);
        actions.appendChild(editButton);
        actions.appendChild(deleteButton);
        tr.appendChild(actions);
        table.appendChild(tr);
    }
    container.appendChild(table);
}
//# sourceMappingURL=database_page.js.map