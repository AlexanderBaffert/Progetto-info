// Attach form listener only on the login page
if (window.location.pathname === '/login') {
    document.getElementById("login-form").addEventListener("submit", function(event) {
        event.preventDefault(); // Prevent default only for login
        const email = document.getElementById("email").value;
        const password = document.getElementById("password").value;
        if (email === "" || password === "") {
            alert("Per favore, compila tutti i campi.");
            return;
        }
        // Simula login (collegabile a backend API)
        console.log("Email:", email);
        console.log("Password:", password);
    });
}

var menuButton = document.getElementById("menu-button");
if (menuButton) {
    menuButton.addEventListener("click", function() {
        var formContainer = document.getElementById("form-container");
        var welcomeText = document.querySelector(".animated-text");
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
}
