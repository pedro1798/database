const button = document.getElementById("test-button");
const message = document.getElementById("message");

button.addEventListener("click", () => {
    message.textContent = "JavaScript도 정상적으로 동작합니다!";
});
