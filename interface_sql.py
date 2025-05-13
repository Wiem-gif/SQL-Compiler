import tkinter as tk
from tkinter import messagebox
import subprocess

def valider_requete():
    requetes = entree.get("1.0", tk.END).strip().splitlines()
    resultats_text.delete("1.0", tk.END)  # Vider les anciens résultats

    for i, requete in enumerate(requetes, start=1):
        requete = requete.strip()
        if not requete.endswith(";"):
            requete += ";"

        try:
            process = subprocess.Popen(["./a.out"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
            stdout, stderr = process.communicate(requete)

            message = stdout.strip() or stderr.strip()
            ligne_resultat = f"Requête {i} : "

            if "REQUETE ACCEPTEE" in stdout:
                resultats_text.insert(tk.END, ligne_resultat + "✅ " + message + "\n", "valide")
            elif "Erreur" in stdout or stderr:
                resultats_text.insert(tk.END, ligne_resultat + "❌ " + message + "\n", "erreur")
            else:
                resultats_text.insert(tk.END, ligne_resultat + "⚠️ Résultat incertain\n", "indetermine")

        except FileNotFoundError:
            messagebox.showerror("Erreur système", "Le fichier exécutable 'parser' est introuvable.\nAssurez-vous de l’avoir compilé avec flex et bison.")
            return
        except Exception as e:
            messagebox.showerror("Erreur inattendue", str(e))
            return

# Interface Tkinter
fenetre = tk.Tk()
fenetre.title("Validateur de Requête SQL")
fenetre.geometry("700x600")

label = tk.Label(fenetre, text="Entrez vos requêtes SQL (une par ligne) :", font=("Arial", 14))
label.pack(pady=10)

entree = tk.Text(fenetre, height=10, font=("Courier", 12))
entree.pack(padx=20, pady=10, fill=tk.BOTH)

bouton_valider = tk.Button(fenetre, text="Valider", command=valider_requete, bg="green", fg="white", font=("Arial", 12))
bouton_valider.pack(pady=10)

# Zone d'affichage des résultats
resultats_text = tk.Text(fenetre, height=10, font=("Courier", 12))
resultats_text.pack(padx=20, pady=10, fill=tk.BOTH, expand=True)

# Définir les couleurs pour les tags
resultats_text.tag_config("valide", foreground="green")
resultats_text.tag_config("erreur", foreground="red")
resultats_text.tag_config("indetermine", foreground="orange")

fenetre.mainloop()
