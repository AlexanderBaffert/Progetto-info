// Funzionalità originale (eventuali elementi legacy)
document.getElementById("menu-button").addEventListener("click", function() {
    const formContainer = document.getElementById("form-container");
    const welcomeText = document.querySelector(".animated-text");
    if (formContainer && formContainer.classList.contains("visible")) {
        formContainer.classList.remove("visible");
        this.textContent = "Menu";
        if (welcomeText) {
            welcomeText.style.display = "block"; // mostra il testo di benvenuto
        }
    } else if (formContainer) {
        formContainer.classList.add("visible");
        this.textContent = "Close";
        if (welcomeText) {
            welcomeText.style.display = "none"; // nascondi il testo di benvenuto
        }
    }
});

// Nuova funzionalità per il menu overlay
document.getElementById("menu-button").addEventListener("click", function() {
    document.getElementById("menu-overlay").style.display = "block";
});

document.getElementById("close-menu").addEventListener("click", function() {
    document.getElementById("menu-overlay").style.display = "none";
});

