async function name() {
    const response = await fetch(`http://localhost:8080/helloWorld`);
    let response_str = await response.json();
    console.log(response_str);
}
name();
export {};
