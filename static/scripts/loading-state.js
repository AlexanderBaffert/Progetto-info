/**
 * Script per gestire lo stato di caricamento e la visibilità dei modelli
 */
document.addEventListener('DOMContentLoaded', function() {
    // Flag per tracciare se i modelli sono già stati caricati
    let modelsLoaded = false;
    
    // Rendiamo la funzione disponibile globalmente
    window.checkModelsLoaded = function() {
        return modelsLoaded;
    };
    
    window.setModelsLoaded = function(loaded) {
        modelsLoaded = loaded;
    };
    
    // Controlla subito se i modelli sono caricati
    const resultsContainer = document.getElementById('filter-results');
    
    // Se la pagina ha il contenitore dei risultati ma nessun modello è caricato
    if (resultsContainer && !modelsLoaded) {
        if (typeof window.loadAllModels === 'function') {
            // Carica immediatamente i modelli
            setTimeout(() => {
                window.loadAllModels();
                modelsLoaded = true;
                
                // Quando i modelli sono caricati, assicurati che la parte superiore della pagina sia visibile
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            }, 100);
        } else {
            // Se la funzione non è disponibile, aspetta che lo script filter.js sia completamente caricato
            const checkInterval = setInterval(() => {
                if (typeof window.loadAllModels === 'function') {
                    window.loadAllModels();
                    modelsLoaded = true;
                    clearInterval(checkInterval);
                }
            }, 100);
            
            // Previeni loop infiniti
            setTimeout(() => clearInterval(checkInterval), 5000);
        }
    }
});
