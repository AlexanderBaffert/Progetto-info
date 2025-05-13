document.addEventListener('DOMContentLoaded', function() {
    const filterForm = document.getElementById('filter-form');
    const resultsContainer = document.getElementById('filter-results');
    
    // Check if we're on a page with the filter form
    if (!filterForm) return;
    
    // Carica tutti i modelli all'avvio
    loadAllModels();
    
    // Rende la funzione disponibile globalmente
    window.loadAllModels = loadAllModels;
    
    filterForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Get filter values
        const brand = document.getElementById('brand') ? document.getElementById('brand').value : '';
        const minPrice = document.getElementById('min-price').value;
        const maxPrice = document.getElementById('max-price').value;
        const minPower = document.getElementById('min-power').value;
        const maxPower = document.getElementById('max-power').value;
        const minSeatHeight = document.getElementById('min-seat-height').value;
        const maxSeatHeight = document.getElementById('max-seat-height').value;
        
        // Get selected categories
        const selectedCategories = [];
        document.querySelectorAll('input[name="category"]:checked').forEach(checkbox => {
            selectedCategories.push(checkbox.value);
        });
        
        // Build query parameters
        let params = new URLSearchParams();
        if (brand) params.append('brand', brand);
        if (minPrice) params.append('min_price', minPrice);
        if (maxPrice) params.append('max_price', maxPrice);
        if (minPower) params.append('min_power', minPower);
        if (maxPower) params.append('max_power', maxPower); 
        if (minSeatHeight) params.append('min_seat_height', minSeatHeight);
        if (maxSeatHeight) params.append('max_seat_height', maxSeatHeight);
        
        // Add category parameters if selected
        if (selectedCategories.length > 0) {
            params.append('categories', selectedCategories.join(','));
        }
        
        // Show loading state
        resultsContainer.innerHTML = '<div class="loading-spinner"><div></div><div></div><div></div></div>';
        
        // Make sure the filter panel stays open to show the results
        const filterPanel = document.getElementById('filterPanel');
        if (filterPanel) {
            filterPanel.style.display = 'block';
        }
        
        // Fetch filtered bikes
        fetch(`/api/filter-models?${params.toString()}`)
            .then(response => response.json())
            .then(bikes => {
                displayResults(bikes);
            })
            .catch(error => {
                console.error('Error fetching filtered models:', error);
                resultsContainer.innerHTML = '<p class="error">Error loading results. Please try again.</p>';
            });
    });
    
    // Modifichiamo la funzione loadAllModels per fare il debug dei dati ricevuti
    function loadAllModels() {
        resultsContainer.innerHTML = '<div class="loading-spinner"><div></div><div></div><div></div></div>';
        
        fetch('/api/models')
            .then(response => response.json())
            .then(bikes => {
                // Debug - verifica quali immagini vengono ricevute dall'API
                console.log("Loaded bikes:", bikes);
                
                // Verifica che ci siano immagini per le moto premium (ID 8-13)
                const premiumBikes = bikes.filter(bike => bike.id >= 8 && bike.id <= 13);
                console.log("Premium bikes:", premiumBikes);
                
                // Mostra tutti i modelli
                displayResults(bikes);
            })
            .catch(error => {
                console.error('Error fetching models:', error);
                resultsContainer.innerHTML = '<p class="error">Error loading models. Please try again.</p>';
            });
    }
    
    // Updated displayResults function to show categories horizontally
    function displayResults(bikes) {
        resultsContainer.innerHTML = '';
        
        if (bikes.length === 0) {
            resultsContainer.innerHTML = '<p class="no-results">No motorcycles match your criteria.</p>';
            return;
        }
        
        // Group bikes by category
        const categorized = {
            sport: [],
            premium: [],
            naked: [],
            a2: []
        };
        
        bikes.forEach(bike => {
            // Categorize bikes based on ID
            if (bike.id <= 7) {
                categorized.sport.push(bike);
            } else if (bike.id <= 13) {
                categorized.premium.push(bike);
            } else if (bike.id <= 20) {
                categorized.naked.push(bike);
            } else {
                categorized.a2.push(bike);
            }
        });
        
        const resultsHeading = document.createElement('h3');
        resultsHeading.textContent = `Found ${bikes.length} matching motorcycles`;
        resultsContainer.appendChild(resultsHeading);
        
        // Create horizontal category sections
        Object.entries(categorized).forEach(([category, categoryBikes]) => {
            if (categoryBikes.length === 0) return;
            
            const categorySection = document.createElement('div');
            categorySection.className = 'category-results';
            
            const categoryHeader = document.createElement('div');
            categoryHeader.className = 'category-header';
            categoryHeader.textContent = category.charAt(0).toUpperCase() + category.slice(1);
            categorySection.appendChild(categoryHeader);
            
            const categoryModels = document.createElement('div');
            categoryModels.className = 'category-models-row';
            
            categoryBikes.forEach(bike => {
                const bikeCard = createBikeCard(bike);
                categoryModels.appendChild(bikeCard);
            });
            
            categorySection.appendChild(categoryModels);
            resultsContainer.appendChild(categorySection);
        });
        
        // Ensure the results container is visible
        resultsContainer.style.display = 'block';
        
        // Position the results container properly
        setTimeout(() => {
            resultsContainer.scrollIntoView({ 
                behavior: 'smooth',
                block: 'nearest'
            });
        }, 100);
    }
    
    // Helper function to create bike cards with consistent styling
    function createBikeCard(bike) {
        const bikeCard = document.createElement('div');
        bikeCard.className = 'bike-card';
        
        // Improved image path handling
        let imgSrc = bike.img || '';
        
        // Skip video files for thumbnails
        if (imgSrc.toLowerCase().endsWith('.mp4')) {
            // Try to find a static image with similar name by replacing extension
            imgSrc = imgSrc.replace(/\.mp4$/i, '.jpg');
            console.log(`Replaced video with image: ${imgSrc}`);
        }
        
        // DEBUG per le moto premium
        if (bike.id >= 8 && bike.id <= 13) {
            console.log(`Premium bike ${bike.name} (ID: ${bike.id}) has image: ${imgSrc}`);
        }
        
        // Correggi path A2 se scritto in minuscolo
        imgSrc = imgSrc.replace('/bikes/a2/', '/bikes/A2/');
        
        // Se l'immagine non ha un percorso completo, aggiungilo
        if (imgSrc && !imgSrc.startsWith('/') && !imgSrc.startsWith('http')) {
            imgSrc = '/' + imgSrc;
        }
        
        // Aggiunta di gestione specifica per le moto premium
        if (bike.id >= 8 && bike.id <= 13 && (!imgSrc || imgSrc.includes('no-image'))) {
            // Assegna manualmente il percorso dell'immagine se mancante
            imgSrc = `/static/favicon/bikes/super_sport/${getPremiumImageName(bike.name)}`;
            console.log(`Applied manual premium image path for ${bike.name}: ${imgSrc}`);
        }
        
        // Aggiungi un timestamp per prevenire il caching
        const timestamp = new Date().getTime();
        const imgWithCache = imgSrc.includes('?') ? 
            `${imgSrc}&_=${timestamp}` : 
            `${imgSrc}?_=${timestamp}`;
        
        bikeCard.innerHTML = `
            <div class="bike-img-container">
                <img src="${imgWithCache}" alt="${bike.name}" class="bike-img"
                     onerror="this.onerror=null; console.log('Failed to load: ${imgSrc}'); this.src='/static/favicon/bikes/no-image.jpg';">
            </div>
            <h4>${bike.name}</h4>
            <p class="bike-year">${bike.year}</p>
            <p class="bike-price">€${bike.price.toLocaleString('it-IT')}</p>
            <p class="bike-specs">
                <span class="power">${bike.power} HP</span> | 
                <span class="seat-height">${bike.seat_height} mm</span>
            </p>
            <a href="/model/${bike.slug}" class="view-details">View Details</a>
        `;
        
        return bikeCard;
    }
    
    // Funzione helper per gestire le moto premium con nomi di file specifici
    function getPremiumImageName(bikeName) {
        const nameMap = {
            "R1-M": "r1m.jpg",
            "F4 1000": "f4_1000.webp",
            "M 1000 RR": "m1000rr.jpg",
            "H2R": "h2r.webp",
            "Superleggera V4": "superleggera.jpg",
            "Tricolore": "tricolore.avif"
        };
        
        return nameMap[bikeName] || "premium_default.jpg";
    }
    
    // Aggiunta spinner CSS per caricamento
    const style = document.createElement('style');
    style.textContent = `
        .loading-spinner {
            display: flex;
            justify-content: center;
            margin: 40px 0;
        }
        .loading-spinner > div {
            width: 15px;
            height: 15px;
            margin: 0 5px;
            border-radius: 50%;
            background-color: #0066cc;
            animation: bounce 1.4s infinite ease-in-out both;
        }
        .loading-spinner > div:nth-child(1) { animation-delay: -0.32s; }
        .loading-spinner > div:nth-child(2) { animation-delay: -0.16s; }
        
        @keyframes bounce {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
    `;
    document.head.appendChild(style);
});
