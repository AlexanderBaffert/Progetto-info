import sqlite3
import os

def init_db():
    # Percorso del database
    db_path = "database.db"  # Aggiorna con il percorso corretto
    
    # Percorso del file SQL
    sql_path = "queries/init.sql"  # Aggiorna con il percorso corretto
    
    # Verifica se i file esistono
    if not os.path.exists(sql_path):
        print(f"Errore: File SQL non trovato: {sql_path}")
        return
    
    try:
        # Connessione al database
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # Leggi ed esegui il file SQL
        with open(sql_path, 'r') as sql_file:
            sql_script = sql_file.read()
            
        # Esegui lo script SQL
        cursor.executescript(sql_script)
        
        # Commit dei cambiamenti
        conn.commit()
        
        # Verifica se i dati sono stati inseriti
        cursor.execute("SELECT COUNT(*) FROM Bikes")
        count = cursor.fetchone()[0]
        print(f"Inseriti {count} record nella tabella Bikes.")
        
        cursor.execute("SELECT COUNT(*) FROM Color")
        count = cursor.fetchone()[0]
        print(f"Inseriti {count} record nella tabella Color.")
        
        cursor.execute("SELECT COUNT(*) FROM Image")
        count = cursor.fetchone()[0]
        print(f"Inseriti {count} record nella tabella Image.")
        
        cursor.execute("SELECT COUNT(*) FROM Description")
        count = cursor.fetchone()[0]
        print(f"Inseriti {count} record nella tabella Description.")
        
        # Chiudi la connessione
        cursor.close()
        conn.close()
        
        print("Database inizializzato con successo!")
        
    except sqlite3.Error as e:
        print(f"Errore SQLite: {str(e)}")
    except Exception as e:
        print(f"Errore: {str(e)}")

if __name__ == "__main__":
    init_db()
