


function toggleUserDropdown() {
    var dropdown = document.getElementById("user-dropdown");
    dropdown.style.display = dropdown.style.display === "none" || dropdown.style.display === "" ? "block" : "none";
}

function toggleFilter() {
    const panel = document.getElementById("filterPanel");
    const button = document.querySelector(".filter-toggle");
    
    if (panel.classList.contains("active")) {
        panel.classList.remove("active");
        button.innerHTML = '<span>Models compatible: </span> +';
    } else {
        panel.classList.add("active");
        button.innerHTML = '<span>Models compatible: </span> -';
    }
}

function logoutUser() {
    fetch("/logout", { method: "POST" })
      .then(response => response.json())
      .then(data => {
          if(data.status === "ok") {
              window.location.reload();
          }
      });
}

// Toggle integrated menu panel below the button.
document.getElementById("menu-button").addEventListener("click", function() {
    var menuPanel = document.getElementById("menu-panel");
    if (menuPanel.classList.contains("visible")) {
        menuPanel.classList.remove("visible");
        this.textContent = "Menu";
    } else {
        menuPanel.classList.add("visible");
        this.textContent = "Close";
    }
});

// When "Models" is clicked, hide menu panel and show models panel
document.getElementById("models-link").addEventListener("click", function(e) {
    e.preventDefault();
    document.getElementById("menu-panel").classList.remove("visible");
    document.getElementById("models-panel").style.display = "block";
});

// When "Back" is clicked inside models panel, hide it and show menu panel again
document.getElementById("back-to-menu").addEventListener("click", function() {
    document.getElementById("models-panel").style.display = "none";
    document.getElementById("menu-panel").classList.add("visible");
});


// ----------------- Nuova funzionalità per la gestione dei modelli -----------------

