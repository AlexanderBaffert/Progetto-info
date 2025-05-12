import sqlite3
import os

def debug_database():
    # Percorso del database
    db_path = "database.db"
    
    if not os.path.exists(db_path):
        print(f"Errore: Database non trovato: {db_path}")
        return
    
    try:
        # Connessione al database
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # Check table structure
        print("=== STRUTTURA DELLE TABELLE ===")
        
        cursor.execute("PRAGMA table_info(Bikes)")
        print("\nStruttura tabella Bikes:")
        for col in cursor.fetchall():
            print(f"- {col[1]} ({col[2]})")
            
        cursor.execute("PRAGMA table_info(Color)")
        print("\nStruttura tabella Color:")
        for col in cursor.fetchall():
            print(f"- {col[1]} ({col[2]})")
        
        cursor.execute("PRAGMA table_info(Image)")
        print("\nStruttura tabella Image:")
        for col in cursor.fetchall():
            print(f"- {col[1]} ({col[2]})")
        
        cursor.execute("PRAGMA table_info(Description)")
        print("\nStruttura tabella Description:")
        for col in cursor.fetchall():
            print(f"- {col[1]} ({col[2]})")
        
        # Check if bike with ID 20 exists
        print("\n=== VERIFICA MOTO ID=20 ===")
        cursor.execute("SELECT * FROM Bikes WHERE id = 20")
        bike = cursor.fetchone()
        if bike:
            print(f"Moto trovata: {bike}")
        else:
            print("Nessuna moto con ID=20 trovata!")
        
        # Chiudi la connessione
        cursor.close()
        conn.close()
        
    except sqlite3.Error as e:
        print(f"Errore SQLite: {str(e)}")
    except Exception as e:
        print(f"Errore: {str(e)}")

if __name__ == "__main__":
    debug_database()
