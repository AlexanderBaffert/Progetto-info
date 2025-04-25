document.addEventListener('DOMContentLoaded', function() {
    const filterForm = document.getElementById('filter-form');
    const resultsContainer = document.getElementById('filter-results');
    
    // Check if we're on a page with the filter form
    if (!filterForm) return;
    
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
        
        // Build query parameters
        let params = new URLSearchParams();
        if (brand) params.append('brand', brand);
        if (minPrice) params.append('min_price', minPrice);
        if (maxPrice) params.append('max_price', maxPrice);
        if (minPower) params.append('min_power', minPower);
        if (maxPower) params.append('max_power', maxPower); 
        if (minSeatHeight) params.append('min_seat_height', minSeatHeight);
        if (maxSeatHeight) params.append('max_seat_height', maxSeatHeight);
        
        // Show loading state
        resultsContainer.innerHTML = '<p class="loading">Searching motorcycles...</p>';
        
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
    
    // Display filtered results
    function displayResults(bikes) {
        resultsContainer.innerHTML = '';
        
        if (bikes.length === 0) {
            resultsContainer.innerHTML = '<p class="no-results">No motorcycles match your criteria.</p>';
            return;
        }
        
        const resultsHeading = document.createElement('h3');
        resultsHeading.textContent = `Found ${bikes.length} matching motorcycles`;
        resultsContainer.appendChild(resultsHeading);
        
        const resultsGrid = document.createElement('div');
        resultsGrid.className = 'results-grid';
        
        bikes.forEach(bike => {
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
            
            // Correggi path A2 se scritto in minuscolo
            imgSrc = imgSrc.replace('/bikes/a2/', '/bikes/A2/');
            
            // Se l'immagine non ha un percorso completo, aggiungilo
            if (imgSrc && !imgSrc.startsWith('/') && !imgSrc.startsWith('http')) {
                imgSrc = '/' + imgSrc;
            }
            
            // Debug
            console.log(`Image path for ${bike.name}: ${imgSrc}`);
            
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
            
            resultsGrid.appendChild(bikeCard);
        });
        
        resultsContainer.appendChild(resultsGrid);
        
        // Ensure the results container is visible
        resultsContainer.style.display = 'block';
        
        // Position the results container properly
        const filterPanel = document.getElementById('filterPanel');
        if (filterPanel) {
            // Scroll to the results with a bit of offset
            setTimeout(() => {
                resultsContainer.scrollIntoView({ 
                    behavior: 'smooth',
                    block: 'nearest'
                });
            }, 100);
        }
    }
});
