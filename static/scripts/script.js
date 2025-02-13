document.getElementById("menu-button").addEventListener("click", function() {
    const formContainer = document.getElementById("form-container");
    const welcomeText = document.querySelector(".animated-text");
    if (formContainer.classList.contains("visible")) {
        formContainer.classList.remove("visible");
        this.textContent = "Home";
        welcomeText.style.display = "block"; // show welcome text
    } else {
        formContainer.classList.add("visible");
        this.textContent = "Close";
        welcomeText.style.display = "none"; // hide welcome text
    }
});

