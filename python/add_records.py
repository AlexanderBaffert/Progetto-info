import sqlite3
import os
import traceback

def add_records():
    # Percorso del database
    db_path = "database.db"  # Aggiorna con il percorso corretto
    
    # Percorso del file SQL per i nuovi record
    sql_path = "queries/add_records_fixed.sql"  # Usa il file SQL corretto
    
    # Verifica se i file esistono
    if not os.path.exists(db_path):
        print(f"Errore: Database non trovato: {db_path}")
        return
        
    if not os.path.exists(sql_path):
        print(f"Errore: File SQL non trovato: {sql_path}")
        return
    
    try:
        # Connessione al database
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # Prima mostra i record esistenti
        print("Record esistenti prima dell'inserimento:")
        cursor.execute("SELECT COUNT(*) FROM Bikes")
        count = cursor.fetchone()[0]
        print(f"- Bikes: {count} record")
        
        # Leggi il file SQL
        with open(sql_path, 'r') as sql_file:
            sql_script = sql_file.read()
        
        print("\nEsecuzione dello script SQL...")
        
        # Esegui lo script completo (non una query alla volta)
        cursor.executescript(sql_script)
        conn.commit()
        
        # Verifica le modifiche apportate
        print("\nVerifica delle modifiche apportate:")
        
        # Trova quali moto sono state modificate o aggiunte
        # (questo è dinamico e non specifico per un ID particolare)
        cursor.execute("""
            SELECT DISTINCT b.id, b.model 
            FROM Bikes b
            JOIN (
                SELECT bike_id, COUNT(*) as cnt 
                FROM Description 
                GROUP BY bike_id
                HAVING cnt > 0
            ) d ON b.id = d.bike_id
            ORDER BY b.id
        """)
        
        modified_bikes = cursor.fetchall()
        
        if modified_bikes:
            print("Moto modificate o aggiunte:")
            for bike in modified_bikes:
                print(f"ID: {bike[0]}, Modello: {bike[1]}")
                
                # Mostra informazioni complete sulla moto
                cursor.execute("SELECT * FROM Bikes WHERE id = ?", (bike[0],))
                bike_details = cursor.fetchone()
                print(f"  Dettagli: {bike_details}")
                
                # Mostra colori associati
                cursor.execute("SELECT COUNT(*) FROM Color WHERE bike_id = ?", (bike[0],))
                color_count = cursor.fetchone()[0]
                print(f"  Colori: {color_count}")
                
                # Mostra immagini associate
                cursor.execute("SELECT COUNT(*) FROM Image WHERE bike_id = ?", (bike[0],))
                image_count = cursor.fetchone()[0]
                print(f"  Immagini: {image_count}")
                
                # Mostra descrizioni associate
                cursor.execute("SELECT COUNT(*) FROM Description WHERE bike_id = ?", (bike[0],))
                description_count = cursor.fetchone()[0]
                print(f"  Descrizioni: {description_count}")
                
                print("")
        else:
            print("Nessuna moto modificata o aggiunta.")
        
        print("\nRecord dopo l'inserimento:")
        cursor.execute("SELECT COUNT(*) FROM Bikes")
        count = cursor.fetchone()[0]
        print(f"- Bikes: {count} record")
        
        # Chiudi la connessione
        cursor.close()
        conn.close()
        
        print("\nOperazione completata con successo!")
        
    except sqlite3.Error as e:
        print(f"Errore SQLite: {str(e)}")
        traceback.print_exc()
    except Exception as e:
        print(f"Errore: {str(e)}")
        traceback.print_exc()

if __name__ == "__main__":
    add_records()