document.addEventListener("DOMContentLoaded", function() {
    const modelsData = {
        sport: [
            { name: "S 1000 RR", year: "2025", img: "static/favicon/bikes/liter_bikes/s1000rr.avif" },
            { name: "R1", year: "2025", img: "static/favicon/bikes/liter_bikes/r1.avif" },
            { name: "ZX-10R", year: "2025", img: "static/favicon/bikes/liter_bikes/zx10r.jpg" },
            { name: "Panigale V4", year: "2025", img: "static/favicon/bikes/liter_bikes/v4.jpg" },
            { name: "GSX-R1000", year: "2025", img: "static/favicon/bikes/liter_bikes/GSX-R1000.jpg" },
            { name: "CBR1000RR-R", year: "2025", img: "static/favicon/bikes/liter_bikes/cbr1000rr.jpeg" },
            { name: "RSV4", year: "2025", img: "static/favicon/bikes/liter_bikes/rsv4.avif" },
        ],
        premium: [
            { name: "R1-M", year: "2025", img: "static/favicon/bikes/super_sport/r1m.jpg" },
            { name: "F4 1000", year: "2005", img: "static/favicon/bikes/super_sport/f4_1000.webp" },
            { name: "M 1000 RR", year: "2025", img: "static/favicon/bikes/super_sport/m1000rr.jpg" },
            { name: "H2R", year: "2025", img: "static/favicon/bikes/super_sport/h2r.webp" },
            { name: "Superleggera V4", year: "2024", img: "static/favicon/bikes/super_sport/superleggera.jpg" },
            { name: "Tricolore", year: "2025", img: "static/favicon/bikes/super_sport/tricolore.avif" },
        ],
        a2: [
            { name: "RS457", year: "2024", img: "static/favicon/bikes/A2/457.avif" },
            { name: "NINJA-400", year: "2023", img: "static/favicon/bikes/A2/ninja400_2.webp" },
            { name: "CBR500R", year: "2023", img: "static/favicon/bikes/A2/cbr500.png" },
            { name: "NK450", year: "2023", img: "static/favicon/bikes/A2/nk450.jpg" },
            { name: "Z500", year: "2025", img: "static/favicon/bikes/A2/z500.avif" },
            { name: "KTM_390", year: "2024", img: "static/favicon/bikes/A2/ktm_390.jpg" },
            { name: "R3", year: "2024", img: "static/favicon/bikes/A2/r3.avif" },
            { name: "MT-03", year: "2025", img: "static/favicon/bikes/A2/mt03.webp" },
            { name: "450SR-S", year: "2024", img: "static/favicon/bikes/A2/sr450.jpg" },
        ]
    };

    console.log("Models data:", modelsData);

    // Gestione click sulle categorie
    document.querySelectorAll(".category").forEach(category => {
        category.addEventListener("click", function(event) {
            event.preventDefault();
            const categoryName = this.getAttribute("data-category");
            displayModels(categoryName);
        });
    });
            
    //         // Mostra il pannello dei modelli se non è già visibile
    //         const modelsPanel = document.getElementById("models-panel");
    //         if (modelsPanel) {
    //             modelsPanel.style.display = "block";    
    //         }

    //         // Nascondi il menu principale se è aperto
    //         const menuPanel = document.getElementById("menu-panel");
    //         if (menuPanel) {
    //             menuPanel.classList.remove("visible");
    //         }

    //         // Mostra i modelli della categoria selezionata
    //         if (modelsData[categoryName]) {
    //             displayModels(categoryName);
    //         } else {
    //             console.error("Category not found:", categoryName);
    //         }
    //     });
    // });
    function displayModels(category) {
        const modelsContainer = document.getElementById("models-container");
        modelsContainer.innerHTML = "";

        if (modelsData[category].length === 0) {
            modelsContainer.innerHTML = "<p>No models available.</p>";
            return;
        }

        modelsData[category].forEach(model => {
            const modelCard = document.createElement("div");
            modelCard.classList.add("model-card");
            // Create a slug from the model name (lowercase, spaces replaced by hyphen, handle special characters)
            const slug = model.name.toLowerCase()
                            .replace(/\s+/g, '-')     // Replace spaces with hyphens
                            .replace(/_/g, '-');       // Replace underscores with hyphens
            modelCard.innerHTML = `
                <a href="/model/${slug}">
                    <img src="${model.img}" alt="${model.name}" style="width:100%; height:150px; object-fit:cover;">
                </a>
                <p class="model-year">${model.year}</p>
                <p class="model-name">${model.name}</p>
            `;

            modelsContainer.appendChild(modelCard);
        });
    }
    // function displayModels(category) {
    //     const modelsContainer = document.getElementById("models-container");
    //     if (!modelsContainer) {
    //         console.error("Models container not found!");
    //         return;
    //     }

    //     modelsContainer.innerHTML = "";
    //     console.log("Displaying models for category:", category);

    //     if (!modelsData[category] || modelsData[category].length === 0) {
    //         modelsContainer.innerHTML = "<p>No models available for this category.</p>";
    //         return;
    //     }

    //     modelsData[category].forEach(model => {
    //         const modelCard = document.createElement("div");
    //         modelCard.classList.add("model-card");
    //         const slug = model.name.toLowerCase()
    //                         .replace(/\s+/g, '-')
    //                         .replace(/_/g, '-');
    //         modelCard.innerHTML = `
    //             <a href="/model/${slug}">
    //                 <img src="${model.img}" 
    //                      alt="${model.name}" 
    //                      onerror="this.src='static/favicon/bikes/no-image.jpg'" 
    //                      style="width:100%; height:150px; object-fit:cover;">
    //                 <p class="model-year">${model.year}</p>
    //                 <p class="model-name">${model.name}</p>
    //             </a>
    //         `;
    //         modelsContainer.appendChild(modelCard);
    //     });
    // }

    // // Funzione per mostrare tutti i modelli nella pagina principale
    // function displayAllModels() {
    //     const mainContainer = document.getElementById("main-models-container");
    //     if (!mainContainer) {
    //         console.error("Main models container not found!");
    //         return;
    //     }

    //     console.log("Displaying all models...");

    //     const allModels = [
    //         ...modelsData.sport,
    //         ...modelsData.premium,
    //         ...modelsData.a2
    //     ];

    //     if (allModels.length === 0) {
    //         console.error("No models found!");
    //         return;
    //     }

    //     mainContainer.innerHTML = ''; // Pulisce il contenitore prima di aggiungere nuovi modelli

    //     allModels.forEach(model => {
    //         console.log("Adding model:", model.name);
    //         const modelCard = document.createElement("div");
    //         modelCard.classList.add("model-card");
    //         const slug = model.name.toLowerCase()
    //                         .replace(/\s+/g, '-')
    //                         .replace(/_/g, '-');
    //         modelCard.innerHTML = `
    //             <a href="/model/${slug}">
    //                 <img src="${model.img}" 
    //                      alt="${model.name}" 
    //                      onerror="this.src='static/favicon/bikes/no-image.jpg'" 
    //                      style="width:100%; height:150px; object-fit:cover;">
    //                 <p class="model-year">${model.year}</p>
    //                 <p class="model-name">${model.name}</p>
    //             </a>
    //         `;
    //         mainContainer.appendChild(modelCard);
    //     });

    //     console.log("Models displayed successfully.");
    // }

    // // Rimuovi l'event listener duplicato e chiama la funzione direttamente
    // displayAllModels();
});
